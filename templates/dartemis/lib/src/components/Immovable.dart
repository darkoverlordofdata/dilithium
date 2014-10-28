part of orion;

class Immovable extends ComponentPoolable {
  bool value;

  Immovable._();
  factory Immovable([value = true]) {
    Immovable immovable = new Poolable.of(Immovable, _constructor);
    immovable.value = value;
    return immovable;
  }
  static Immovable _constructor() => new Immovable._();
}

