// NYI: 
// - package output into JSON
// ? probably more php-side - add CSS/HTML(JS?) output to prettify output

//var cxxomps = new Map();
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
        
        for (var cur_cap = "A".codePointAt(0); cur_cap <= "Z".codePointAt(0); cur_cap++) {
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
        console.log("instr", instr, "rv from find_capital_term:", instr.substr(0, nextcap));
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
            return "";
        };
        let val_0 = "0".codePointAt();
        let cur_digpos = 0;
        let cur_dig = 0;
        for (var i = 0; i < lblist.length; i++) {
            if ((rblist[i] - lblist[i]) < 3) {
                return "";
            };
            cur_digpos = rblist[i] + 1;
            cur_dig = instr[cur_digpos].codePointAt() - val_0;
            if (cur_dig < 0 || cur_dig > 9) {
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
    	console.log("init_comps - arg is", instr);
        let rawcomps = instr.split("+");
        console.log(rawcomps);
        console.log("======");
        let lbpos = -1;
        var ion_info, cur_cpd;
        console.log("at start of init_comps, this.comps is");
        console.log(this.comps);
        console.log("========");
        
        for (var rawcp_i in rawcomps) {
        	let rawcp = rawcomps[rawcp_i];
        	console.log("init_comps rawcp is", rawcp);
        	rawcp = nwstrimleft(rawcp, "0123456789").trim();
            if (rawcp[0].codePointAt() >= "a".codePointAt()) {
            	console.log("elem starts with lower case letter, returning null");
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
                console.log("raw pa_str is", pa_str);
                if (pa_str.length < 2) {
                	console.log("polyatomic ion search failed. returning null");
                    this.comps = null; return;
                };
                let pa_list = pa_str.split("|");
                for (var ion_i in pa_list) {
                    let cur_ion = pa_list[ion_i];
                    console.log("cur_ion", cur_ion);
                	ion_info = cur_ion.split("=");
                    this.comps.get(rawcp).set(ion_info[0], parseInt(ion_info[1]));
                };
            };
            for (var g of this.comps.get(rawcp).keys()){
        		console.log(rawcp, "key:-" + g + "- , val", cur_cpd.get(g));
        	}
       		console.log("comps", this.comps);
    		console.log("//////\\\\\\\"");
       	 };
    };

    count_elems(rawcp, rawcpstr, sub=1) {
    	let cur_elem = "";
        let atomcnt = [];
        let cur_cnt = 0;
    	
        console.log("count_elems, rawcp is", rawcp);
    	rawcpstr = nwstrimleft(rawcpstr, "~");
        let cur_term = this.find_capital_term(rawcpstr);
        console.log("cur_term is", cur_term);
        while (cur_term.length > 0) {
            cur_elem = cur_term;
            var re = /([1-9]\d*)/i;
            atomcnt = cur_term.match(re);
            console.log("raw match output", atomcnt);
            if (atomcnt != null) {
                cur_elem = nwstrimright(cur_term, "0123456789");
                atomcnt = [atomcnt[1]];
            } else {
                atomcnt = ["1"];
            };
            console.log("cur_elem is", cur_elem);
            console.log("atom count");
            console.log(atomcnt);
            if (!PT.has(cur_elem)) {
                this.comps = null; return false;
            };
            console.log("rawcpstr", rawcpstr);
            console.log("atom cnt", parseInt(atomcnt[0]));
            rawcpstr =  rawcpstr.substr(cur_term.length);
            let rcp = copyMap(this.comps.get(rawcp));
            if (rcp.get(cur_elem) === undefined) {
            	cur_cnt = 0;
            } else {
            	cur_cnt = rcp.get(cur_elem)
            }
            console.log("cur_cnt=-", cur_cnt, "-");
            this.comps.get(rawcp).set(cur_elem, cur_cnt + (parseInt(atomcnt[0])*sub));
            console.log("comps-get(rawcp)[", cur_elem, "]", this.comps.get(rawcp).get(cur_elem));
            cur_term = this.find_capital_term(rawcpstr);
        };
        return true;
    };

    get_comps_with_pluses(instr) {
    	let srchstr = "";
    	let raw_ion = "";
    	let cur_term = "";
    	let sub = 0;
    	
        this.init_comps(instr);
        if (this.comps == null) return;
        for (var rawcp of this.comps.keys()) {
        	console.log("get_comps_w+s - rawcp", rawcp);
        	srchstr = rawcp;
            let rcp = copyMap(this.comps.get(rawcp));
            console.log("comps.get(rawcp) in get_comps_w+s", this.comps.get(rawcp));
            console.log("rcp in get_comps_w+s", rcp);
            if (rcp.size > 1) {
                pa_ion: for (var ion_sym of rcp.keys()) {
                    if (ion_sym == "#") {
                        continue pa_ion;
                    };
                    sub = rcp.get(ion_sym);
                    console.log(rawcp, "sym", ion_sym, "sub", sub);
                    raw_ion = "(" + ion_sym.substr(1) + ")" + sub;
                    //find elems in ion, and counts. Multiply counts by subscr
                    if (this.count_elems(rawcp, ion_sym, sub) == false) {
                    	console.log("1st count_elems call in get_comps_w+s failed");
                        this.comps = null; return;
                    };
                    console.log(rcp);
                    console.log("vvvvvvvvv");
                    console.log(this.comps.get("Al2(SO4)3"));
                    console.log("!!!!!!!!!!!!");
                    console.log(this.comps);
                    console.log("^^^^^^^^^");
                    // remove ion and sub from srchstr
                    srchstr = srchstr.replace(raw_ion, "");
                    // remove ion entry from map
                    rcp.delete(ion_sym);
                    this.comps.get(rawcp).delete(ion_sym);
                };
            };
            //find remaining elems and their counts, if any
            if (this.count_elems(rawcp, srchstr) == false) {
            	console.log("2nd count_elems call in get_comps_w+s failed");
                this.comps = null; return;
            };
            cur_term = this.find_capital_term(srchstr);
        };
        // sort element entries in each compound
        console.log("compound list is:");
        console.log(this.comps.keys());
        console.log("========");
        if (this.comps.size > 0) {
            console.log("trying to sort...");
            let tmparr = [];
            for (var cp of this.comps.keys()) {
                // cannot sort on this.comps because maps are not sortable.
                // Copy to array, sort that, then pave over this.comps 
            	// entries instead.
            	tmparr = [];
                for (var e of this.comps.get(cp).keys()) {
            		let v = this.comps.get(cp).get(e);
                //	console.log(e, v);
                	tmparr.push([e, v]);
                	//console.log(tmparr.length);
                	//console.log(tmparr[tmparr.length - 1].length);
                }
                //console.log(cp,":");
                //console.log("raw tmparray");
                //console.log(tmparr);
                //console.log("%%%%%%%%%%%%%%%%%%");
                //console.log("");
                tmparr.sort(function(a,b) {
                	if (a[0] < b[0]) return -1;
                	if (a[0] > b[0]) return 1;
                	return 0;
                });
                //console.log("sorted tmparray");
                //console.log(tmparr);
                //console.log("%%%%%%%%%%%%%%%%%%");
                //console.log("");
                this.comps.get(cp).clear();
                //console.log("should be blank", this.comps.get(cp));
                for (var i in tmparr) {
                	this.comps.get(cp).set(tmparr[i][0], tmparr[i][1]);
                };
                //console.log("sorted??", this.comps.get(cp));
            };
            //console.log("(hopefully) sorted comps:", this.comps);
        } else {
        	console.log("no element entries to sort!!");
            this.comps = null;
        };
        console.log("sorted comps", this.comps);
    };

    getComps() {
    	return this.comps;
    }
    
    // Al + U + ..... has weird stuff going on with elem counts!
    // Al + U + ..... also does not sort elements
    // K2MNO4 + ... is a simpler case that shows most of these symptoms
    constructor(instr){
    	//set trim functions;
    	nwstrim = nonWSTrim;
    	nwstrimleft = nonWSTrimLeft;
    	nwstrimright = nonWSTrimRight;
    	
    	this.comps = new Map();
    	
    	this.get_comps_with_pluses(instr);
		if (this.comps == null) {
            console.log("The reaction {", instr, "} is invalid!!");
        };
    };  
};

class ChemRxn {
	constructor(instr) {
		instr = instr.toString();
    	console.log ("whole rxn is", instr);
    	if (instr.indexOf("=") < 0) {
    		console.log("No products given!!");
    	} else if (instr.indexOf("=", (instr.indexOf("=") + 1)) >= 0) {
    		console.log("WARNING! Too many ='s!!");
    	};
    	let eqsides = instr.split("=");
    	this.rxnts = new ChemRxnSide(eqsides[0]);
    	if (this.rxnts.getComps() != null) {
    		this.prods = new ChemRxnSide(eqsides[1]);
    	}
    	// check to see if rxn is valid, then package as JSON
	}
};