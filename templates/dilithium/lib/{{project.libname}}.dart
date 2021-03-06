/*

Copyright (c) {{project.copyright}} {{project.author}}

This file is part of {{project.libname}}.

{{project.libname}}. is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

{{project.libname}}. is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with {{project.libname}}.  If not, see <http://www.gnu.org/licenses/>.

*/

library {{project.libname}};

import 'dart:html';
import 'dart:math';
import 'dart:js';
import 'dart:async' as async;

import 'package:yaml/yaml.dart';
import 'package:play_phaser/phaser.dart' as Phaser;
import 'package:dilithium/dilithium.dart' as Li2;

part 'src/{{project.name}}Application.dart';
part 'src/Game.dart';
