part of Phaser;

class Utils {
  Utils() {
  }

  static List<List> transposeArray(List<List> array) {
    var result = new List(array[0].length);
    for (var i = 0; i < array[0].length; i++) {
      result[i] = new List(array.length - 1);

      for (var j = array.length - 1; j > -1; j--) {
        result[i][j] = array[j][i];
      }
    }
    return result;
  }

  static List<List> rotateArray(List<List> matrix, direction) {

    if (!(direction is String)) {
      direction = ((direction % 360) + 360) % 360;
    }

    if (direction == 90 || direction == -270 || direction == 'rotateLeft') {
      matrix = Utils.transposeArray(matrix);
      matrix = matrix.reversed.toList();
    }
    else if (direction == -90 || direction == 270 || direction == 'rotateRight') {
      matrix = matrix.reversed.toList();
      matrix = Utils.transposeArray(matrix);
    }
    else if (Math.abs(direction) == 180 || direction == 'rotate180') {
        for (var i = 0; i < matrix.length; i++) {
          matrix[i].reversed.toList();
        }

        matrix = matrix.reversed.toList();
      }

    return matrix;

  }

  static num parseDimension(size, num dimension) {

    num f = 0;
    num px = 0;

    if (size is String) {
      //String size=size;
      //  %?
      if (size.substring(size.length - 1) == '%') {
        f = int.parse(size) / 100;

        if (dimension == 0) {
          px = window.innerWidth * f;
        }
        else {
          px = window.innerHeight * f;
        }
      }
      else {
        px = int.parse(size);
      }
    }
    else {
      px = size;
    }

    return px;

  }

  /**
   * A standard Fisher-Yates Array shuffle implementation.
   * @method Phaser.Utils.shuffle
   * @param {array} array - The array to shuffle.
   * @return {array} The shuffled array.
   */

  static List shuffle(List array) {
//    for (var i = array.length - 1; i > 0; i--)
//    {
//      var j = Math.floor(Math.random() * (i + 1));
//      var temp = array[i];
//      array[i] = array[j];
//      array[j] = temp;
//    }
    return new List.from(array)..shuffle();
  }

  /**
   * Javascript string pad http://www.webtoolkit.info/.
   * pad = the string to pad it out with (defaults to a space)
   * dir = 1 (left), 2 (right), 3 (both)
   * @method Phaser.Utils.pad
   * @param {string} str - The target string.
   * @param {number} len - The number of characters to be added.
   * @param {number} pad - The string to pad it out with (defaults to a space).
   * @param {number} [dir=3] The direction dir = 1 (left), 2 (right), 3 (both).
   * @return {string} The padded string
   */

//  static String pad(String str, [int len =0, String pad =' ', int dir=3]) {
//
//    int padlen = 0;
//
//    if (len + 1 >= str.length) {
//      switch (dir) {
//        case 1:
//          str = new String(len + 1 - str.length).join(pad) + str;
//          break;
//
//        case 3:
//          var right = Math.ceil((padlen = len - str.length) / 2);
//          var left = padlen - right;
//          str = new String(left + 1).join(pad) + str + new String(right + 1).join(pad);
//          break;
//
//        default:
//          str = str + new String(len + 1 - str.length).join(pad);
//          break;
//      }
//    }
//
//    return str;
//
//  }

  /**
   * This is a slightly modified version of jQuery.isPlainObject. A plain object is an object whose internal class property is [object Object].
   * @method Phaser.Utils.isPlainObject
   * @param {object} obj - The object to inspect.
   * @return {boolean} - true if the object is plain, otherwise false.
   */

//  static bool isPlainObjectTODO(obj) {
//
//    // Not plain objects:
//    // - Any object or value whose internal [[Class]] property is not "[object Object]"
//    // - DOM nodes
//    // - window
//    if (!(obj is Object) || obj.nodeType || obj == obj.window) {
//      return false;
//    }
//
//    // Support: Firefox <20
//    // The try/catch suppresses exceptions thrown when attempting to access
//    // the "constructor" property of certain host objects, ie. |window.location|
//    // https://bugzilla.mozilla.org/show_bug.cgi?id=814622
////    try {
////      if (obj.constructor && !({
////      }).hasOwnProperty.call(obj.constructor.prototype, "isPrototypeOf")) {
////        return false;
////      }
////    } catch (e) {
////      return false;
////    }
//
//    // If the function hasn't returned already, we're confident that
//    // |obj| is a plain object, created by {} or constructed with new Object
//    return true;
//  }
}

/**
 * This is a slightly modified version of http://api.jquery.com/jQuery.extend/
 * @method Phaser.Utils.extend
 * @param {boolean} deep - Perform a deep copy?
 * @param {object} target - The target object to copy to.
 * @return {object} The extended object.
 */
//   extend () {
//
//    var options, name, src, copy, copyIsArray, clone,
//    target = arguments[0] || {},
//    i = 1,
//    length = arguments.length,
//    deep = false;
//
//    // Handle a deep copy situation
//    if (typeof target === "boolean")
//    {
//      deep = target;
//      target = arguments[1] || {};
//      // skip the boolean and the target
//      i = 2;
//    }
//
//    // extend Phaser if only one argument is passed
//    if (length === i)
//    {
//      target = this;
//      --i;
//    }
//
//    for (; i < length; i++)
//    {
//      // Only deal with non-null/undefined values
//      if ((options = arguments[i]) != null)
//      {
//        // Extend the base object
//        for (name in options)
//        {
//          src = target[name];
//          copy = options[name];
//
//          // Prevent never-ending loop
//          if (target === copy)
//          {
//            continue;
//          }
//
//          // Recurse if we're merging plain objects or arrays
//          if (deep && copy && (Phaser.Utils.isPlainObject(copy) || (copyIsArray = Array.isArray(copy))))
//          {
//            if (copyIsArray)
//            {
//              copyIsArray = false;
//              clone = src && Array.isArray(src) ? src : [];
//            }
//            else
//            {
//              clone = src && Phaser.Utils.isPlainObject(src) ? src : {};
//            }
//
//            // Never move original objects, clone them
//            target[name] = Phaser.Utils.extend(deep, clone, copy);
//
//            // Don't bring in undefined values
//          }
//          else if (copy !== undefined)
//          {
//            target[name] = copy;
//          }
//        }
//      }
//    }
//
//    // Return the modified object
//    return target;
//
//  },

/**
 * Mixes the source object into the destination object, returning the newly modified destination object.
 * Based on original code by @mudcube
 *
 * @method Phaser.Utils.mixin
 * @param {object} from - The object to copy (the source object).
 * @param {object} to - The object to copy to (the destination object).
 * @return {object} The modified destination object.
 */
//  mixin: function (from, to) {
//
//    if (!from || typeof (from) !== "object")
//    {
//      return to;
//    }
//
//    for (var key in from)
//    {
//      var o = from[key];
//
//      if (o.childNodes || o.cloneNode)
//      {
//        continue;
//      }
//
//      var type = typeof (from[key]);
//
//      if (!from[key] || type !== "object")
//      {
//        to[key] = from[key];
//      }
//      else
//      {
//        //  Clone sub-object
//        if (typeof (to[key]) === type)
//        {
//          to[key] = Phaser.Utils.mixin(from[key], to[key]);
//        }
//        else
//        {
//          to[key] = Phaser.Utils.mixin(from[key], new o.constructor());
//        }
//      }
//    }
//
//    return to;
//
//  }
//
//};

///**
// * A polyfill for Function.prototype.bind
// */
//if (typeof Function.prototype.bind != 'function') {
//
///* jshint freeze: false */
//Function.prototype.bind = (function () {
//
//var slice = Array.prototype.slice;
//
//return function (thisArg) {
//
//var target = this, boundArgs = slice.call(arguments, 1);
//
//if (typeof target != 'function')
//{
//throw new TypeError();
//}
////
////function bound() {
////var args = boundArgs.concat(slice.call(arguments));
////target.apply(this instanceof bound ? this : thisArg, args);
////}
////
////bound.prototype = (function F(proto) {
////if (proto)
////{
////F.prototype = proto;
////}
////
////if (!(this instanceof F))
////{
////return new F;
////}
////})(target.prototype);
////
////return bound;
////};
////})();
////}
//
///**
// * A polyfill for Array.isArray
// */
//if (!Array.isArray)
//{
//Array.isArray = function (arg)
//{
//return Object.prototype.toString.call(arg) == '[object Array]';
//};
//}
//
///**
// * A polyfill for Array.forEach
// * https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach
// */
//if (!Array.prototype.forEach)
//{
//Array.prototype.forEach = function(fun /*, thisArg */)
//{
//"use strict";
//
//if (this === void 0 || this === null)
//{
//throw new TypeError();
//}
//
//var t = Object(this);
//var len = t.length >>> 0;
//
//if (typeof fun !== "function")
//{
//throw new TypeError();
//}
//
//var thisArg = arguments.length >= 2 ? arguments[1] : void 0;
//
//for (var i = 0; i < len; i++)
//{
//if (i in t)
//{
//fun.call(thisArg, t[i], i, t);
//}
//}
//};
//}
//
///**
// * Low-budget Float32Array knock-off, suitable for use with P2.js in IE9
// * Source: http://www.html5gamedevs.com/topic/5988-phaser-12-ie9/
// * Cameron Foale (http://www.kibibu.com)
// */
//if (typeof window.Uint32Array !== "function")
//{
//var CheapArray = function(type)
//{
//var proto = new Array(); // jshint ignore:line
//
//window[type] = function(arg) {
//
//if (typeof(arg) === "number")
//{
//Array.call(this, arg);
//this.length = arg;
//
//for (var i = 0; i < this.length; i++)
//{
//this[i] = 0;
//}
//}
//else
//{
//Array.call(this, arg.length);
//
//this.length = arg.length;
//
//for (var i = 0; i < this.length; i++)
//{
//this[i] = arg[i];
//}
//}
//};
//
//window[type].prototype = proto;
//window[type].constructor = window[type];
//};
//
//CheapArray('Uint32Array'); // jshint ignore:line
//CheapArray('Int16Array');  // jshint ignore:line
//}
//
//
//}
