//NYI
// use localized strings? Maybe for periodic table long names?

v_ok = function(v) {
    is_v_ok = (v != undefined && v != null);
    if (!is_v_ok) return false;
    if (typeof(v) == 'object') {
        vkeys = Object.keys(v);
        if (vkeys.length == undefined) return false;
        if (vkeys.length < 1) return false;
    }
    return is_v_ok;
}

// from http://www.mojavelinux.com/articles/javascript_hashes.html
function HashTable(obj)
{
    this.length = 0;
    this.items = {};
    for (var p in obj) {
        if (obj.hasOwnProperty(p)) {
            this.items[p] = obj[p];
            this.length++;
        }
    }

    this.set = function(key, value)
    {
        var previous = undefined;
        if (this.has(key)) {
            previous = this.items[key];
        }
        else {
            this.length++;
        }
        this.items[key] = value;
        return previous;
    }

    this.get = function(key) {
        return this.has(key) ? this.items[key] : undefined;
    }

    this.has = function(key)
    {
        return this.items.hasOwnProperty(key);
    }
   
    this.remove = function(key)
    {
        if (this.has(key)) {
            previous = this.items[key];
            this.length--;
            delete this.items[key];
            return previous;
        }
        else {
            return undefined;
        }
    }

    this.keys = function()
    {
        var keys = [];
        for (var k in this.items) {
            if (this.has(k)) {
                keys.push(k);
            }
        }
        return keys;
    }

    this.values = function()
    {
        var values = [];
        for (var k in this.items) {
            if (this.has(k)) {
                values.push(this.items[k]);
            }
        }
        return values;
    }

    this.each = function(fn) {
        for (var k in this.items) {
            if (this.has(k)) {
                fn(k, this.items[k]);
            }
        }
    }

    this.clear = function()
    {
        this.items = {}
        this.length = 0;
    }
}

nonWSTrimLeft = function(instr, trimchars) {
    var rv = instr;
    var pos = 0;
    var tcfound = trimchars.indexOf(instr[pos]) >= 0;
    while (pos < instr.length && tcfound) {
        pos++;
        tcfound = trimchars.indexOf(instr[pos]) >= 0;    
    };
    if (tcfound) {
        rv  = "";
    } else {
        rv = instr.substr(pos);
    };
    
    return rv;    
}
    
nonWSTrimRight = function(instr, trimchars) {
    var rv = instr;
    var pos = instr.length - 1;
    var tcfound = trimchars.indexOf(instr[pos]) >= 0;
    while (pos > -1 && tcfound) {
        pos--;
        tcfound = trimchars.indexOf(instr[pos]) >= 0;    
    };
    if (tcfound) {
        rv  = "";
    } else {
        rv = instr.substr(0, pos + 1);
    };
    
    return rv;    
}
    
nonWSTrim = function(instr, trimchars) {
    var rv = nonWSTrimLeft(instr, trimchars);
    rv = nonWSTrimRight(rv, trimchars);
    return rv;
}

// This function is needed because JS dynamically updates the iterator for
// a loop. Therefore, the initial state of an iterator, which is the assumed
// state, is not so
copyMap = function(inmap) {
    var rv = new HashTable();
    for (var k in inmap.keys()){
        rv[k] = inmap[k];
    };
    return rv;
};

kpEnterHandler = function(event, handler_func) {
    if (event.which == 13 || event.keyCode == 13) {
        handler_func();
        return false;
    }
    return true;
};

// Polyfills (or shims)
/*! https://mths.be/codepointat v0.2.0 by @mathias */
if (!String.prototype.codePointAt) {
  (function() {
    'use strict'; // needed to support `apply`/`call` with `undefined`/`null`
    var defineProperty = (function() {
      // IE 8 only supports `Object.defineProperty` on DOM elements
      try {
        var object = {};
        var $defineProperty = Object.defineProperty;
        var result = $defineProperty(object, object, object) && $defineProperty;
      } catch(error) {}
      return result;
    }());
    var codePointAt = function(position) {
      if (this == null) {
        throw TypeError();
      }
      var string = String(this);
      var size = string.length;
      // `ToInteger`
      var index = position ? Number(position) : 0;
      if (index != index) { // better `isNaN`
        index = 0;
      }
      // Account for out-of-bounds indices:
      if (index < 0 || index >= size) {
        return undefined;
      }
      // Get the first code unit
      var first = string.charCodeAt(index);
      var second;
      if ( // check if it’s the start of a surrogate pair
        first >= 0xD800 && first <= 0xDBFF && // high surrogate
        size > index + 1 // there is a next code unit
      ) {
        second = string.charCodeAt(index + 1);
        if (second >= 0xDC00 && second <= 0xDFFF) { // low surrogate
          // https://mathiasbynens.be/notes/javascript-encoding#surrogate-formulae
          return (first - 0xD800) * 0x400 + second - 0xDC00 + 0x10000;
        }
      }
      return first;
    };
    if (defineProperty) {
      defineProperty(String.prototype, 'codePointAt', {
        'value': codePointAt,
        'configurable': true,
        'writable': true
      });
    } else {
      String.prototype.codePointAt = codePointAt;
    }
  }());
}

/*! https://mths.be/fromcodepoint v0.2.1 by @mathias */
if (!String.fromCodePoint) {
  (function() {
    var defineProperty = (function() {
      // IE 8 only supports `Object.defineProperty` on DOM elements
      try {
        var object = {};
        var $defineProperty = Object.defineProperty;
        var result = $defineProperty(object, object, object) && $defineProperty;
      } catch(error) {}
      return result;
    }());
    var stringFromCharCode = String.fromCharCode;
    var floor = Math.floor;
    var fromCodePoint = function(_) {
      var MAX_SIZE = 0x4000;
      var codeUnits = [];
      var highSurrogate;
      var lowSurrogate;
      var index = -1;
      var length = arguments.length;
      if (!length) {
        return '';
      }
      var result = '';
      while (++index < length) {
        var codePoint = Number(arguments[index]);
        if (
          !isFinite(codePoint) || // `NaN`, `+Infinity`, or `-Infinity`
          codePoint < 0 || // not a valid Unicode code point
          codePoint > 0x10FFFF || // not a valid Unicode code point
          floor(codePoint) != codePoint // not an integer
        ) {
          throw RangeError('Invalid code point: ' + codePoint);
        }
        if (codePoint <= 0xFFFF) { // BMP code point
          codeUnits.push(codePoint);
        } else { // Astral code point; split in surrogate halves
          // https://mathiasbynens.be/notes/javascript-encoding#surrogate-formulae
          codePoint -= 0x10000;
          highSurrogate = (codePoint >> 10) + 0xD800;
          lowSurrogate = (codePoint % 0x400) + 0xDC00;
          codeUnits.push(highSurrogate, lowSurrogate);
        }
        if (index + 1 == length || codeUnits.length > MAX_SIZE) {
          result += stringFromCharCode.apply(null, codeUnits);
          codeUnits.length = 0;
        }
      }
      return result;
    };
    if (defineProperty) {
      defineProperty(String, 'fromCodePoint', {
        'value': fromCodePoint,
        'configurable': true,
        'writable': true
      });
    } else {
      String.fromCodePoint = fromCodePoint;
    }
  }());
}
// end Polyfills

var PT = {};
PT["Ac"] = ["Actinium",89];
PT["Ag"] = ["Silver",47];
PT["Al"] = ["Aluminum",13];
PT["Am"] = ["Americium",95];
PT["Ar"] = ["Argon",18];
PT["As"] = ["Arsenic",33];
PT["At"] = ["Astatine",85];
PT["Au"] = ["Gold",79];
PT["B"] = ["Boron",5];
PT["Ba"] = ["Barium",56];
PT["Be"] = ["Beryllium",4];
PT["Bh"] = ["Bohrium",107];
PT["Bi"] = ["Bismuth",83];
PT["Bk"] = ["Berkelium",97];
PT["Br"] = ["Bromine",35];
PT["C"] = ["Carbon",6];
PT["Ca"] = ["Calcium",20];
PT["Cd"] = ["Cadmium",48];
PT["Ce"] = ["Cerium",58];
PT["Cf"] = ["Californium",98];
PT["Cl"] = ["Chlorine",17];
PT["Cm"] = ["Curium",96];
PT["Co"] = ["Cobalt",27];
PT["Cr"] = ["Chromium",24];
PT["Cs"] = ["Cesium",55];
PT["Cu"] = ["Copper",29];
PT["Db"] = ["Dubnium",105];
PT["Ds"] = ["Darmstadtium",110];
PT["Dy"] = ["Dysprosium",66];
PT["Er"] = ["Erbium",68];
PT["Es"] = ["Einsteinium",99];
PT["Eu"] = ["Europium",63];
PT["F"] = ["Fluorine",9];
PT["Fe"] = ["Iron",26];
PT["Fm"] = ["Fermium",100];
PT["Fr"] = ["Francium",87];
PT["Ga"] = ["Gallium",31];
PT["Gd"] = ["Gadolinium",64];
PT["Ge"] = ["Germanium",32];
PT["H"] = ["Hydrogen",1];
PT["He"] = ["Helium",2];
PT["Hf"] = ["Hafnium",72];
PT["Hg"] = ["Mercury",80];
PT["Ho"] = ["Holmium",67];
PT["Hs"] = ["Hassium",108];
PT["I"] = ["Iodine",53];
PT["In"] = ["Indium",49];
PT["Ir"] = ["Iridium",77];
PT["K"] = ["Potassium",19];
PT["Kr"] = ["Krypton",36];
PT["La"] = ["Lanthanum",57];
PT["Li"] = ["Lithium",3];
PT["Lr"] = ["Lawrencium",103];
PT["Lu"] = ["Lutetium",71];
PT["Md"] = ["Mendelevium",101];
PT["Mg"] = ["Magnesium",12];
PT["Mn"] = ["Manganese",25];
PT["Mo"] = ["Molybdenum",42];
PT["Mt"] = ["Meitnerium",109];
PT["N"] = ["Nitrogen",7];
PT["Na"] = ["Sodium",11];
PT["Nb"] = ["Niobium",41];
PT["Nd"] = ["Neodymium",60];
PT["Ne"] = ["Neon",10];
PT["Ni"] = ["Nickel",28];
PT["No"] = ["Nobelium",102];
PT["Np"] = ["Neptunium",93];
PT["O"] = ["Oxygen",8];
PT["Os"] = ["Osmium",76];
PT["P"] = ["Phosphorus",15];
PT["Pa"] = ["Protactinium",91];
PT["Pb"] = ["Lead",82];
PT["Pd"] = ["Palladium",46];
PT["Pm"] = ["Promethium",61];
PT["Po"] = ["Polonium",84];
PT["Pr"] = ["Praseodymium",59];
PT["Pt"] = ["Platinum",78];
PT["Pu"] = ["Plutonium",94];
PT["Ra"] = ["Radium",88];
PT["Rb"] = ["Rubidium",37];
PT["Re"] = ["Rhenium",75];
PT["Rf"] = ["Rutherfordium",104];
PT["Rg"] = ["Roentgenium",111];
PT["Rh"] = ["Rhodium",45];
PT["Rn"] = ["Radon",86];
PT["Ru"] = ["Ruthenium",44];
PT["S"] = ["Sulfur",16];
PT["Sb"] = ["Antimony",51];
PT["Sc"] = ["Scandium",21];
PT["Se"] = ["Selenium",34];
PT["Sg"] = ["Seaborgium",106];
PT["Si"] = ["Silicon",14];
PT["Sm"] = ["Samarium",62];
PT["Sn"] = ["Tin",50];
PT["Sr"] = ["Strontium",38];
PT["Ta"] = ["Tantalum",73];
PT["Tb"] = ["Terbium",65];
PT["Tc"] = ["Technetium",43];
PT["Te"] = ["Tellurium",52];
PT["Th"] = ["Thorium",90];
PT["Ti"] = ["Titanium",22];
PT["Tl"] = ["Thallium",81];
PT["Tm"] = ["Thulium",69];
PT["U"] = ["Uranium",92];
PT["V"] = ["Vanadium",23];
PT["W"] = ["Tungsten",74];
PT["Xe"] = ["Xenon",54];
PT["Y"] = ["Yttrium",39];
PT["Yb"] = ["Ytterbium",70];
PT["Zn"] = ["Zinc",30];
PT["Zr"] = ["Zirconium",40];
