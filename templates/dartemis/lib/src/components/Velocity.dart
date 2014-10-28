part of orion;

class Velocity extends ComponentPoolable {
  num x, y;

  Velocity._();
  factory Velocity([num x = 0, num y = 0]) {
    Velocity velocity = new Poolable.of(Velocity, _constructor);
    velocity.x = x;
    velocity.y = y;
    return velocity;
  }
  static Velocity _constructor() => new Velocity._();
}
