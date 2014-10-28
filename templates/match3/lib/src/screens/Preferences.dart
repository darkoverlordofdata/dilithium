/**
 *--------------------------------------------------------------------+
 * Preferences.dart
 *--------------------------------------------------------------------+
 * Copyright {{project.author}} (c) {{project.copyright}}
 *--------------------------------------------------------------------+
 *
 * This file is a part of {{ project.libname }}
 *
 * {{ project.libname }} is free software; you can copy, modify, and distribute
 * it under the terms of the {{ project.license }}
 *
 *--------------------------------------------------------------------+
 *
 */
part of {{ project.libname }};

class Preferences extends Li2State {

  Li2Config config;
  Li2Template template;

  /**
   * Preferences use HTML ui
   */
  Preferences(this.config, this.template) {
    print('Preferences Class initialized');
  }

  create() {

    querySelector(config.preferences['id'])
      ..setInnerHtml(template.render(config.preferences))
      ..style.display = 'inline';

  }
}

