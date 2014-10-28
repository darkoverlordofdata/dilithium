part of orion;

class Sprite extends ComponentPoolable {

  num x;
  num y;
  String key;
  var frame;

  Sprite._();
  factory Sprite(num x, num y, String key, [frame]) {
    Sprite sprite = new Poolable.of(Sprite, _constructor);
    sprite.x = x;
    sprite.y = y;
    sprite.key = key;
    sprite.frame = frame;
    return sprite;
  }
  static Sprite _constructor() => new Sprite._();
}


