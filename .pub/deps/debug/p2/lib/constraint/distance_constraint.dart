part of p2;

class DistanceConstraint extends Constraint {
  final vec2 localAnchorA = vec2.create();
  final vec2 localAnchorB = vec2.create();
  num distance;
  /// Max force to apply.
  num maxForce;
  /// If the upper limit is enabled or not.
  bool upperLimitEnabled;
  /// The upper constraint limit.
  num upperLimit;
  /// If the lower limit is enabled or not.
  bool lowerLimitEnabled;
  /// The lower constraint limit.
  num lowerLimit;
  /// Current constraint position. This is equal to the current distance between the world anchor points.
  num position;


  DistanceConstraint(Body bodyA, Body bodyB, {vec2 localAnchorA, vec2 localAnchorB, num distance, num maxForce: double.MAX_FINITE, bool collideConnected: true, bool wakeUpBodies: true}) : super(bodyA, bodyB, Constraint.REVOLUTE, collideConnected: collideConnected, wakeUpBodies: wakeUpBodies) {
    if (localAnchorA == null) {
      localAnchorA = vec2.fromValues(0.0, 0.0);
    }
    if (localAnchorB == null) {
      localAnchorB = vec2.fromValues(0.0, 0.0);
    }

    vec2.copy(this.localAnchorA, localAnchorA);
    vec2.copy(this.localAnchorB, localAnchorB);
    this.distance = distance;

    if (this.distance == null) {
// Use the current world distance between the world anchor points.
      vec2 worldAnchorA = vec2.create(),
          worldAnchorB = vec2.create(),
          r = vec2.create();

      // Transform local anchors to world
      vec2.rotate(worldAnchorA, localAnchorA, bodyA.angle);
      vec2.rotate(worldAnchorB, localAnchorB, bodyB.angle);

      vec2.add(r, bodyB.position, worldAnchorB);
      vec2.sub(r, r, worldAnchorA);
      vec2.sub(r, r, bodyA.position);

      this.distance = vec2.length(r);
    }




    Equation normal = new Equation(bodyA, bodyB, -maxForce, maxForce); // Just in the normal direction
    this.equations = [normal];

    this.maxForce = maxForce;

    // g = (xi - xj).dot(n)
    // dg/dt = (vi - vj).dot(n) = G*W = [n 0 -n 0] * [vi wi vj wj]'

    // ...and if we were to include offset points (TODO for now):
    // g =
    //      (xj + rj - xi - ri).dot(n) - distance
    //
    // dg/dt =
    //      (vj + wj x rj - vi - wi x ri).dot(n) =
    //      { term 2 is near zero } =
    //      [-n   -ri x n   n   rj x n] * [vi wi vj wj]' =
    //      G * W
    //
    // => G = [-n -rixn n rjxn]

    final vec2 r = vec2.create();
    final vec2 ri = vec2.create(); // worldAnchorA
    final vec2 rj = vec2.create(); // worldAnchorB

    normal.replacedGq = () {
      Body bodyA = this.bodyA,
          bodyB = this.bodyB;
      vec2 xi = bodyA.position,
          xj = bodyB.position;

      // Transform local anchors to world
      vec2.rotate(ri, localAnchorA, bodyA.angle);
      vec2.rotate(rj, localAnchorB, bodyB.angle);

      vec2.add(r, xj, rj);
      vec2.sub(r, r, ri);
      vec2.sub(r, r, xi);

      //vec2.sub(r, bodyB.position, bodyA.position);
      return vec2.length(r) - this.distance;
    };

    // Make the contact constraint bilateral
    this.setMaxForce(maxForce);

    this.upperLimitEnabled = false;

    this.upperLimit = 1;

    this.lowerLimitEnabled = false;

    this.lowerLimit = 0;

    this.position = 0;

  }

  /**
   * Update the constraint equations. Should be done if any of the bodies changed position, before solving.
   * @method update
   */
  static final vec2 n = vec2.create();
  static final vec2 ri = vec2.create(); // worldAnchorA
  static final vec2 rj = vec2.create(); // worldAnchorB
  update() {
    Equation normal = this.equations[0];
    Body bodyA = this.bodyA,
        bodyB = this.bodyB;
    num distance = this.distance;
    vec2 xi = bodyA.position,
        xj = bodyB.position;
    Equation normalEquation = this.equations[0];
    Float32List G = normal.G;

    // Transform local anchors to world
    vec2.rotate(ri, this.localAnchorA, bodyA.angle);
    vec2.rotate(rj, this.localAnchorB, bodyB.angle);

    // Get world anchor points and normal
    vec2.add(n, xj, rj);
    vec2.sub(n, n, ri);
    vec2.sub(n, n, xi);
    this.position = vec2.length(n);

    bool violating = false;
    if (this.upperLimitEnabled) {
      if (this.position > this.upperLimit) {
        normalEquation.maxForce = 0;
        normalEquation.minForce = -this.maxForce;
        this.distance = this.upperLimit;
        violating = true;
      }
    }

    if (this.lowerLimitEnabled) {
      if (this.position < this.lowerLimit) {
        normalEquation.maxForce = this.maxForce;
        normalEquation.minForce = 0;
        this.distance = this.lowerLimit;
        violating = true;
      }
    }

    if ((this.lowerLimitEnabled || this.upperLimitEnabled) && !violating) {
      // No constraint needed.
      normalEquation.enabled = false;
      return;
    }

    normalEquation.enabled = true;

    vec2.normalize(n, n);

    // Caluclate cross products
    num rixn = vec2.crossLength(ri, n),
        rjxn = vec2.crossLength(rj, n);

    // G = [-n -rixn n rjxn]
    G[0] = -n.x;
    G[1] = -n.y;
    G[2] = -rixn;
    G[3] = n.x;
    G[4] = n.y;
    G[5] = rjxn;
  }

  /**
   * Set the max force to be used
   * @method setMaxForce
   * @param {Number} f
   */
  setMaxForce(f) {
    Equation normal = this.equations[0];
    normal.minForce = -f;
    normal.maxForce = f;
  }

  /**
   * Get the max force
   * @method getMaxForce
   * @return {Number}
   */
  num getMaxForce(num f) {
    Equation normal = this.equations[0];
    return normal.maxForce;
  }
}
