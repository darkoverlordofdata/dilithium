part of orion;

class Scale extends ComponentPoolable {
  num x, y;

  Scale._();
  factory Scale([num x = 0, num y = 0]) {
    Scale scale = new Poolable.of(Scale, _constructor);
    scale.x = x;
    scale.y = y;
    return scale;
  }
  static Scale _constructor() => new Scale._();
}

