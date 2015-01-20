part of p2;

class World extends EventEmitter {

  /// All springs in the world. To add a spring to the world, use [addSpring].
  List<Spring> springs;


  /// All bodies in the world. To add a body to the world, use [addBody].
  List<Body> bodies;

  /// Disabled body collision pairs. See [disableBodyCollision].
  List<Body> disabledBodyCollisionPairs;

  /// The solver used to satisfy constraints and contacts. Default is {{#crossLink "GSSolver"}}{{/crossLink}}.
  GSSolver solver;

  /// The narrowphase to use to generate contacts.
  Narrowphase narrowphase;

  /// The island manager of this world.
  IslandManager islandManager;

  /// Gravity in the world. This is applied on all bodies in the beginning of each step().
  final vec2 gravity = vec2.fromValues(0, -9.78);

  /// Gravity to use when approximating the friction max force (mu*mass*gravity).
  num frictionGravity;

  /// Set to true if you want .frictionGravity to be automatically set to the length of .gravity.
  bool useWorldGravityAsFrictionGravity;

  /// If the length of .gravity is zero, and .useWorldGravityAsFrictionGravity=true, then switch to using .frictionGravity for friction instead. This fallback is useful for gravityless games.
  bool useFrictionGravityOnZeroGravity;

  /// Whether to do timing measurements during the step() or not.
  bool doProfiling;

  /// How many millisecconds the last step() took. This is updated each step if .doProfiling is set to true.
  num lastStepTime;

  /// The broadphase algorithm to use.
  Broadphase broadphase;

  /// User-added constraints.
  List<Constraint> constraints;

  /// Dummy default material in the world, used in .defaultContactMaterial
  Material defaultMaterial;

  /// The default contact material to use, if no contact material was set for the colliding materials.
  ContactMaterial defaultContactMaterial;

  /// For keeping track of what time step size we used last step
  num lastTimeStep;

  /// Enable to automatically apply spring forces each step.
  bool applySpringForces;

  /// Enable to automatically apply body damping each step.
  bool applyDamping;

  /// Enable to automatically apply gravity each step.
  bool applyGravity;

  /// Enable/disable constraint solving in each step.
  bool solveConstraints;

  /// The ContactMaterials added to the World.
  List<ContactMaterial> contactMaterials;

  /// World time.
  num time;

  /// Is true during the step().
  bool stepping;

  /// Bodies that are scheduled to be removed at the end of the step.
  List<Body> bodiesToBeRemoved;


  num fixedStepTime;

  /// Whether to enable island splitting. Island splitting can be an advantage for many things, including solver performance. See {{#crossLink "IslandManager"}}{{/crossLink}}.
  bool islandSplit;


  /// Set to true if you want to the world to emit the "impact" event. Turning this off could improve performance.
  bool emitImpactEvent;

  // Id counters
  num _constraintIdCounter;
  num _bodyIdCounter;

  Map postStepEvent;

  Map addBodyEvent;

  Map removeBodyEvent;

  Map addSpringEvent;


  Map impactEvent;

  Map postBroadphaseEvent;

  /**
   * How to deactivate bodies during simulation. Possible modes are: {{#crossLink "World/NO_SLEEPING:property"}}World.NO_SLEEPING{{/crossLink}}, {{#crossLink "World/BODY_SLEEPING:property"}}World.BODY_SLEEPING{{/crossLink}} and {{#crossLink "World/ISLAND_SLEEPING:property"}}World.ISLAND_SLEEPING{{/crossLink}}.
   * If sleeping is enabled, you might need to {{#crossLink "Body/wakeUp:method"}}wake up{{/crossLink}} the bodies if they fall asleep when they shouldn't. If you want to enable sleeping in the world, but want to disable it for a particular body, see {{#crossLink "Body/allowSleep:property"}}Body.allowSleep{{/crossLink}}.
   */
  num sleepMode;

  /// Fired when two shapes starts start to overlap. Fired in the narrowphase, during step.
  Map beginContactEvent;

  /// Fired when two shapes stop overlapping, after the narrowphase (during step).
  Map endContactEvent;

  /// Fired just before equations are added to the solver to be solved. Can be used to control what equations goes into the solver.
  Map preSolveEvent;

  // For keeping track of overlapping shapes
  Map overlappingShapesLastState;

  Map overlappingShapesCurrentState;

  OverlapKeeper overlapKeeper;


  World({Solver solver, vec2 gravity, bool doProfiling: false, Broadphase broadphase, bool islandSplit: false, bool fake: false}) : super() {

    this.springs = new List<Spring>();
    this.bodies = new List<Body>();
    this.disabledBodyCollisionPairs = new List<Body>();

    if (solver == null && !fake) {
      solver = new GSSolver();
    }
    this.solver = solver;

    this.narrowphase = new Narrowphase();

    this.islandManager = new IslandManager();

    if (gravity != null) {
      vec2.copy(this.gravity, gravity);
    }

    this.frictionGravity = vec2.length(this.gravity);
    this.useWorldGravityAsFrictionGravity = true;
    this.useFrictionGravityOnZeroGravity = true;
    this.doProfiling = doProfiling;
    this.lastStepTime = 0.0;
    this.broadphase = broadphase;
    if (this.broadphase == null) this.broadphase = new SAPBroadphase();
    this.broadphase.setWorld(this);
    this.constraints = new List<Constraint>();
    this.defaultMaterial = new Material();
    this.defaultContactMaterial = new ContactMaterial(this.defaultMaterial, this.defaultMaterial);
    this.lastTimeStep = 1 / 60;
    this.applySpringForces = true;
    this.applyDamping = true;
    this.applyGravity = true;
    this.solveConstraints = true;
    this.contactMaterials = new List<ContactMaterial>();
    this.time = 0.0;
    this.stepping = false;
    this.bodiesToBeRemoved = new List<Body>();
    this.fixedStepTime = 0.0;
    this.islandSplit = islandSplit;
    this.emitImpactEvent = true;
    this._constraintIdCounter = 0;
    this._bodyIdCounter = 0;


    postStepEvent = {
      'type': "postStep"
    };

    addBodyEvent = {
      'type': "addBody",
      'body': null
    };

    removeBodyEvent = {
      'type': "removeBody",
      'body': null
    };

    addSpringEvent = {
      'type': "addSpring",
      'sprint': null
    };


    impactEvent = {
      'type': "impact",
      'bodyA': null,
      'bodyB': null,
      'shapeA': null,
      'shapeB': null,
      'contactEquation': null
    };

    postBroadphaseEvent = {
      'type': "postBroadphase",
      'pairs': null,
    };

    sleepMode = World.NO_SLEEPING;

    beginContactEvent = {
      'type': "beginContact",
      'shapeA': null,
      'shapeB': null,
      'bodyA': null,
      'bodyB': null,
      'contactEquations': new List<ContactEquation>()
    };

    endContactEvent = {
      'type': "endContact",
      'shapeA': null,
      'shapeB': null,
      'bodyA': null,
      'bodyB': null,
    };

    preSolveEvent = {
      'type': "preSolve",
      'contactEquations': null,
      'frictionEquations': null,
    };

    // For keeping track of overlapping shapes
    this.overlappingShapesLastState = {
      'keys': []
    };

    this.overlappingShapesCurrentState = {
      'keys': []
    };

    this.overlapKeeper = new OverlapKeeper();
  }

//  init(){
//
//  }


  /**
   * Never deactivate bodies.
   * @static
   * @property {number} NO_SLEEPING
   */
  static const int NO_SLEEPING = 1;

  /**
   * Deactivate individual bodies if they are sleepy.
   * @static
   * @property {number} BODY_SLEEPING
   */
  static const int BODY_SLEEPING = 2;

  /**
   * Deactivates bodies that are in contact, if all of them are sleepy. Note that you must enable {{#crossLink "World/islandSplit:property"}}.islandSplit{{/crossLink}} for this to work.
   * @static
   * @property {number} ISLAND_SLEEPING
   */
  static const int ISLAND_SLEEPING = 4;

  /**
   * Add a constraint to the simulation.
   *
   * @method addConstraint
   * @param {Constraint} c
   */

  addConstraint(Constraint c) {
    this.constraints.add(c);
  }

  /**
   * Add a ContactMaterial to the simulation.
   * @method addContactMaterial
   * @param {ContactMaterial} contactMaterial
   */

  addContactMaterial(ContactMaterial contactMaterial) {
    this.contactMaterials.add(contactMaterial);
  }

  /**
   * Removes a contact material
   *
   * @method removeContactMaterial
   * @param {ContactMaterial} cm
   */

  removeContactMaterial(ContactMaterial cm) {
    int idx = this.contactMaterials.indexOf(cm);
    if (idx != -1) {
      Utils.splice(this.contactMaterials, idx, 1);
    }
  }

  /**
   * Get a contact material given two materials
   * @method getContactMaterial
   * @param {Material} materialA
   * @param {Material} materialB
   * @return {ContactMaterial} The matching ContactMaterial, or false on fail.
   * @todo Use faster hash map to lookup from material id's
   */

  ContactMaterial getContactMaterial(Material materialA, Material materialB) {
    List<ContactMaterial> cmats = this.contactMaterials;
    for (int i = 0,
        N = cmats.length; i != N; i++) {
      ContactMaterial cm = cmats[i];
      if ((cm.materialA.id == materialA.id) && (cm.materialB.id == materialB.id) || (cm.materialA.id == materialB.id) && (cm.materialB.id == materialA.id)) {
        return cm;
      }
    }
    return null;
  }

  /**
   * Removes a constraint
   *
   * @method removeConstraint
   * @param {Constraint} c
   */

  removeConstraint(Constraint c) {
    int idx = this.constraints.indexOf(c);
    if (idx != -1) {
      Utils.splice(this.constraints, idx, 1);
    }
  }

  static final vec2 step_r = vec2.create(),
      step_runit = vec2.create(),
      step_u = vec2.create(),
      step_f = vec2.create(),
      step_fhMinv = vec2.create(),
      step_velodt = vec2.create(),
      step_mg = vec2.create(),
      xiw = vec2.fromValues(0, 0),
      xjw = vec2.fromValues(0, 0),
      zero = vec2.fromValues(0, 0),
      interpvelo = vec2.fromValues(0, 0);

  /**
   * Step the physics world forward in time.
   *
   * There are two modes. The simple mode is fixed timestepping without interpolation. In this case you only use the first argument. The second case uses interpolation. In that you also provide the time since the function was last used, as well as the maximum fixed timesteps to take.
   *
   * @method step
   * @param {Number} dt                       The fixed time step size to use.
   * @param {Number} [timeSinceLastCalled=0]  The time elapsed since the function was last called.
   * @param {Number} [maxSubSteps=10]         Maximum number of fixed steps to take per function call.
   *
   * @example
   *     // fixed timestepping without interpolation
   *     var world = new World();
   *     world.step(0.01);
   *
   * @see http://bulletphysics.org/mediawiki-1.5.8/index.php/Stepping_The_World
   */

  step(num dt, [num timeSinceLastCalled = 0, num maxSubSteps = 10]) {
//    maxSubSteps = maxSubSteps || 10;
//    timeSinceLastCalled = timeSinceLastCalled || 0;
    //dt*=20;

    if (timeSinceLastCalled == 0) {
      // Fixed, simple stepping

      this.internalStep(dt);

      // Increment time
      this.time += dt;

    } else {

      // Compute the number of fixed steps we should have taken since the last step
      num internalSteps = ((this.time + timeSinceLastCalled) / dt).floor() - (this.time / dt).floor();
      internalSteps = min(internalSteps, maxSubSteps);

      // Do some fixed steps to catch up
      num t0 = window.performance.now();
      for (int i = 0; i != internalSteps; i++) {
        this.internalStep(dt);
        if (window.performance.now() - t0 > dt * 1000) {
          // We are slower than real-time. Better bail out.
          break;
        }
      }

      // Increment internal clock
      this.time += timeSinceLastCalled;

      // Compute "Left over" time step
      num h = this.time % dt;
      num h_div_dt = h / dt;

      for (int j = 0; j != this.bodies.length; j++) {
        Body b = this.bodies[j];
        if (b.type != Body.STATIC && b.sleepState != Body.SLEEPING) {
          // Interpolate
          vec2.sub(interpvelo, b.position, b.previousPosition);
          vec2.scale(interpvelo, interpvelo, h_div_dt);
          vec2.add(b.interpolatedPosition, b.position, interpvelo);
          b.interpolatedAngle = b.angle + (b.angle - b.previousAngle) * h_div_dt;
        } else {
          // For static bodies, just copy. Who else will do it?
          vec2.copy(b.interpolatedPosition, b.position);
          b.interpolatedAngle = b.angle;
        }
      }
    }
  }

  static final List<OverlapKeeperRecord> endOverlaps = new List<OverlapKeeperRecord>();

  /**
   * Make a fixed step.
   * @method internalStep
   * @param  {number} dt
   * @private
   */

  internalStep(num dt) {
    this.stepping = true;

    num Nsprings = this.springs.length;
//        springs = this.springs,
//        bodies = this.bodies,
    vec2 g = this.gravity;
//        solver = this.solver,
    num Nbodies = this.bodies.length;
//        broadphase = this.broadphase,
    Narrowphase np = this.narrowphase;
//        constraints = this.constraints,
    num t0, t1;
    vec2 fhMinv = step_fhMinv,
        velodt = step_velodt,
        mg = step_mg;
//        scale = vec2.scale,
//        add = vec2.add,
//        rotate = vec2.rotate;
    //islandManager = this.islandManager;

    this.overlapKeeper.tick();

    this.lastTimeStep = dt;

    if (doProfiling) {
      t0 = window.performance.now();
    }

    // Update approximate friction gravity.
    if (this.useWorldGravityAsFrictionGravity) {
      num gravityLen = vec2.length(this.gravity);
      if (!(gravityLen == 0 && this.useFrictionGravityOnZeroGravity)) {
        // Nonzero gravity. Use it.
        this.frictionGravity = gravityLen;
      }
    }

    // Add gravity to bodies
    if (this.applyGravity) {
      for (int i = 0; i != Nbodies; i++) {
        Body b = bodies[i];
        vec2 fi = b.force;
        if (b.type != Body.DYNAMIC || b.sleepState == Body.SLEEPING) {
          continue;
        }
        vec2.scale(mg, g, b.mass * b.gravityScale); // F=m*g
        vec2.add(fi, fi, mg);
      }
    }

    // Add spring forces
    if (this.applySpringForces) {
      for (int i = 0; i != Nsprings; i++) {
        Spring s = springs[i];
        s.applyForce();
      }
    }

    if (this.applyDamping) {
      for (int i = 0; i != Nbodies; i++) {
        Body b = bodies[i];
        if (b.type == Body.DYNAMIC) {
          b.applyDamping(dt);
        }
      }
    }

    // Broadphase
    List<Body> result = broadphase.getCollisionPairs(this);

    // Remove ignored collision pairs
    List<Body> ignoredPairs = this.disabledBodyCollisionPairs;
    for (int i = ignoredPairs.length - 2; i >= 0; i -= 2) {
      for (int j = result.length - 2; j >= 0; j -= 2) {
        if ((ignoredPairs[i] == result[j] && ignoredPairs[i + 1] == result[j + 1]) || (ignoredPairs[i + 1] == result[j] && ignoredPairs[i] == result[j + 1])) {
          result.removeRange(j, j + 2);
        }
      }
    }

    // Remove constrained pairs with collideConnected == false
    num Nconstraints = constraints.length;
    for (int i = 0; i != Nconstraints; i++) {
      Constraint c = constraints[i];
      if (!c.collideConnected) {
        for (int j = result.length - 2; j >= 0; j -= 2) {
          if ((c.bodyA == result[j] && c.bodyB == result[j + 1]) || (c.bodyB == result[j] && c.bodyA == result[j + 1])) {
            result.removeRange(j, j + 2);
          }
        }
      }
    }

    // postBroadphase event
    this.postBroadphaseEvent['pairs'] = result;
    this.emit(this.postBroadphaseEvent);

    // Narrowphase
    np.reset();
    for (int i = 0,
        Nresults = result.length; i != Nresults; i += 2) {
      Body bi = result[i],
          bj = result[i + 1];

      // Loop over all shapes of body i
      for (int k = 0,
          Nshapesi = bi.shapes.length; k != Nshapesi; k++) {
        Shape si = bi.shapes[k];
        vec2 xi = bi.shapeOffsets[k];
        num ai = bi.shapeAngles[k];

        // All shapes of body j
        for (int l = 0,
            Nshapesj = bj.shapes.length; l != Nshapesj; l++) {
          Shape sj = bj.shapes[l];
          vec2 xj = bj.shapeOffsets[l];
          num aj = bj.shapeAngles[l];

          ContactMaterial cm = this.defaultContactMaterial;
          if (si.material != null && sj.material != null) {
            ContactMaterial tmp = this.getContactMaterial(si.material, sj.material);
            if (tmp != null) {
              cm = tmp;
            }
          }

          this.runNarrowphase(np, bi, si, xi, ai, bj, sj, xj, aj, cm, this.frictionGravity);
        }
      }
    }

    // Wake up bodies
    for (int i = 0; i != Nbodies; i++) {
      Body body = bodies[i];
      if (body._wakeUpAfterNarrowphase) {
        body.wakeUp();
        body._wakeUpAfterNarrowphase = false;
      }
    }

    // Emit end overlap events
    if (this.has('endContact')) {
      this.overlapKeeper.getEndOverlaps(endOverlaps);
      Map e = this.endContactEvent;
      int l = endOverlaps.length;
      while (l-- > 0) {
        OverlapKeeperRecord data = endOverlaps[l];
        e['shapeA'] = data.shapeA;
        e['shapeB'] = data.shapeB;
        e['bodyA'] = data.bodyA;
        e['bodyB'] = data.bodyB;
        this.emit(e);
      }
    }

    Map preSolveEvent = this.preSolveEvent;
    preSolveEvent['contactEquations'] = np.contactEquations;
    preSolveEvent['frictionEquations'] = np.frictionEquations;
    this.emit(preSolveEvent);

    // update constraint equations
    Nconstraints = constraints.length;
    for (int i = 0; i != Nconstraints; i++) {
      constraints[i].update();
    }

    if (np.contactEquations.isNotEmpty || np.frictionEquations.isNotEmpty || constraints.isNotEmpty) {
      if (this.islandSplit) {
        // Split into islands
        islandManager.equations.clear();
        Utils.appendArray(islandManager.equations, np.contactEquations);
        Utils.appendArray(islandManager.equations, np.frictionEquations);
        for (int i = 0; i != Nconstraints; i++) {
          Utils.appendArray(islandManager.equations, constraints[i].equations);
        }
        islandManager.split(this);

        for (int i = 0; i != islandManager.islands.length; i++) {
          Island island = islandManager.islands[i];
          if (island.equations.length != null) {
            solver.solveIsland(dt, island);
          }
        }

      } else {

        // Add contact equations to solver
        solver.addEquations(np.contactEquations);
        solver.addEquations(np.frictionEquations);

        // Add user-defined constraint equations
        for (int i = 0; i != Nconstraints; i++) {
          solver.addEquations(constraints[i].equations);
        }

        if (this.solveConstraints) {
          solver.solve(dt, this);
        }

        solver.removeAllEquations();
      }
    }

    // Step forward
    for (int i = 0; i != Nbodies; i++) {
      Body body = bodies[i];

      if (body.sleepState != Body.SLEEPING && body.type != Body.STATIC) {
        World.integrateBody(body, dt);
      }
    }

    // Reset force
    for (int i = 0; i != Nbodies; i++) {
      bodies[i].setZeroForce();
    }

    if (doProfiling) {
      t1 = window.performance.now();
      lastStepTime = t1 - t0;
    }

    // Emit impact event
    if (this.emitImpactEvent && this.has('impact')) {
      Map ev = this.impactEvent;
      for (int i = 0; i != np.contactEquations.length; i++) {
        ContactEquation eq = np.contactEquations[i];
        if (eq.firstImpact) {
          ev['bodyA'] = eq.bodyA;
          ev['bodyB'] = eq.bodyB;
          ev['shapeA'] = eq.shapeA;
          ev['shapeB'] = eq.shapeB;
          ev['contactEquation'] = eq;
          this.emit(ev);
        }
      }
    }

    // Sleeping update
    if (this.sleepMode == World.BODY_SLEEPING) {
      for (int i = 0; i != Nbodies; i++) {
        bodies[i].sleepTick(this.time, false, dt);
      }
    } else if (this.sleepMode == World.ISLAND_SLEEPING && this.islandSplit) {

      // Tell all bodies to sleep tick but dont sleep yet
      for (int i = 0; i != Nbodies; i++) {
        bodies[i].sleepTick(this.time, true, dt);
      }

      // Sleep islands
      for (int i = 0; i < this.islandManager.islands.length; i++) {
        Island island = this.islandManager.islands[i];
        if (island.wantsToSleep()) {
          island.sleep();
        }
      }
    }

    this.stepping = false;

    // Remove bodies that are scheduled for removal
    if (this.bodiesToBeRemoved.isNotEmpty) {
      for (int i = 0; i != this.bodiesToBeRemoved.length; i++) {
        this.removeBody(this.bodiesToBeRemoved[i]);
      }
      this.bodiesToBeRemoved.length = 0;
    }

    this.emit(this.postStepEvent);
  }

  static final vec2 ib_fhMinv = vec2.create();
  static final vec2 ib_velodt = vec2.create();

  /**
   * Move a body forward in time.
   * @static
   * @method integrateBody
   * @param  {Body} body
   * @param  {Number} dt
   * @todo Move to Body.prototype?
   */

  static integrateBody(Body body, num dt) {
    num minv = body.invMass;
    vec2 f = body.force,
        pos = body.position,
        velo = body.velocity;

    // Save old position
    vec2.copy(body.previousPosition, body.position);
    body.previousAngle = body.angle;

    // Angular step
    if (!body.fixedRotation) {
      body.angularVelocity += body.angularForce * body.invInertia * dt;
      body.angle += body.angularVelocity * dt;
    }

    // Linear step
    vec2.scale(ib_fhMinv, f, dt * minv);
    vec2.add(velo, ib_fhMinv, velo);
    vec2.scale(ib_velodt, velo, dt);
    vec2.add(pos, pos, ib_velodt);

    body.aabbNeedsUpdate = true;
  }

  /**
   * Runs narrowphase for the shape pair i and j.
   * @method runNarrowphase
   * @param  {Narrowphase} np
   * @param  {Body} bi
   * @param  {Shape} si
   * @param  {Array} xi
   * @param  {Number} ai
   * @param  {Body} bj
   * @param  {Shape} sj
   * @param  {Array} xj
   * @param  {Number} aj
   * @param  {Number} mu
   */

  runNarrowphase(Narrowphase np, Body bi, Shape si, vec2 xi, num ai, Body bj, Shape sj, vec2 xj, num aj, ContactMaterial cm, num glen) {

    // Check collision groups and masks
    if (!((si.collisionGroup & sj.collisionMask) != 0 && (sj.collisionGroup & si.collisionMask) != 0)) {
      return;
    }

// Get world position and angle of each shape
    vec2.rotate(xiw, xi, bi.angle);
    vec2.rotate(xjw, xj, bj.angle);
    vec2.add(xiw, xiw, bi.position);
    vec2.add(xjw, xjw, bj.position);
    num aiw = ai + bi.angle;
    num ajw = aj + bj.angle;

    np.enableFriction = cm.friction > 0;
    np.frictionCoefficient = cm.friction;
    num reducedMass;
    if (bi.type == Body.STATIC || bi.type == Body.KINEMATIC) {
      reducedMass = bj.mass;
    } else if (bj.type == Body.STATIC || bj.type == Body.KINEMATIC) {
      reducedMass = bi.mass;
    } else {
      reducedMass = (bi.mass * bj.mass) / (bi.mass + bj.mass);
    }
    np.slipForce = cm.friction * glen * reducedMass;
    np.restitution = cm.restitution;
    np.surfaceVelocity = cm.surfaceVelocity;
    np.frictionStiffness = cm.frictionStiffness;
    np.frictionRelaxation = cm.frictionRelaxation;
    np.stiffness = cm.stiffness;
    np.relaxation = cm.relaxation;
    np.contactSkinSize = cm.contactSkinSize;

    Function resolver = np.compareMap[si.type | sj.type];
    num numContacts = 0;
    if (resolver != null) {
      bool sensor = si.sensor || sj.sensor;
      int numFrictionBefore = np.frictionEquations.length;
      if (si.type < sj.type) {
        numContacts = resolver(bi, si, xiw, aiw, bj, sj, xjw, ajw, sensor);
      } else {
        numContacts = resolver(bj, sj, xjw, ajw, bi, si, xiw, aiw, sensor);
      }
      int numFrictionEquations = np.frictionEquations.length - numFrictionBefore;

      if (numContacts != 0) {

        if (bi.allowSleep && bi.type == Body.DYNAMIC && bi.sleepState == Body.SLEEPING && bj.sleepState == Body.AWAKE && bj.type != Body.STATIC) {
          num speedSquaredB = vec2.squaredLength(bj.velocity) + pow(bj.angularVelocity, 2);
          num speedLimitSquaredB = pow(bj.sleepSpeedLimit, 2);
          if (speedSquaredB >= speedLimitSquaredB * 2) {
            bi._wakeUpAfterNarrowphase = true;
          }
        }

        if (bj.allowSleep && bj.type == Body.DYNAMIC && bj.sleepState == Body.SLEEPING && bi.sleepState == Body.AWAKE && bi.type != Body.STATIC) {
          num speedSquaredA = vec2.squaredLength(bi.velocity) + pow(bi.angularVelocity, 2);
          num speedLimitSquaredA = pow(bi.sleepSpeedLimit, 2);
          if (speedSquaredA >= speedLimitSquaredA * 2) {
            bj._wakeUpAfterNarrowphase = true;
          }
        }

        this.overlapKeeper.setOverlapping(bi, si, bj, sj);
        if (this.has('beginContact') && this.overlapKeeper.isNewOverlap(si, sj)) {

// Report new shape overlap
          Map e = this.beginContactEvent;
          e['shapeA'] = si;
          e['shapeB'] = sj;
          e['bodyA'] = bi;
          e['bodyB'] = bj;

// Reset contact equations
          e['contactEquations'].clear();

          if (numContacts != 0) {
            for (int i = np.contactEquations.length - numContacts; i < np.contactEquations.length; i++) {
              if (np.contactEquations.length > i && i >= 0) {
                e['contactEquations'].add(np.contactEquations[i]);
              } else {
                break;
              }
            }
          }

          this.emit(e);
        }

// divide the max friction force by the number of contacts
        if (numContacts != 0 && numFrictionEquations > 1) {
          // Why divide by 1?
          for (int i = np.frictionEquations.length - numFrictionEquations; i < np.frictionEquations.length; i++) {
            FrictionEquation f = np.frictionEquations[i];
            f.setSlipForce(f.getSlipForce() / numFrictionEquations);
          }
        }
      }
    }

  }



  /**
   * Add a spring to the simulation
   *
   * @method addSpring
   * @param {Spring} s
   */

  addSpring(Spring s) {
    this.springs.add(s);
    this.addSpringEvent['spring'] = s;
    this.emit(this.addSpringEvent);
  }

  /**
   * Remove a spring
   *
   * @method removeSpring
   * @param {Spring} s
   */

  removeSpring(Spring s) {
    int idx = this.springs.indexOf(s);
    if (idx != -1) {
      Utils.splice(this.springs, idx, 1);
    }
  }

  /**
   * Add a body to the simulation
   *
   * @method addBody
   * @param {Body} body
   *
   * @example
   *     var world = new World(),
   *         body = new Body();
   *     world.addBody(body);
   * @todo What if this is done during step?
   */

  addBody(Body body) {
    if (this.bodies.indexOf(body) == -1) {
      this.bodies.add(body);
      body.world = this;
      this.addBodyEvent['body'] = body;
      this.emit(this.addBodyEvent);
    }
  }

  /**
   * Remove a body from the simulation. If this method is called during step(), the body removal is scheduled to after the step.
   *
   * @method removeBody
   * @param {Body} body
   */

  removeBody(Body body) {
    if (this.stepping) {
      this.bodiesToBeRemoved.add(body);
    } else {
      body.world = null;
      int idx = this.bodies.indexOf(body);
      if (idx != -1) {
        Utils.splice(this.bodies, idx, 1);
        this.removeBodyEvent['body'] = body;
        body.resetConstraintVelocity();
        this.emit(this.removeBodyEvent);
      }
    }
  }

  /**
   * Get a body by its id.
   * @method getBodyById
   * @return {Body|Boolean} The body, or false if it was not found.
   */

  Body getBodyById(num id) {
    List<Body> bodies = this.bodies;
    for (int i = 0; i < bodies.length; i++) {
      Body b = bodies[i];
      if (b.id == id) {
        return b;
      }
    }
    return null;
  }

  /**
   * Disable collision between two bodies
   * @method disableCollision
   * @param {Body} bodyA
   * @param {Body} bodyB
   */

  disableBodyCollision(Body bodyA, Body bodyB) {
    this.disabledBodyCollisionPairs.addAll([bodyA, bodyB]);
  }

  /**
   * Enable collisions between the given two bodies
   * @method enableCollision
   * @param {Body} bodyA
   * @param {Body} bodyB
   */

  enableBodyCollision(Body bodyA, Body bodyB) {
    List<Body> pairs = this.disabledBodyCollisionPairs;
    for (int i = 0; i < pairs.length; i += 2) {
      if ((pairs[i] == bodyA && pairs[i + 1] == bodyB) || (pairs[i + 1] == bodyA && pairs[i] == bodyB)) {
        pairs.removeRange(i, i + 2);
        return;
      }
    }
  }


  Map contactMaterialToJSON(ContactMaterial cm) {
    return {
      'id': cm.id,
      'materialA': cm.materialA.id,
      'materialB': cm.materialB.id,
      'friction': cm.friction,
      'restitution': cm.restitution,
      'stiffness': cm.stiffness,
      'relaxation': cm.relaxation,
      'frictionStiffness': cm.frictionStiffness,
      'frictionRelaxation': cm.frictionRelaxation,
    };
  }

  /// Resets the World, removes all bodies, constraints and springs.

  clear() {

    this.time = 0;
    this.fixedStepTime = 0;

    // Remove all solver equations
    if (this.solver != null && this.solver.equations.isNotEmpty) {
      this.solver.removeAllEquations();
    }

    // Remove all constraints
    List<Constraint> cs = this.constraints;
    for (int i = cs.length - 1; i >= 0; i--) {
      this.removeConstraint(cs[i]);
    }

    // Remove all bodies
    List<Body> bodies = this.bodies;
    for (int i = bodies.length - 1; i >= 0; i--) {
      this.removeBody(bodies[i]);
    }

    // Remove all springs
    List<Spring> springs = this.springs;
    for (int i = springs.length - 1; i >= 0; i--) {
      this.removeSpring(springs[i]);
    }

    // Remove all contact materials
    List<ContactMaterial> cms = this.contactMaterials;
    for (int i = cms.length - 1; i >= 0; i--) {
      this.removeContactMaterial(cms[i]);
    }

    // TODO
    //World.apply(this);
  }

//  /**
//   * Get a copy of this World instance
//   * @method clone
//   * @return {World}
//   */
//
//  clone() {
//    var world = new World();
//    world.fromJSON(this.toJSON());
//    return world;
//  }

  static final vec2 hitTest_tmp1 = vec2.create(),
      hitTest_zero = vec2.fromValues(0, 0),
      hitTest_tmp2 = vec2.fromValues(0, 0);

  /**
   * Test if a world point overlaps bodies
   * @method hitTest
   * @param  {Array}  worldPoint  Point to use for intersection tests
   * @param  {Array}  bodies      A list of objects to check for intersection
   * @param  {Number} precision   Used for matching against particles and lines. Adds some margin to these infinitesimal objects.
   * @return {Array}              Array of bodies that overlap the point
   */

  List<Body> hitTest(vec2 worldPoint, List<Body> bodies, [num precision = 0]) {
    //precision = precision || 0;

    // Create a dummy particle body with a particle shape to test against the bodies
    Body pb = new Body(position: worldPoint);
    Particle ps = new Particle();
    vec2 px = worldPoint,
        x = hitTest_tmp1,
        zero = hitTest_zero,
        tmp = hitTest_tmp2;
    num pa = 0;
    
    
    pb.addShape(ps);

    Narrowphase n = this.narrowphase;
    List<Body> result = new List<Body>();

    // Check bodies
    for (int i = 0,
        N = bodies.length; i != N; i++) {
      Body b = bodies[i];
      for (int j = 0,
          NS = b.shapes.length; j != NS; j++) {
        Shape s = b.shapes[j];
        vec2 offset = b.shapeOffsets[j] == null ? zero : b.shapeOffsets[j];
        num angle = b.shapeAngles[j] == null ? 0.0 : b.shapeAngles[j];

        // Get shape world position + angle
        vec2.rotate(x, offset, b.angle);
        vec2.add(x, x, b.position);
        num a = angle + b.angle;

        if ((s is Circle && n.circleParticle(b, s, x, a, pb, ps, px, pa, true) != 0) || (s is Convex && n.particleConvex(pb, ps, px, pa, b, s, x, a, true) != 0) || (s is Plane && n.particlePlane(pb, ps, px, pa, b, s, x, a, true) != 0) || (s is Capsule && n.particleCapsule(pb, ps, px, pa, b, s, x, a, true) != 0) || (s is Particle && vec2.squaredLength(vec2.sub(tmp, x, worldPoint)) < precision * precision)) {
          result.add(b);
        }
      }
    }

    return result;
  }

  /**
   * Sets the Equation parameters for all constraints and contact materials.
   * @method setGlobalEquationParameters
   * @param {object} [parameters]
   * @param {Number} [parameters.relaxation]
   * @param {Number} [parameters.stiffness]
   */

  setGlobalEquationParameters({num stiffness, num relaxation}) {
//    parameters = parameters || {
//    };

    // Set for all constraints
    for (int i = 0; i != this.constraints.length; i++) {
      Constraint c = this.constraints[i];
      for (int j = 0; j != c.equations.length; j++) {
        Equation eq = c.equations[j];
        if (stiffness != null) {
          eq.stiffness = stiffness;
        }
        if (relaxation != null) {
          eq.relaxation = relaxation;
        }
        eq.needsUpdate = true;
      }
    }

    // Set for all contact materials
    for (int i = 0; i != this.contactMaterials.length; i++) {
      ContactMaterial c = this.contactMaterials[i];
      if (stiffness != null) {
        c.stiffness = stiffness;
        c.frictionStiffness = stiffness;
      }
      if (relaxation != null) {
        c.relaxation = relaxation;
        c.frictionRelaxation = relaxation;
      }
    }

    // Set for default contact material
    ContactMaterial c = this.defaultContactMaterial;
    if (stiffness != null) {
      c.stiffness = stiffness;
      c.frictionStiffness = stiffness;
    }
    if (relaxation != null) {
      c.relaxation = relaxation;
      c.frictionRelaxation = relaxation;
    }
  }

  /// Set the stiffness for all equations and contact materials.
  setGlobalStiffness(num stiffness) {
    this.setGlobalEquationParameters(stiffness: stiffness);
  }

  /// Set the relaxation for all equations and contact materials.
  setGlobalRelaxation(num relaxation) {
    this.setGlobalEquationParameters(relaxation: relaxation);
  }
}
