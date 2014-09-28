/*
Copyright (c) 2014 Bruce Davidson <darkoverlordofdata@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

library example;
import 'dart:js';
import 'dart:html';

import "package:dilithium/dilithium.dart";
import 'package:play_phaser/phaser.dart';
import 'package:rikulo_gap/device.dart' as cordova;
part 'src/Test.dart';
part 'src/Demo.dart';

void main() {

  String path = "config.yaml";

  start(path, device) =>
    HttpRequest.getString(path)
      .then((String source) =>
        new Test(new Config(source), device));


  if (context['cordova'] != null) {
    try {
      cordova.Device.init()
      .then((device) => start(path, device))
      .catchError((ex, st) {
        print(ex);
        print(st);
        start(path, null);
      });
    }
    catch (e) {
      start(path, null);
    }
  }
  else start(path, null);
}



