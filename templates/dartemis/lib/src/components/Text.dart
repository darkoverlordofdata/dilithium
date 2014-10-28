part of orion;

class Text extends ComponentPoolable {

  String value;
  String font;
  String fill;

  Text._();
  factory Text(String value, String font, String fill) {
    Text text = new Poolable.of(Text, _constructor);
    text.value = value;
    text.font = font;
    text.fill = fill;
    return text;
  }
  static Text _constructor() => new Text._();
}


