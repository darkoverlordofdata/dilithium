/**
 *--------------------------------------------------------------------+
 * Li2Template.dart
 *--------------------------------------------------------------------+
 * Copyright DarkOverlordOfData (c) 2014
 *--------------------------------------------------------------------+
 *
 * This file is a part of dilithium
 *
 * dilithium is free software; you can copy, modify, and distribute
 * it under the terms of the MIT License
 *
 *--------------------------------------------------------------------+
 *
 */
part of dilithium;

/**
 * Use the Liquid template engine to generate UI bits
 */
class Li2Template {

  String template;
  var _template;

  Li2Template(String template) {
    parse(template);
  }


  parse(String template) {
    this.template = template;
    _template = context['Liquid']['Template'].callMethod('parse', [template]);
  }

  render(variables) {
    return _template.callMethod('render', [new JsObject.jsify(variables)]);
  }
}
