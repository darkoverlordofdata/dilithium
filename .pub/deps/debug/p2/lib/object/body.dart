part of p2;

/**
 * A rigid body. Has got a center of mass, position, velocity and a number of
 * shapes that are used for collisions.
 *
 * @class Body
 * @constructor
 * @extends EventEmitter
 * @param {Object}              [options]
 * @param {Number}              [options.mass=0]    A number >= 0. If zero, the .type will be set to Body.STATIC.
 * @param {Array}               [options.position]
 * @param {Array}               [options.velocity]
 * @param {Number}              [options.angle=0]
 * @param {Number}              [options.angularVelocity=0]
 * @param {Array}               [options.force]
 * @param {Number}              [options.angularForce=0]
 * @param {Number}              [options.fixedRotation=false]
 *
 * @example
 *     // Create a typical dynamic body
 *     var body = new Body({
 *         mass: 1,
 *         position: [0, 0],
 *         angle: 0,
 *         velocity: [0, 0],
 *         angularVelocity: 0
 *     });
 *
 *     // Add a circular shape to the body
 *     body.addShape(new Circle(1));
 *
 *     // Add the body to the world
 *     world.addBody(body);
 */
class Body extends EventEmitter {

  /// The body identifyer
  int id;

  /// The world that this body is added to. This property is set to NULL if the body is not added to any world.
  World world;

  /**
   * The shapes of the body. The local transform of the shape in .shapes[i] is
   * defined by .shapeOffsets[i] and .shapeAngles[i].
   */
  final List<Shape> shapes= new List<Shape>();

  /**
   * The local shape offsets, relative to the body center of mass. This is an
   * array of Array.
   */
  final List<vec2> shapeOffsets = new List<vec2>();

  /**
   * The body-local shape angle transforms. This is an array of numbers (angles).
   * @property shapeAngles
   * @type {Array}
   */
  final List<num> shapeAngles = new List<num>();

  /// The mass of the body.
  double mass;

  /// The inverse mass of the body.
  double invMass;

  /// The inertia of the body around the Z axis.
  double inertia;

  /// The inverse inertia of the body.
  double invInertia;

  double invMassSolve;
  double invInertiaSolve;


  /// Set to true if you want to fix the rotation of the body.
  bool fixedRotation;

  /// The position of the body
  final vec2 position= vec2.create();

  /// The interpolated position of the body.
  final vec2 interpolatedPosition= vec2.create();

  /// The interpolated angle of the body.
  num interpolatedAngle;

  /// The previous position of the body.
  final vec2 previousPosition= vec2.create();

  /// The previous angle of the body.
  num previousAngle;

  /// The velocity of the body
  final vec2 velocity= vec2.create();

  /// Constraint velocity that was added to the body during the last step.
  final vec2 vlambda= vec2.create();

  /// Angular constraint velocity that was added to the body during last step.
  double wlambda = 0.0;

  /**
   * The angle of the body, in radians.
   * @property angle
   * @type {number}
   * @example
   *     // The angle property is not normalized to the interval 0 to 2*pi, it can be any value.
   *     // If you need a value between 0 and 2*pi, use the following function to normalize it.
   *     function normalizeAngle(angle){
   *         angle = angle % (2*Math.PI);
   *         if(angle < 0){
   *             angle += (2*Math.PI);
   *         }
   *         return angle;
   *     }
   */
  double angle;

  /// The angular velocity of the body, in radians per second.
  double angularVelocity;

  /**
   * The force acting on the body. Since the body force (and {{#crossLink "Body/angularForce:property"}}{{/crossLink}}) will be zeroed after each step, so you need to set the force before each step.
   * @property force
   * @type {Array}
   *
   * @example
   *     // This produces a forcefield of 1 Newton in the positive x direction.
   *     for(var i=0; i<numSteps; i++){
   *         body.force[0] = 1;
   *         world.step(1/60);
   *     }
   *
   * @example
   *     // This will apply a rotational force on the body
   *     for(var i=0; i<numSteps; i++){
   *         body.angularForce = -3;
   *         world.step(1/60);
   *     }
   */
  final vec2 force= vec2.create();

  /// The angular force acting on the body.
  double angularForce;

  /// The linear damping acting on the body in the velocity direction. Should be a value between 0 and 1.
  double damping;

  /// The angular force acting on the body. Should be a value between 0 and 1.
  double angularDamping;

  /**
   * The type of motion this body has. Should be one of: {{#crossLink "Body/STATIC:property"}}Body.STATIC{{/crossLink}}, {{#crossLink "Body/DYNAMIC:property"}}Body.DYNAMIC{{/crossLink}} and {{#crossLink "Body/KINEMATIC:property"}}Body.KINEMATIC{{/crossLink}}.
   *
   * * Static bodies do not move, and they do not respond to forces or collision.
   * * Dynamic bodies body can move and respond to collisions and forces.
   * * Kinematic bodies only moves according to its .velocity, and does not respond to collisions or force.
   *
   * @property type
   * @type {number}
   *
   * @example
   *     // Bodies are static by default. Static bodies will never move.
   *     var body = new Body();
   *     console.log(body.type == Body.STATIC); // true
   *
   * @example
   *     // By setting the mass of a body to a nonzero number, the body
   *     // will become dynamic and will move and interact with other bodies.
   *     var dynamicBody = new Body({
   *         mass : 1
   *     });
   *     console.log(dynamicBody.type == Body.DYNAMIC); // true
   *
   * @example
   *     // Kinematic bodies will only move if you change their velocity.
   *     var kinematicBody = new Body({
   *         type: Body.KINEMATIC // Type can be set via the options object.
   *     });
   */
  int type=0;


  /// Bounding circle radius.
  double boundingRadius;

  /// Bounding box of this body.
  AABB aabb;

  /**
   * Indicates if the AABB needs update. Update it with {{#crossLink "Body/updateAABB:method"}}.updateAABB(){{/crossLink}}.
   * @property aabbNeedsUpdate
   * @type {Boolean}
   * @see updateAABB
   *
   * @example
   *     // Force update the AABB
   *     body.aabbNeedsUpdate = true;
   *     body.updateAABB();
   *     console.log(body.aabbNeedsUpdate); // false
   */
  bool aabbNeedsUpdate;

  /**
   * If true, the body will automatically fall to sleep. Note that you need to enable sleeping in the {{#crossLink "World"}}{{/crossLink}} before anything will happen.
   * @property allowSleep
   * @type {Boolean}
   * @default true
   */
  bool allowSleep;

  bool wantsToSleep;

  /**
   * One of {{#crossLink "Body/AWAKE:property"}}Body.AWAKE{{/crossLink}}, {{#crossLink "Body/SLEEPY:property"}}Body.SLEEPY{{/crossLink}} and {{#crossLink "Body/SLEEPING:property"}}Body.SLEEPING{{/crossLink}}.
   *
   * The body is initially Body.AWAKE. If its velocity norm is below .sleepSpeedLimit, the sleepState will become Body.SLEEPY. If the body continues to be Body.SLEEPY for .sleepTimeLimit seconds, it will fall asleep (Body.SLEEPY).
   *
   * @property sleepState
   * @type {Number}
   * @default Body.AWAKE
   */
  int sleepState;

  /// If the speed (the norm of the velocity) is smaller than this value, the body is considered sleepy.
  double sleepSpeedLimit = 0.2;

  /// If the body has been sleepy for this sleepTimeLimit seconds, it is considered sleeping.
  double sleepTimeLimit;

  /// Gravity scaling factor. If you want the body to ignore gravity, set this to zero. If you want to reverse gravity, set it to -1.
  double gravityScale;

  /// The last time when the body went to SLEEPY state.
  double timeLastSleepy;

  double idleTime = 0.0;

  List<vec2> concavePath;

  bool _wakeUpAfterNarrowphase;

  static int _idCounter = 0;

  Object parent;

  Body({int type, num mass: 0.0, vec2 position, vec2 velocity, num angle: 0.0, num angularVelocity: 0.0,  vec2 force, num angularForce: 0.0, bool fixedRotation: false, num damping: 0.1, num angularDamping: 0.1}) : super() {

    this.id = ++Body._idCounter;

    this.world = null;

    this.mass = mass.toDouble();

    this.invMass = 0.0;

    this.inertia = 0.0;

    this.invInertia = 0.0;

    this.invMassSolve = 0.0;
    this.invInertiaSolve = 0.0;

    this.fixedRotation = fixedRotation;


    //this.position ;
    if (position != null) {
      vec2.copy(this.position, position);
    }

    //this.interpolatedPosition = vec2.fromValues(0, 0);

    this.interpolatedAngle = 0;

    /**
     * The previous position of the body.
     * @property previousPosition
     * @type {Array}
     */
    //this.previousPosition = vec2.fromValues(0, 0);

    /**
     * The previous angle of the body.
     * @property previousAngle
     * @type {Number}
     */
    this.previousAngle = 0;

    /**
     * The velocity of the body
     * @property velocity
     * @type {Array}
     */
    //this.velocity = vec2.fromValues(0, 0);
    if (velocity != null) {
      vec2.copy(this.velocity, velocity);
    }

    /**
     * Constraint velocity that was added to the body during the last step.
     * @property vlambda
     * @type {Array}
     */
    //this.vlambda = vec2.fromValues(0, 0);

    /**
     * Angular constraint velocity that was added to the body during last step.
     * @property wlambda
     * @type {Array}
     */
    this.wlambda = 0.0;

    /**
     * The angle of the body, in radians.
     * @property angle
     * @type {number}
     * @example
     *     // The angle property is not normalized to the interval 0 to 2*pi, it can be any value.
     *     // If you need a value between 0 and 2*pi, use the following function to normalize it.
     *     function normalizeAngle(angle){
     *         angle = angle % (2*Math.PI);
     *         if(angle < 0){
     *             angle += (2*Math.PI);
     *         }
     *         return angle;
     *     }
     */
    this.angle = angle.toDouble();

    /**
     * The angular velocity of the body, in radians per second.
     * @property angularVelocity
     * @type {number}
     */
    this.angularVelocity = angularVelocity.toDouble();

    /**
     * The force acting on the body. Since the body force (and {{#crossLink "Body/angularForce:property"}}{{/crossLink}}) will be zeroed after each step, so you need to set the force before each step.
     * @property force
     * @type {Array}
     *
     * @example
     *     // This produces a forcefield of 1 Newton in the positive x direction.
     *     for(var i=0; i<numSteps; i++){
     *         body.force[0] = 1;
     *         world.step(1/60);
     *     }
     *
     * @example
     *     // This will apply a rotational force on the body
     *     for(var i=0; i<numSteps; i++){
     *         body.angularForce = -3;
     *         world.step(1/60);
     *     }
     */
    //this.force = vec2.create();
    if (force != null) {
      vec2.copy(this.force, force);
    }

    /**
     * The angular force acting on the body. See {{#crossLink "Body/force:property"}}{{/crossLink}}.
     * @property angularForce
     * @type {number}
     */
    this.angularForce = angularForce.toDouble();

    /**
     * The linear damping acting on the body in the velocity direction. Should be a value between 0 and 1.
     * @property damping
     * @type {Number}
     * @default 0.1
     */
    this.damping = damping.toDouble();

    /**
     * The angular force acting on the body. Should be a value between 0 and 1.
     * @property angularDamping
     * @type {Number}
     * @default 0.1
     */
    this.angularDamping = angularDamping.toDouble();

    /**
     * The type of motion this body has. Should be one of: {{#crossLink "Body/STATIC:property"}}Body.STATIC{{/crossLink}}, {{#crossLink "Body/DYNAMIC:property"}}Body.DYNAMIC{{/crossLink}} and {{#crossLink "Body/KINEMATIC:property"}}Body.KINEMATIC{{/crossLink}}.
     *
     * * Static bodies do not move, and they do not respond to forces or collision.
     * * Dynamic bodies body can move and respond to collisions and forces.
     * * Kinematic bodies only moves according to its .velocity, and does not respond to collisions or force.
     *
     * @property type
     * @type {number}
     *
     * @example
     *     // Bodies are static by default. Static bodies will never move.
     *     var body = new Body();
     *     console.log(body.type == Body.STATIC); // true
     *
     * @example
     *     // By setting the mass of a body to a nonzero number, the body
     *     // will become dynamic and will move and interact with other bodies.
     *     var dynamicBody = new Body({
     *         mass : 1
     *     });
     *     console.log(dynamicBody.type == Body.DYNAMIC); // true
     *
     * @example
     *     // Kinematic bodies will only move if you change their velocity.
     *     var kinematicBody = new Body({
     *         type: Body.KINEMATIC // Type can be set via the options object.
     *     });
     */


    if (type != null) {
      this.type = type;
    } else if (mass == 0) {
      this.type = Body.STATIC;
    } else {
      this.type = Body.DYNAMIC;
    }

    /**
     * Bounding circle radius.
     * @property boundingRadius
     * @type {Number}
     */
    this.boundingRadius = 0.0;

    /**
     * Bounding box of this body.
     * @property aabb
     * @type {AABB}
     */
    this.aabb = new AABB();

    /**
     * Indicates if the AABB needs update. Update it with {{#crossLink "Body/updateAABB:method"}}.updateAABB(){{/crossLink}}.
     * @property aabbNeedsUpdate
     * @type {Boolean}
     * @see updateAABB
     *
     * @example
     *     // Force update the AABB
     *     body.aabbNeedsUpdate = true;
     *     body.updateAABB();
     *     console.log(body.aabbNeedsUpdate); // false
     */
    this.aabbNeedsUpdate = true;

    /**
     * If true, the body will automatically fall to sleep. Note that you need to enable sleeping in the {{#crossLink "World"}}{{/crossLink}} before anything will happen.
     * @property allowSleep
     * @type {Boolean}
     * @default true
     */
    this.allowSleep = true;

    this.wantsToSleep = false;

    /**
     * One of {{#crossLink "Body/AWAKE:property"}}Body.AWAKE{{/crossLink}}, {{#crossLink "Body/SLEEPY:property"}}Body.SLEEPY{{/crossLink}} and {{#crossLink "Body/SLEEPING:property"}}Body.SLEEPING{{/crossLink}}.
     *
     * The body is initially Body.AWAKE. If its velocity norm is below .sleepSpeedLimit, the sleepState will become Body.SLEEPY. If the body continues to be Body.SLEEPY for .sleepTimeLimit seconds, it will fall asleep (Body.SLEEPY).
     *
     * @property sleepState
     * @type {Number}
     * @default Body.AWAKE
     */
    this.sleepState = Body.AWAKE;

    /**
     * If the speed (the norm of the velocity) is smaller than this value, the body is considered sleepy.
     * @property sleepSpeedLimit
     * @type {Number}
     * @default 0.2
     */
    this.sleepSpeedLimit = 0.2;

    /**
     * If the body has been sleepy for this sleepTimeLimit seconds, it is considered sleeping.
     * @property sleepTimeLimit
     * @type {Number}
     * @default 1
     */
    this.sleepTimeLimit = 1.0;

    /**
     * Gravity scaling factor. If you want the body to ignore gravity, set this to zero. If you want to reverse gravity, set it to -1.
     * @property {Number} gravityScale
     * @default 1
     */
    this.gravityScale = 1.0;

    /**
     * The last time when the body went to SLEEPY state.
     * @property {Number} timeLastSleepy
     * @private
     */
    this.timeLastSleepy = 0.0;

    this.concavePath = null;

    this._wakeUpAfterNarrowphase = false;

    this.updateMassProperties();
  }

  updateSolveMassProperties() {
    if (this.sleepState == Body.SLEEPING || this.type == Body.KINEMATIC) {
      this.invMassSolve = 0.0;
      this.invInertiaSolve = 0.0;
    } else {
      this.invMassSolve = this.invMass;
      this.invInertiaSolve = this.invInertia;
    }
  }

  /// Set the total density of the body

  setDensity(num density) {
    num totalArea = this.getArea();
    this.mass = totalArea * density;
    this.updateMassProperties();
  }

  /// Get the total area of all shapes in the body

  getArea() {
    num totalArea = 0;
    for (int i = 0; i < this.shapes.length; i++) {
      totalArea += this.shapes[i].area;
    }
    return totalArea;
  }

  /**
   * Get the AABB from the body. The AABB is updated if necessary.
   * @method getAABB
   */

  getAABB() {
    if (this.aabbNeedsUpdate) {
      this.updateAABB();
    }
    return this.aabb;
  }

  static final AABB shapeAABB = new AABB();
  static final vec2 tmp = vec2.create();

  /**
   * Updates the AABB of the Body
   * @method updateAABB
   */

  updateAABB() {
    List<Shape> shapes = this.shapes;
    List<vec2> shapeOffsets = this.shapeOffsets;
    List<num> shapeAngles = this.shapeAngles;
    num N = shapes.length;
    final vec2 offset = tmp;
    num bodyAngle = this.angle;

    for (int i = 0; i != N; i++) {
      Shape shape = shapes[i];
      num angle = shapeAngles[i] + bodyAngle;

      // Get shape world offset
      vec2.rotate(offset, shapeOffsets[i], bodyAngle);
      vec2.add(offset, offset, this.position);

      // Get shape AABB
      shape.computeAABB(shapeAABB, offset, angle);

      if (i == 0) {
        this.aabb.copy(shapeAABB);
      } else {
        this.aabb.extend(shapeAABB);
      }
    }

    this.aabbNeedsUpdate = false;
  }

  /**
   * Update the bounding radius of the body. Should be done if any of the shapes
   * are changed.
   * @method updateBoundingRadius
   */

  updateBoundingRadius() {
    List<Shape> shapes = this.shapes;
    List<vec2> shapeOffsets = this.shapeOffsets;
    num N = shapes.length;
    double radius = 0.0;

    for (int i = 0; i != N; i++) {
      Shape shape = shapes[i];
      num offset = vec2.length(shapeOffsets[i]),
          r = shape.boundingRadius;
      if (offset + r > radius) {
        radius = offset + r;
      }
    }

    this.boundingRadius = radius;
  }

  /**
   * Add a shape to the body. You can pass a local transform when adding a shape,
   * so that the shape gets an offset and angle relative to the body center of mass.
   * Will automatically update the mass properties and bounding radius.
   *
   * @method addShape
   * @param  {Shape}              shape
   * @param  {Array} [offset] Local body offset of the shape.
   * @param  {Number}             [angle]  Local body angle.
   *
   * @example
   *     var body = new Body(),
   *         shape = new Circle();
   *
   *     // Add the shape to the body, positioned in the center
   *     body.addShape(shape);
   *
   *     // Add another shape to the body, positioned 1 unit length from the body center of mass along the local x-axis.
   *     body.addShape(shape,[1,0]);
   *
   *     // Add another shape to the body, positioned 1 unit length from the body center of mass along the local y-axis, and rotated 90 degrees CCW.
   *     body.addShape(shape,[0,1],Math.PI/2);
   */

  addShape(Shape shape, [vec2 offset, num angle = 0.0]) {

    // Copy the offset vector
    if (offset != null) {
      offset = vec2.fromValues(offset.x, offset.y);
    } else {
      offset = vec2.fromValues(0, 0);
    }

    this.shapes.add(shape);
    this.shapeOffsets.add(offset);
    this.shapeAngles.add(angle);
    this.updateMassProperties();
    this.updateBoundingRadius();

    this.aabbNeedsUpdate = true;
  }

  /**
   * Remove a shape
   * @method removeShape
   * @param  {Shape}  shape
   * @return {Boolean}       True if the shape was found and removed, else false.
   */

  bool removeShape(Shape shape) {
    int idx = this.shapes.indexOf(shape);

    if (idx != -1) {
      this.shapes.removeAt(idx);
      this.shapeOffsets.removeAt(idx);
      this.shapeAngles.removeAt(idx);
      this.aabbNeedsUpdate = true;
      return true;
    } else {
      return false;
    }
  }

  /**
   * Updates .inertia, .invMass, .invInertia for this Body. Should be called when
   * changing the structure or mass of the Body.
   *
   * @method updateMassProperties
   *
   * @example
   *     body.mass += 1;
   *     body.updateMassProperties();
   */

  updateMassProperties() {
    if (this.type == Body.STATIC || this.type == Body.KINEMATIC) {

      this.mass = double.MAX_FINITE;
      this.invMass = 0.0;
      this.inertia = double.MAX_FINITE;
      this.invInertia = 0.0;

    } else {

      List<Shape> shapes = this.shapes;
      int N = shapes.length;
      double m = this.mass / N,
          I = 0.0;

      if (!this.fixedRotation) {
        for (int i = 0; i < N; i++) {
          Shape shape = shapes[i];
          num r2 = vec2.squaredLength(this.shapeOffsets[i]),
              Icm = shape.computeMomentOfInertia(m);
          I += Icm + m * r2;
        }
        this.inertia = I;
        this.invInertia = I > 0.0 ? 1.0 / I : 0.0;

      } else {
        this.inertia = double.MAX_FINITE;
        this.invInertia = 0.0;
      }

      // Inverse mass properties are easy
      this.invMass = 1 / this.mass;
      // > 0 ? 1/this.mass : 0;
    }
  }

  static final vec2 Body_applyForce_r = vec2.create();

  /**
   * Apply force to a world point. This could for example be a point on the RigidBody surface. Applying force this way will add to Body.force and Body.angularForce.
   * @method applyForce
   * @param {Array} force The force to add.
   * @param {Array} worldPoint A world point to apply the force on.
   */

  applyForce(vec2 force, vec2 worldPoint) {
    // Compute point position relative to the body center
    vec2 r = Body_applyForce_r;
    vec2.sub(r, worldPoint, this.position);

    // Add linear force
    vec2.add(this.force, this.force, force);

    // Compute produced rotational force
    num rotForce = vec2.crossLength(r, force);

    // Add rotational force
    this.angularForce += rotForce;
  }

  /**
   * Transform a world point to local body frame.
   * @method toLocalFrame
   * @param  {Array} out          The vector to store the result in
   * @param  {Array} worldPoint   The input world vector
   */

  toLocalFrame(vec2 out, worldPoint) {
    vec2.toLocalFrame(out, worldPoint, this.position, this.angle);
  }

  /**
   * Transform a local point to world frame.
   * @method toWorldFrame
   * @param  {Array} out          The vector to store the result in
   * @param  {Array} localPoint   The input local vector
   */

  toWorldFrame(vec2 out, vec2 localPoint) {
    vec2.toGlobalFrame(out, localPoint, this.position, this.angle);
  }

  /**
   * Reads a polygon shape path, and assembles convex shapes from that and puts them at proper offset points.
   * @method fromPolygon
   * @param {Array} path An array of 2d vectors, e.g. [[0,0],[0,1],...] that resembles a concave or convex polygon. The shape must be simple and without holes.
   * @param {Object} [options]
   * @param {Boolean} [options.optimalDecomp=false]   Set to true if you need optimal decomposition. Warning: very slow for polygons with more than 10 vertices.
   * @param {Boolean} [options.skipSimpleCheck=false] Set to true if you already know that the path is not intersecting itself.
   * @param {Boolean|Number} [options.removeCollinearPoints=false] Set to a number (angle threshold value) to remove collinear points, or false to keep all points.
   * @return {Boolean} True on success, else false.
   */

  bool fromPolygon(List<vec2> path, {bool optimalDecomp: false, bool skipSimpleCheck: false, num removeCollinearPoints: 0}) {
//    options = options || {
//    };

    // Remove all shapes
    for (int i = this.shapes.length - 1; i >= 0; --i) {
      this.removeShape(this.shapes[i]);
    }

    decomp.Polygon p = new decomp.Polygon();
    p.vertices = path.toList();

    // Make it counter-clockwise
    p.makeCCW();

    if (removeCollinearPoints != 0) {
      p.removeCollinearPoints(removeCollinearPoints);
    }

    // Check if any line segment intersects the path itself
    if (skipSimpleCheck) {
      if (!p.isSimple()) {
        return false;
      }
    }

    // Save this path for later
    this.concavePath = p.vertices.toList();
    for (int i = 0; i < this.concavePath.length; i++) {
      //List v = [0, 0];
      vec2 v = vec2.fromValues(0, 0);
      vec2.copy(v, this.concavePath[i]);
      this.concavePath[i] = v;
    }

    // Slow or fast decomp?
    List<decomp.Polygon> convexes;
    if (optimalDecomp) {
      convexes = p.decomp();
    } else {
      convexes = p.quickDecomp();
    }

    vec2 cm = vec2.create();

    // Add convexes
    for (int i = 0; i != convexes.length; i++) {
      // Create convex
      Convex c = new Convex(convexes[i].vertices);

      // Move all vertices so its center of mass is in the local center of the convex
      for (int j = 0; j != c.vertices.length; j++) {
        vec2 v = c.vertices[j];
        vec2.sub(v, v, c.centerOfMass);
      }

      vec2.scale(cm, c.centerOfMass, 1.0);
      c.updateTriangles();
      c.updateCenterOfMass();
      c.updateBoundingRadius();

      // Add the shape
      this.addShape(c, cm);
    }

    this.adjustCenterOfMass();

    this.aabbNeedsUpdate = true;

    return true;
  }

  static final vec2 adjustCenterOfMass_tmp1 = vec2.fromValues(0, 0),
      adjustCenterOfMass_tmp2 = vec2.fromValues(0, 0),
      adjustCenterOfMass_tmp3 = vec2.fromValues(0, 0),
      adjustCenterOfMass_tmp4 = vec2.fromValues(0, 0);

  /**
   * Moves the shape offsets so their center of mass becomes the body center of mass.
   * @method adjustCenterOfMass
   */

  adjustCenterOfMass() {
    vec2 offset_times_area = adjustCenterOfMass_tmp2,
        sum = adjustCenterOfMass_tmp3,
        cm = adjustCenterOfMass_tmp4;
    num totalArea = 0;
    vec2.set(sum, 0, 0);

    for (int i = 0; i != this.shapes.length; i++) {
      Shape s = this.shapes[i];
      vec2 offset = this.shapeOffsets[i];
      vec2.scale(offset_times_area, offset, s.area);
      vec2.add(sum, sum, offset_times_area);
      totalArea += s.area;
    }

    vec2.scale(cm, sum, 1 / totalArea);

    // Now move all shapes
    for (int i = 0; i != this.shapes.length; i++) {
      Shape s = this.shapes[i];
      vec2 offset = this.shapeOffsets[i];

      // Offset may be undefined. Fix that.
      if (offset == null) {
        offset = this.shapeOffsets[i] = vec2.create();
      }

      vec2.sub(offset, offset, cm);
    }

    // Move the body position too
    vec2.add(this.position, this.position, cm);

    // And concave path
    for (int i = 0; this.concavePath != null && i < this.concavePath.length; i++) {
      vec2.sub(this.concavePath[i], this.concavePath[i], cm);
    }

    this.updateMassProperties();
    this.updateBoundingRadius();
  }

  /**
   * Sets the force on the body to zero.
   * @method setZeroForce
   */

  setZeroForce() {
    vec2.set(this.force, 0.0, 0.0);
    this.angularForce = 0.0;
  }

  resetConstraintVelocity() {
    vec2 vlambda = this.vlambda;
    vec2.set(vlambda, 0.0, 0.0);
    this.wlambda = 0.0;
  }

  addConstraintVelocity() {
    vec2 v = this.velocity;
    vec2.add(v, v, this.vlambda);
    this.angularVelocity += this.wlambda;
  }

  /**
   * Apply damping, see <a href="http://code.google.com/p/bullet/issues/detail?id=74">this</a> for details.
   * @method applyDamping
   * @param  {number} dt Current time step
   */

  applyDamping(dt) {
    if (this.type == Body.DYNAMIC) {
      // Only for dynamic bodies
      vec2 v = this.velocity;
      vec2.scale(v, v, pow(1.0 - this.damping, dt));
      this.angularVelocity *= pow(1.0 - this.angularDamping, dt);
    }
  }

  /**
   * Wake the body up. Normally you should not need this, as the body is automatically awoken at events such as collisions.
   * Sets the sleepState to {{#crossLink "Body/AWAKE:property"}}Body.AWAKE{{/crossLink}} and emits the wakeUp event if the body wasn't awake before.
   * @method wakeUp
   */

  wakeUp() {
    int s = this.sleepState;
    this.sleepState = Body.AWAKE;
    this.idleTime = 0.0;
    if (s != Body.AWAKE) {
      this.emit(Body.wakeUpEvent);
    }
  }

  /**
   * Force body sleep
   * @method sleep
   */

  sleep() {
    this.sleepState = Body.SLEEPING;
    this.angularVelocity = 0.0;
    this.angularForce = 0.0;
    vec2.set(this.velocity, 0.0, 0.0);
    vec2.set(this.force, 0.0, 0.0);
    this.emit(Body.sleepEvent);
  }

  /**
   * Called every timestep to update internal sleep timer and change sleep state if needed.
   * @method sleepTick
   * @param {number} time The world time in seconds
   * @param {boolean} dontSleep
   * @param {number} dt
   */

  sleepTick(time, dontSleep, dt) {
    if (!this.allowSleep || this.type == Body.SLEEPING) {
      return;
    }

    this.wantsToSleep = false;

    int sleepState = this.sleepState;
    num speedSquared = vec2.squaredLength(this.velocity) + pow(this.angularVelocity, 2),
        speedLimitSquared = pow(this.sleepSpeedLimit, 2);

    // Add to idle time
    if (speedSquared >= speedLimitSquared) {
      this.idleTime = 0.0;
      this.sleepState = Body.AWAKE;
    } else {
      this.idleTime += dt;
      this.sleepState = Body.SLEEPY;
    }
    if (this.idleTime > this.sleepTimeLimit) {
      if (!dontSleep) {
        this.sleep();
      } else {
        this.wantsToSleep = true;
      }
    }

    /*
    if(sleepState===Body.AWAKE && speedSquared < speedLimitSquared){
        this.sleepState = Body.SLEEPY; // Sleepy
        this.timeLastSleepy = time;
        this.emit(Body.sleepyEvent);
    } else if(sleepState===Body.SLEEPY && speedSquared >= speedLimitSquared){
        this.wakeUp(); // Wake up
    } else if(sleepState===Body.SLEEPY && (time - this.timeLastSleepy ) > this.sleepTimeLimit){
        this.wantsToSleep = true;
        if(!dontSleep){
            this.sleep();
        }
    }
    */
  }

  getVelocityFromPosition([vec2 store, num timeStep]) {
    if (store == null) {
      store = vec2.create();
    }

    vec2.sub(store, this.position, this.previousPosition);
    vec2.scale(store, store, 1 / timeStep);
    return store;
  }

  getAngularVelocityFromPosition(num timeStep) {
    return (this.angle - this.previousAngle) / timeStep;
  }

  /**
   * Check if the body is overlapping another body. Note that this method only works if the body was added to a World and if at least one step was taken.
   * @method overlaps
   * @param  {Body} body
   * @return {boolean}
   */

  overlaps(Body body) {
    return this.world.overlapKeeper.bodiesAreOverlapping(this, body);
  }


  static Map sleepyEvent = {
    'type': "sleepy"
  };


  static Map sleepEvent = {
    'type': "sleep"
  };

  static Map wakeUpEvent = {
    'type': "wakeup"
  };

  /// Dynamic body.
  static const int DYNAMIC = 1;

  /// Static body.
  static const int STATIC = 2;

  /// Kinematic body.
  static const int KINEMATIC = 4;

  static const int AWAKE = 0;

  static const int SLEEPY = 1;

  static const int SLEEPING = 2;
}
