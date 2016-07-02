// NYI: 
// use localized strings?
// ? probably more php-side - add CSS/HTML(JS?) output to prettify output

var nwstrim, nwstrimleft, nwstrimright;

class ChemRxnSide {
    // Assumed instr already starts with a capital
    find_capital_term(instr) {
        if (instr.length < 1) {
            return "";
        };
        // must check entire alphabet in case a polyatomic ion has
        // a letter to the right of the left letters comes before that
        // letter (e.g., OH fits because 'H' comes before 'O'
        let nextcap = 32767;
        let posrc = -1;
        
        for (var cur_cap = "A".codePointAt(0);
                cur_cap <= "Z".codePointAt(0); cur_cap++) {
            posrc = instr.indexOf(String.fromCodePoint(cur_cap), 1);
            if (posrc >= 0) {
                if (posrc < nextcap) {
                    nextcap = posrc;
                };
            };
        };            
        if (nextcap < 1) {
            return instr;
        };
        return nwstrim(instr.substr(0, nextcap), "()");
    };

    // find all polyatomic ions with subscript > 1
    find_all_pa_ions(instr, firstlb) {
        let pa_rv = "";    
        let lblist = [firstlb];
        let cur_lbpos = firstlb + 1;
        let nextlb = 1;
        let nextrb = -1;
        let lbpos = -1;
        let rbpos = -1;
        
        while ((lbpos = instr.indexOf("(", cur_lbpos)) >= 0) {
            lblist[nextlb] = lbpos;
            cur_lbpos = lbpos + 2;
            nextlb++; 
        };
        if ((rbpos = instr.indexOf(")")) < 0) {
            this.errstr += "No closing bracket for polyatomic ion ";
            this.errstr += instr + "~+";
            return "";
        };
        let rblist = [rbpos];
        let cur_rbpos = rbpos + 1;
        nextrb = 1;
        while ((rbpos = instr.indexOf(")", cur_rbpos)) >= 0) {
            rblist[nextrb] = rbpos;
            cur_rbpos = rbpos + 1;
            nextrb++; 
        };
        if (lblist.length != rblist.length) {
            this.errstr += "There are " + lblist.length + " ('s, yet ";
            this.errstr += "there are " + rblist.length + " )'s in "+ instr;
            this.errstr += " These counts should be the same~+";
            return "";
        };
        let val_0 = "0".codePointAt();
        let cur_digpos = 0;
        let cur_dig = 0;
        for (var i = 0; i < lblist.length; i++) {
            if ((rblist[i] - lblist[i]) < 3) {
                this.errstr += "There is only one element between the ";
                this.errstr += "()s at positions " + (lblist[i] + 1);
                this.errstr += " and " + (rblist[i] + 1) + " in ";
                this.errstr += instr + "~+";
                return "";
            };
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
            };
            cur_digpos++;
            while (cur_digpos < instr.length && 
                    (cur_dig < 0 || cur_dig > 9)) {
                cur_dig = instr[cur_digpos].codePointAt() - val_0;
                cur_digpos++;
            };
            let subscriptstr = instr.substr(rblist[i] + 1,
                    cur_digpos - rblist[i]); 
            let ion_str = "~";
            ion_str += instr.substr(lblist[i] + 1,
                    rblist[i] - lblist[i] - 1);
            pa_rv += ion_str + "=" + subscriptstr + "|";
        };
        return nwstrimright(pa_rv, "|");
    };

    // scan reaction string, "skim" terms. If OK, add keys to the
    // compounds array
    init_comps(instr) {
        let rawcomps = instr.split("+");
        let lbpos = -1;
        var ion_info, cur_cpd;
        
        for (var rawcp_i in rawcomps) {
            let rawcp = rawcomps[rawcp_i];
            rawcp = nwstrimleft(rawcp, "0123456789").trim();
            if (rawcp[0].codePointAt() >= "a".codePointAt()) {
                this.errstr += "First element invalid: starts with ";
                this.errstr += "lower-case letter~+";
                this.comps = null; return;
            };
            // start off with 1 of each compound (i.e., coefficient=1)
            if (this.comps != null) {
                this.comps.set(rawcp, new Map());
                cur_cpd = this.comps.get(rawcp);
                cur_cpd.set("#", 1);
            }
            if ((lbpos = rawcp.indexOf("(")) >= 0) {
                let pa_str = this.find_all_pa_ions(rawcp, lbpos);
                if (pa_str.length < 2) {
                    this.comps = null; return;
                };
                let pa_list = pa_str.split("|");
                for (var ion_i in pa_list) {
                    let cur_ion = pa_list[ion_i];
                    ion_info = cur_ion.split("=");
                    this.comps.get(rawcp).set(ion_info[0], 
                            parseInt(ion_info[1]));
                };
            };
        };
    };

    count_elems(rawcp, rawcpstr, sub=1) {
        let cur_elem = "";
        let atomcnt = [];
        let cur_cnt = 0;
        
        rawcpstr = nwstrimleft(rawcpstr, "~");
        let cur_term = this.find_capital_term(rawcpstr);
        while (cur_term.length > 0) {
            cur_elem = cur_term;
            var re = /([1-9]\d*)/i;
            atomcnt = cur_term.match(re);
            if (atomcnt != null) {
                cur_elem = nwstrimright(cur_term, "0123456789");
                atomcnt = [atomcnt[1]];
            } else {
                atomcnt = ["1"];
            };
            if (!PT.has(cur_elem)) {
                this.errstr += "Invalid element '" + cur_elem + "'~+";
                this.comps = null; return false;
            };
            rawcpstr =  rawcpstr.substr(cur_term.length);
            let rcp = copyMap(this.comps.get(rawcp));
            if (rcp.get(cur_elem) === undefined) {
                cur_cnt = 0;
            } else {
                cur_cnt = rcp.get(cur_elem)
            }
            this.comps.get(rawcp).set(cur_elem, cur_cnt + 
                    (parseInt(atomcnt[0])*sub));
            cur_term = this.find_capital_term(rawcpstr);
        };
        return true;
    };

    get_comps_with_pluses(instr) {
        let srchstr = "";
        let raw_ion = "";
        let cur_term = "";
        let sub = 0;
        
        // in case "==", "===", etc are in input
        if (instr === undefined || instr.length < 1) return;
        this.init_comps(instr);
        if (this.comps == null) return;
        for (var rawcp of this.comps.keys()) {
            srchstr = rawcp;
            let rcp = copyMap(this.comps.get(rawcp));
            if (rcp.size > 1) {
                pa_ion: for (var ion_sym of rcp.keys()) {
                    if (ion_sym == "#") {
                        continue pa_ion;
                    };
                    sub = rcp.get(ion_sym);
                    raw_ion = "(" + ion_sym.substr(1) + ")" + sub;
                    //find elems in ion, and counts. Multiply counts by subscr
                    if (this.count_elems(rawcp, ion_sym, sub) == false) {
                        this.comps = null; return;
                    };
                    // remove ion and sub from srchstr
                    srchstr = srchstr.replace(raw_ion, "");
                    // remove ion entry from map
                    rcp.delete(ion_sym);
                    this.comps.get(rawcp).delete(ion_sym);
                };
            };
            //find remaining elems and their counts, if any
            if (this.count_elems(rawcp, srchstr) == false) {
                this.comps = null; return;
            };
            cur_term = this.find_capital_term(srchstr);
        };
        // sort element entries in each compound
        if (this.comps.size > 0) {
            let tmparr = [];
            for (var cp of this.comps.keys()) {
                // cannot sort on this.comps because maps are not sortable.
                // Copy to array, sort that, then pave over this.comps 
                // entries instead.
                tmparr = [];
                for (var e of this.comps.get(cp).keys()) {
                    let v = this.comps.get(cp).get(e);
                    tmparr.push([e, v]);
                }
                tmparr.sort(function(a,b) {
                    if (a[0] < b[0]) return -1;
                    if (a[0] > b[0]) return 1;
                    return 0;
                });
                this.comps.get(cp).clear();
                for (var i in tmparr) {
                    this.comps.get(cp).set(tmparr[i][0], tmparr[i][1]);
                };
            };
        } else {
            this.errstr += "No element entries to sort!!~+";
            this.comps = null;
        };
    };

    getComps() {
        return this.comps;
    }
    
    getErrorString() {
        return this.errstr;
    }
    
    constructor(instr){
        //set trim functions;
        nwstrim = nonWSTrim;
        nwstrimleft = nonWSTrimLeft;
        nwstrimright = nonWSTrimRight;
        
        this.comps = new Map();
        this.errstr = "";
        
        this.get_comps_with_pluses(instr);
        if (this.comps == null) {
            console.log("The reaction {", instr, "} is invalid!!");
        };
    };
    
    toJSON() {
        let rv = '{';
        if (this.comps == null) {
            // need closing ] and } to make sure string is not truncated
            // when toJSON() ancestor code runs
            rv = "--BAD--" + $("input#reaction").val() + "]]}";
            return rv;
        }
        for (var cpd of this.comps.keys()) {
            rv += '"' + cpd + '": [{';
            //rv += cpd + ": {";
            for (var e of this.comps.get(cpd).keys()) {
                rv += '"' + e + '" : ' + this.comps.get(cpd).get(e) + '}, {';
            };
            rv = nwstrimright(rv, "[{, ");
            rv += '], '; 
        };
        
        rv = nwstrimright(rv, "[{, ");
        rv += '}';
        
        return rv;
    };
};

class ChemRxn {
    getErrorString() {
        return this.errstr;
    }

    constructor(instr) {
        instr = instr.toString().trim();
        this.errstr = "";
        if (instr.indexOf("=") < 0) {
            this.errstr = "No products given!!~+";
        } else if (instr.indexOf("=") < 2) {
            this.errstr = "No reactants given!! Cannot start input with '='~+";
        } else if (instr.indexOf("=", (instr.indexOf("=") + 1)) >= 0) {
            if (instr.indexOf("==") >= 0) {
                this.errstr = "ERROR! Consecutive ='s not allowed!! ";
                this.errstr += "They cause products to be skipped~+";
            } else {
                this.errstr = "WARNING! Too many ='s!!~+";            
            }
        };
        let eqsides = instr.split("=");
        this.rxnts = new ChemRxnSide(eqsides[0]);
        if (this.rxnts.getComps() != null) {
            this.prods = new ChemRxnSide(eqsides[1]);
            if (this.prods.getComps() == null) {
                this.errstr += "Products: " + this.prods.getErrorString();
            }
        } else {
            this.errstr += "Reactants:" + this.rxnts.getErrorString();
        }
    }
};