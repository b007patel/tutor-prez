// NYI: 
// use localized strings? Angular JS vs other JS frameworks? Check out JS
// projects from todomvc.com for an in-depth comparison
// ? probably more php-side - add CSS/HTML(JS?) output to prettify output

var nwstrim, nwstrimleft, nwstrimright;
var last_rxn;
var rxntxt = document.getElementById("reaction");
var def_display = rxntxt.style.display;
var ballding = document.getElementById("loadjs");
var baldetails = document.getElementById("balance_details");

function ChemRxnSide() {}

ChemRxnSide.prototype = {
    parseRxnSide: function(instr) {
        //set trim functions
        nwstrim = nonWSTrim;
        nwstrimleft = nonWSTrimLeft;
        nwstrimright = nonWSTrimRight;
        
        this.errstr = "";
        this.comps = new HashTable();

        this.get_comps_with_pluses(instr);
        if (!v_ok(this.comps)) {
            inv_rxn = "The reaction {" + instr + "} is invalid!!";
                console.log(inv_rxn);
        }
    }
}
    
// Assumed instr already starts with a capital
ChemRxnSide.prototype.find_capital_term = function(instr) {
    if (instr.length < 1) {
        return "";
    }
    // must check entire alphabet in case a polyatomic ion has
    // a letter to the right of the left letters comes before that
    // letter (e.g., OH fits because 'H' comes before 'O'
    var nextcap = 32767;
    var posrc = -1;
    
    for (var cur_cap = "A".codePointAt(0);
            cur_cap <= "Z".codePointAt(0); cur_cap++) {
        posrc = instr.indexOf(String.fromCodePoint(cur_cap), 1);
        if (posrc >= 0) {
            if (posrc < nextcap) {
                nextcap = posrc;
            }
        }
    }            
    if (nextcap < 1) {
        return instr;
    }
    return nwstrim(instr.substr(0, nextcap), "()");
}

// find all polyatomic ions with subscript > 1
ChemRxnSide.prototype.find_all_pa_ions = function(instr, firstlb) {
    var pa_rv = "";    
    var lblist = [firstlb];
    var cur_lbpos = firstlb + 1;
    var nextlb = 1;
    var nextrb = -1;
    var lbpos = -1;
    var rbpos = -1;
    
    while ((lbpos = instr.indexOf("(", cur_lbpos)) >= 0) {
        lblist[nextlb] = lbpos;
        cur_lbpos = lbpos + 2;
        nextlb++; 
    }
    if ((rbpos = instr.indexOf(")")) < 0) {
        this.errstr += "No closing bracket for polyatomic ion ";
        this.errstr += instr + "~+";
        return "";
    }
    var rblist = [rbpos];
    var cur_rbpos = rbpos + 1;
    nextrb = 1;
    while ((rbpos = instr.indexOf(")", cur_rbpos)) >= 0) {
        rblist[nextrb] = rbpos;
        cur_rbpos = rbpos + 1;
        nextrb++; 
    }
    if (lblist.length != rblist.length) {
        this.errstr += "There are " + lblist.length + " ('s, yet ";
        this.errstr += "there are " + rblist.length + " )'s in "+ instr;
        this.errstr += " These counts should be the same~+";
        return "";
    }
    var val_0 = "0".codePointAt();
    var cur_digpos = 0;
    var cur_dig = 0;
    for (var i = 0; i < lblist.length; i++) {
        if ((rblist[i] - lblist[i]) < 3) {
            this.errstr += "There is only one element between the ";
            this.errstr += "()s at positions " + (lblist[i] + 1);
            this.errstr += " and " + (rblist[i] + 1) + " in ";
            this.errstr += instr + "~+";
            return "";
        }
        if ((rblist[i] - lblist[i]) < 4) {
            if (instr[rblist[i] - 1] >= "a" ) {
                this.errstr += "There is only one element between the ";
                this.errstr += "()s at positions " + (lblist[i] + 1);
                this.errstr += " and " + (rblist[i] + 1) + " in ";
                this.errstr += instr + "~+";
                return "";
            }
        }
        cur_digpos = rblist[i] + 1;
        cur_dig = instr[cur_digpos].codePointAt() - val_0;
        if (cur_dig < 0 || cur_dig > 9) {
            this.errstr += "Bracketed polyatomic ion has no outer ";
            this.errstr += "subscript in " + instr + " near char ";
            this.errstr += cur_digpos + "~+";
            return "";
        }
        cur_digpos++;
        while (cur_digpos < instr.length && 
                (cur_dig < 0 || cur_dig > 9)) {
            cur_dig = instr[cur_digpos].codePointAt() - val_0;
            cur_digpos++;
        }
        var subscriptstr = instr.substr(rblist[i] + 1,
                cur_digpos - rblist[i]); 
        var ion_str = "~";
        ion_str += instr.substr(lblist[i] + 1,
                rblist[i] - lblist[i] - 1);
        pa_rv += ion_str + "=" + subscriptstr + "|";
    }
    return nwstrimright(pa_rv, "|");
}

// scan reaction string, "skim" terms. If OK, add keys to the
// compounds array
ChemRxnSide.prototype.init_comps = function(instr) {
    var rawcomps = instr.split("+");
    var lbpos = -1;
    var ion_info, cur_cpd;
    
    for (var rawcp_i in rawcomps) {
        var rawcp = rawcomps[rawcp_i];
        rawcp = nwstrimleft(rawcp, "0123456789").trim();
        if (rawcp[0].codePointAt() >= "a".codePointAt()) {
            this.errstr += "First element invalid: starts with ";
            this.errstr += "lower-case letter~+";
            this.comps = undefined; return;
        }
        // start off with 1 of each compound (i.e., coefficient=1)
        if (this.comps != undefined) {
            this.comps.set(rawcp, new HashTable());
            cur_cpd = this.comps.get(rawcp);
            cur_cpd.set("#", 1);
        }
        if ((lbpos = rawcp.indexOf("(")) >= 0) {
            var pa_str = this.find_all_pa_ions(rawcp, lbpos);
            if (pa_str.length < 2) {
                this.comps = undefined; return;
            }
            var pa_list = pa_str.split("|");
            for (var ion_i in pa_list) {
                var cur_ion = pa_list[ion_i];
                ion_info = cur_ion.split("=");
                this.comps.get(rawcp).set(ion_info[0], parseInt(ion_info[1]));
            }
        }
    }
}

ChemRxnSide.prototype.count_elems = function(rawcp, rawcpstr, sub) {
    var cur_elem = "";
    var atomcnt = [];
    var cur_cnt = 0;
    // initialized parms not allowed
    if (!v_ok(sub)) sub = 1;
    
    rawcpstr = nwstrimleft(rawcpstr, "~");
    var cur_term = this.find_capital_term(rawcpstr);
    while (cur_term.length > 0) {
        cur_elem = cur_term;
        var re = /([1-9]\d*)/i;
        atomcnt = cur_term.match(re);
        if (atomcnt != null) {
            cur_elem = nwstrimright(cur_term, "0123456789");
            atomcnt = [atomcnt[1]];
        } else {
            atomcnt = ["1"];
        }
        if (!(cur_elem in PT)) {
            this.errstr += "Invalid element '" + cur_elem + "'~+";
            this.comps = undefined; return false;
        }
        rawcpstr =  rawcpstr.substr(cur_term.length);
        var rcp = copyMap(this.comps.get(rawcp));
        if (rcp[cur_elem] === undefined) {
            cur_cnt = 0;
        } else {
            cur_cnt = rcp[cur_elem];
        }
        this.comps.get(rawcp).set(cur_elem, 
                cur_cnt + (parseInt(atomcnt[0])*sub));
        cur_term = this.find_capital_term(rawcpstr);
    }
    return true;
}

ChemRxnSide.prototype.get_comps_with_pluses = function(instr) {
    var srchstr = "";
    var raw_ion = "";
    var cur_term = "";
    var sub = 0;
    
    // in case "==", "===", etc are in input
    if (instr === undefined || instr.length < 1) return;
    this.init_comps(instr);
    if (!v_ok(this.comps)) return;
    for (var rawcp in this.comps.items) {
        srchstr = rawcp;
        gc_cpd_entry = this.comps.get(rawcp);
        var rcp = copyMap(gc_cpd_entry);
        if (!v_ok(rcp)) {
            pa_ion: for (var ion_sym in rcp) {
                if (ion_sym == "#") {
                    continue pa_ion;
                }
                // BP - ??
                sub = rcp.get(ion_sym);
                raw_ion = "(" + ion_sym.substr(1) + ")" + sub;
                //find elems in ion, and counts. Multiply counts by subscr
                if (this.count_elems(rawcp, ion_sym, sub) == false) {
                    this.comps = undefined; return;
                }
                // remove ion and sub from srchstr
                srchstr = srchstr.replace(raw_ion, "");
                // remove ion entry from map
                rcp.remove(ion_sym);
                gc_cpd_entry.remove(ion_sym);
            }
        }
        //find remaining elems and their counts, if any
        if (this.count_elems(rawcp, srchstr) == false) {
            this.comps = undefined; return;
        }
        cur_term = this.find_capital_term(srchstr);
    }
    // sort element entries in each compound
    if (v_ok(this.comps)) {
        var tmparr = [];
        for (var cp in this.comps.items) {
            // cannot sort on comps because maps are not sortable.
            // Copy to array, sort that, then pave over comps 
            // entries instead.
            tmparr = [];
            gc_elemcpd_entry = this.comps.get(cp)
            for (var e in gc_elemcpd_entry.items) {
                var v = gc_elemcpd_entry.get(e);
                tmparr.push([e, v]);
            }
            tmparr.sort(function(a,b) {
                if (a[0] < b[0]) return -1;
                if (a[0] > b[0]) return 1;
                return 0;
            });
            gc_elemcpd_entry.clear();
            for (var i in tmparr) {
                gc_elemcpd_entry.set(tmparr[i][0], tmparr[i][1]);
            }
        }
    } else {
        this.errstr += "No element entries to sort!!~+";
        this.comps = undefined;
    }
}

ChemRxnSide.prototype.getComps = function() {
    return this.comps;
}

ChemRxnSide.prototype.getErrorString = function() {
    return this.errstr;
}

//toJSON() is the system-defined hook name for JSON.stringify()
ChemRxnSide.prototype.toJSON = function() {
    var rv = '{';
    if (!v_ok(this.comps)) {
        // need closing ] and } to make sure string is not truncated
        // when toJSON() ancestor code runs
        json_rxntxt = document.getElementById("reaction");
        rv = "--BAD--" + json_rxntxt.value + "]]}";
        return rv;
    }
    for (var cpd in this.comps.items) {
        cpd_json_entry = this.comps.get(cpd);
        rv += '"' + cpd + '": [{';
        for (var e in cpd_json_entry.items) {
            rv += '"' + e + '" : ';
            rv += cpd_json_entry.get(e) + '}, {';
        }
        rv = nwstrimright(rv, "[{, ");
        rv += '], '; 
    }
    
    rv = nwstrimright(rv, "[{, ");
    rv += '}';
    
    return rv;
}

function ChemRxn() {}

ChemRxn.prototype = {
    parseRxn: function(instr) {
        var warn_str = "WARNING! ";
        instr = instr.toString().trim();
        this.errstr = "";
        this.rxnts = undefined;
        this.prods = undefined;
        if (instr.indexOf("=") < 0) {
            this.errstr = "No products given!!~+";
        } else if (instr.indexOf("=") < 2) {
            this.errstr = "No reactants given!! Cannot start input with '='~+";
        } else if (instr.indexOf("=", (instr.indexOf("=") + 1)) >= 0) {
            if (instr.indexOf("==") >= 0) {
                this.errstr = "ERROR! Consecutive ='s not allowed!! ";
                this.errstr += "They cause products to be skipped~+";
            } else {
                this.errstr = warn_str + "Too many ='s!! All characters ";
                this.errstr += "after the second '=' have been ignored.~+";
            }
        }
        var eqsides = instr.split("=");
        this.rxnts = Object.create(ChemRxnSide.prototype);
        this.rxnts.parseRxnSide(eqsides[0]);
        if (v_ok(this.rxnts.getComps())) {
            this.prods = Object.create(ChemRxnSide.prototype);
            this.prods.parseRxnSide(eqsides[1]);
            if (!v_ok(this.prods.getComps())) {
                this.errstr += "Products: " + this.prods.getErrorString();
            }
        } else {
            this.errstr += "Reactants:" + this.rxnts.getErrorString();
        }
    }
}

// static properties
if (typeof ChemRxn.cur_rxn == 'undefined') {
    ChemRxn.cur_rxn = "";
}

if (typeof ChemRxn.last_rxn == 'undefined') {
    ChemRxn.last_rxn = "";
}

// static methods. Must follow class defintition
ChemRxn.rxnChanged = function(tb) {
    if (v_ok(tb)) {
        if (v_ok(tb.value)) {
            ChemRxn.cur_rxn = tb.value;
        }
    }
}

ChemRxn.postReaction = function() {
    var eq = Object.create(ChemRxn.prototype);
    eq.parseRxn(ChemRxn.cur_rxn);
    var post_json = JSON.stringify(eq);
    var xhr = new XMLHttpRequest();
    ChemRxn.last_rxn = ChemRxn.cur_rxn;
    ballding.style.display = def_display;
    baldetails.style.display = "none";
    xhr.open("POST", "balance.php", true);
    xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
    xhr.send(post_json);

    //console.log("xhr:", xhr);
    xhr.onloadend = function () {
        document.body.innerHTML = xhr.responseText;
        ChemRxn.lastRxnIntoText();
    }
}

ChemRxn.lastRxnIntoText = function() {
    new_rxntxt = document.getElementById("reaction");
    if (ChemRxn.last_rxn != undefined && new_rxntxt != undefined) {
        new_rxntxt.value = ChemRxn.last_rxn;
    }
    ballding = document.getElementById("loadjs");
    ballding.style.display = "none";
    baldetails = document.getElementById("balance_details");
    baldetails.style.display = def_display;
}

