part of orion;

class Gravity extends ComponentPoolable {
  num x, y;

  Gravity._();
  factory Gravity([num x = 0, num y = 0]) {
    Gravity gravity = new Poolable.of(Gravity, _constructor);
    gravity.x = x;
    gravity.y = y;
    return gravity;
  }
  static Gravity _constructor() => new Gravity._();
}



