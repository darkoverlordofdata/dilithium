part of orion;

class Count extends ComponentPoolable {
  int value;

  Count._();
  factory Count([value = true]) {
    Count count = new Poolable.of(Count, _constructor);
    count.value = value;
    return count;
  }
  static Count _constructor() => new Count._();
}

