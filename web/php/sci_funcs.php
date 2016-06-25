<?php
include_once "vars.php";

// NYI: 
// - try to break up code even more. Trimming findElemToBalance() and 
// updateWorksheet() only reduced 80 lines of code
// - track down weird behaviour, more than likely a var getting trashed
//   like before. See testcases.txt on computer for details.
// - add CSS/HTML(JS?) output to prettify output

class EqSide {
    private $comps = NULL;
    private $cpds_by_elem = [];
    private $wksheet = NULL;
    
    // Assumed $instr already starts with a capital
    private function find_capital_term($instr) {
        if (strlen($instr) < 1) {
            return "";
        }
        // must check entire alphabet in case a polyatomic ion has
        // a letter to the right of the left letters comes before that
        // letter (e.g., OH fits because 'H' comes before 'O'
        $nextcap = 32767;
        for ($cur_cap = ord("A"); $cur_cap < ord("Z"); $cur_cap++) {
            $posrc = strpos($instr, $cur_cap, 1);
            if ($posrc !== false) {
                if ($posrc < $nextcap) {
                    $nextcap = $posrc;
                }
            }
        }            
        $termend = $nextcap;
        if ($nextcap < 1) {
            return $instr;
        }
        return trim(substr($instr, 0, $nextcap), "()");
    }

    private function find_all_pa_ions($instr, $firstlb) {
        $pa_rv = "";

        $lblist[0] = $firstlb;
        $cur_lbpos = $firstlb + 1;
        $nextlb = 1;
        while (($lbpos = strpos($instr, "(", $cur_lbpos)) !== false) {
            $lblist[$nextlb] = $lbpos;
            $cur_lbpos = $lbpos + 2;
            $nextlb++; 
        }
        if (($rbpos = strpos($instr, ")")) === false) {
            return "";
        }
        $rblist[0] = $rbpos;
        $cur_rbpos = $rbpos + 1;
        $nextrb = 1;
        while (($rbpos = strpos($instr, ")", $cur_rbpos)) !== false) {
            $rblist[$nextrb] = $rbpos;
            $cur_rbpos = $rbpos + 1;
            $nextrb++; 
        }
        if (count($lblist) != count($rblist)) {
            return "";
        }
        $val_0 = ord("0");
        for ($i = 0; $i < count($lblist); $i++) {
            if (($rblist[$i] - $lblist[$i]) < 3) {
                return "";
            }
            $cur_digpos = $rblist[$i] + 1;
            $cur_dig = ord($instr[$cur_digpos]) - $val_0;
            if ($cur_dig < 0 || $cur_dig > 9) {
                return "";
            }
            $instrlen = strlen($instr);
            $cur_digpos++;
            while ($cur_digpos < $instrlen && 
                    ($cur_dig < 0 || $cur_dig > 9)) {
                $cur_dig = ord($instr[$cur_digpos]) - $val_0;
                $cur_digpos++;
            }
            $subscriptstr = substr($instr, $rblist[$i] + 1,
                    $cur_digpos - $rblist[$i]); 
            $ion_str = "~";
            $ion_str .= substr($instr, $lblist[$i] + 1,
                    $rblist[$i] - $lblist[$i]);
            $pa_rv .= $ion_str."=".$subscriptstr."|";
        }
        return rtrim($pa_rv, "|");
    }

    // scan reaction string, "skim" terms. If OK, add keys to the
    // compounds array
    private function init_comps(&$comps, $instr) {
        $rawcomps = explode("+", $instr);
        foreach ($rawcomps as $rawcp) {
            $rawcp = trim(ltrim($rawcp, "0..9"));
            if (ctype_lower($rawcp[0])) {
                unset($comps); $comps = NULL; return;
            }
            // start off with 1 of each compound (i.e., coefficient=1)
            $comps[$rawcp]["#"] = 1;
            if (($lbpos = strpos($rawcp, "(")) !== false) {
                $pa_str = $this->find_all_pa_ions($rawcp, $lbpos);
                if (strlen($pa_str) < 2) {
                    unset($comps); $comps = NULL; return;
                }
                $pa_list = explode("|", $pa_str);
                foreach ($pa_list as $cur_ion) {
                    $ion_info = explode("=", $cur_ion);
                    $comps[$rawcp][$ion_info[0]] = (int)$ion_info[1];
                }
            }
        }
    }

    private function count_elems(&$comps, $rawcp, $rawcpstr, $sub=1) {
        $rawcpstr = ltrim($rawcpstr, "~");
        $cur_term = $this->find_capital_term($rawcpstr);
        while (strlen($cur_term) > 0) {
            $cur_elem = $cur_term;
            if (($atomcnt = strpbrk($cur_term, "123456789")) !== false) {
                $cur_elem = rtrim($cur_term, "0..9");
            } else {
                $atomcnt = "1";
            }
            if (!array_key_exists($cur_elem, $GLOBALS["pt"])) {
                unset($comps); return false;
            }
            $rawcpstr =  substr($rawcpstr, strlen($cur_term));
            $comps[$rawcp][$cur_elem] += ((int)$atomcnt*$sub);
            $cur_term = $this->find_capital_term($rawcpstr);
        }
        return true;
    }

    private function get_comps_with_pluses($instr) {
        $this->init_comps($this->comps, $instr);
        foreach (array_keys($this->comps) as $rawcp) {
            $srchstr = $rawcp;
            if (count($this->comps[$rawcp]) > 1) {
                foreach ($this->comps[$rawcp] as $ion_sym => $sub) {
                    if ($ion_sym == "#") {
                        continue;
                    }
                    $raw_ion = "(".substr($ion_sym, 1).")".$sub;
                    //find elems in ion, and counts. Multiply counts by subscr
                    if ($this->count_elems($this->comps, $rawcp,
                            $ion_sym, $sub) === false) {
                        unset($this->comps); $this->comps = NULL;
                        return;
                    }
                    // remove ion and sub from srchstr
                    $srchstr = str_replace($raw_ion, "", $srchstr);
                    unset($this->comps[$rawcp][$ion_sym]);
                }
            }
            //find remaining elems and their counts, if any
            if ($this->count_elems($this->comps, $rawcp,
                            $srchstr) === false) {
                unset($this->comps); $this->comps = NULL;
                return;
            }
            $cur_term = $this->find_capital_term($srchstr);
        }
        $complist = array_keys($this->comps); 
        if (count($complist) > 0 && strlen($complist[0]) > 0) {
            foreach ($complist as $cp) {
                // cannot sort on $comps because those are just copies of the
                // nested arrays. Access original elements by key instead.
                ksort($this->comps[$cp]);
            }
        } else {
            unset($this->comps); $this->comps = NULL;
        }
    }

    private function start_worksheet(){
        $coef = 1;
        foreach ($this->comps as $cp => $elems) {
            if ($this->wksheet == NULL) {
                foreach ($elems as $sym => $atm_cnt) {
                    if ($sym == "#") {
                        $coef = $atm_cnt;
                        continue;
                    }
                    $this->wksheet[$sym] = ($atm_cnt * $coef);
                }
            } else {
                foreach ($elems as $sym => $atm_cnt) {
                    if ($sym == "#") {
                        $coef = $atm_cnt;
                        continue;
                    }
                    $add_cnt = 0;
                    if (array_key_exists($sym, $this->wksheet)) {
                        $add_cnt = $this->wksheet[$sym];
                    }
                    $this->wksheet[$sym] = ($atm_cnt * $coef) + $add_cnt;
                }
            }
        }
    }

    private function setCompoundsByElem() {
        foreach ($this->comps as $cp => $elems) {
            foreach ($elems as $sym => $atm_cnt) {
                // set counts of how many compounds contain $sym
                if ($sym == "#") {
                    continue;
                }
                if (isset($this->cpds_by_elem[$sym])) {
                    $curr_cpd += 1;
                    $this->cpds_by_elem[$sym][$curr_cpd] = $cp;
                } else {
                    $curr_cpd=0;
                    $this->cpds_by_elem[$sym][$curr_cpd] = $cp;
                }
            }
        }
    }

    public function changeWorksheet(){
        unset($this->wksheet);
        $this->start_worksheet();
    }
                        
    public function changeCoefficient($elemorcpd, $coef, &$steps, 
            $is_diff=false) {
        if (isCompound($elemorcpd)) {
            $this->applyCoefficientChange([$elemorcpd], $coef, $steps, 
                    $is_diff);
        } else {
            $this->applyCoefficientChange($this->cpds_by_elem[$elemorcpd],
                    $coef, $steps, $is_diff);
        }
    }

    private function applyCoefficientChange($cpds, $coef, &$steps, 
            $is_diff) {
        $orig_coef = 0;
        foreach ($cpds as $i=>$compound) {
            if ($is_diff) {
                $orig_coef = $this->comps[$compound]["#"];
            }
            $this->comps[$compound]["#"] = $orig_coef + $coef;
            $cur_step = "-- new ".$compound." coefficient ";
            $cur_step .= "is ".($orig_coef + $coef);
            if (count($steps) > 0) {
                $steps[count($steps)] = $cur_step;
            }
        }
    }

    public function getWorksheet(){
        return $this->wksheet;
    }

    public function getCompoundList(){
        return $this->comps;
    }

    public function getCompoundsByElem(){
        return $this->cpds_by_elem;
    }

    function __construct($instr){
        $this->get_comps_with_pluses($instr);
        if ($this->comps != NULL ) {
            $this->setCompoundsByElem();
            $this->start_worksheet();
        }
    }
    
}

class Equation {
    private $MAX_STEPS = 200;
    private $MAX_COEF_LOOPS = 3;
    private $rxnts = NULL;
    private $prods = NULL;
    private $wksheet = NULL;
    private $cpds_by_elem = [];
    private $steps = [];
    private $last_bal_elem = "";
    
    function __construct($instr){
        if (strlen(trim($instr)) < 2) {
            return NULL;
        }
        $tmparr = explode("=", trim($instr));
        if (count($tmparr) < 2) return;
        $rawrxnts = $tmparr[0];
        $this->rxnts = new EqSide($rawrxnts);
        if ( $this->rxnts == NULL ) return;
        if (count($tmparr) > 1) {
            $rawprods = $tmparr[1];
            $this->prods = new EqSide($rawprods);
            if ( $this->prods == NULL ) return;
        }

        $rxwk = $this->rxnts->getWorksheet();
        $prwk = $this->prods->getWorksheet();
        
        if (count($rxwk) == count($prwk)) {
            reset($rxwk);
            reset($prwk);
            $elem_matches = true;
            $i = 0;
            $numrxnts = count($rxwk);
            $rxelems = array_keys($rxwk);
            while ($i < $numrxnts && $elem_matches ) {
                $elem_matches = array_key_exists($rxelems[$i], $prwk);
                $i++;
            }
            if ($elem_matches) {
                foreach ($rxwk as $elem => $cnt) {
                    $this->wksheet[$elem] = [$rxwk[$elem], $prwk[$elem]];
                }
            }
        }
                
        if ($this->wksheet == NULL) {
            $this->rxnts = NULL;
            $this->prods = NULL;
        } else {
            $rxcpds_by_elem = $this->rxnts->getCompoundsByElem();
            $prcpds_by_elem = $this->prods->getCompoundsByElem();
            foreach ($this->wksheet as $elem => $cpds) {
                $this->cpds_by_elem[$elem] =
                    [$rxcpds_by_elem[$elem], $prcpds_by_elem[$elem]]; 
            }
        }
    }
    
    public function getReactants() {
        if (isset($this->rxnts)) {
            if ($this->rxnts->getCompoundList() != NULL) {
                return $this->rxnts;
            }
        }
        // not a valid array
        return NULL;
    }

    public function getProducts() {
        if (isset($this->prods)) {
            if ($this->prods->getCompoundList() != NULL) {
                return $this->prods;
            }
        }
        // not a valid array
        return NULL;
    }

    public function getWorksheet() {
        return $this->wksheet;
    }

    private function isBalanced() {
        foreach($this->wksheet as $elem => $cnts) {
            if ($cnts[0] != $cnts[1]) {
                return false;
            }
        }
        // no inequalities found. Equation is balanced
        return true;
    }
    
    private function getOKElems(&$pe, $OH, $condition) {
        echo "args ", ($OH)?"OH":"regular", ", ", $condition, "<br>";
           foreach ($this->cpds_by_elem as $elem => $cpds) {
            echo "elem ", $elem, ", args ", ($OH)?"OH":"regular", ", ", $condition, "<br>";
            echo "cpds: "; var_dump($cpds); echo "<br>";
            if (!$OH) {
                if ($elem == "O" || $elem == "H") continue;
            } else {
                if ($elem != "O" && $elem != "H") continue;
            }
            if ($this->wksheet[$elem][0] == $this->wksheet[$elem][1]) {
                continue;
            }
            echo "didn't skip in getOKElems still<br>";
            $rxcnt = count($cpds[0]);
            $prcnt = count($cpds[1]);
            switch ($condition) {
                case CompoundRatios::CR1to1: {
                    echo "1:1<br>";
                    if ($rxcnt == 1 && $prcnt == 1) {
                        $pe[$elem] = $this->wksheet[$elem];
                    }
                    break;
                }
                case CompoundRatios::CR1toX: {
                    echo "1:X<br>";
                    if (($rxcnt == 1 && $prcnt > 1) ||
                            ($rxcnt > 1 && $prcnt == 1)) {
                        $pe[$elem] = $this->wksheet[$elem];
                    }
                    break;
                }
                case CompoundRatios::CRXtoY: {
                    echo "X:Y<br>";
                    if ($rxcnt > 1) {
                        $pe[$elem] = $this->wksheet[$elem];
                    }
                    break;
                }
                case CompoundRatios::CRunk:
                default: {
                    echo "default<br>";
                    $pe[$elem] = $this->wksheet[$elem];
                    break;
                }
            }
        }
    }
        
    private function findElemToBalance() {
        $rtval = ["<eqn side>:<compound>", "<element>"];
        $rxntlist = $this->rxnts->getCompoundList();
        $prodlist = $this->prods->getCompoundList();
        $rxcounts = [];
        $prcounts = [];

        $possible_elems = [];
  
        // look for one compound having element:more than one compound
        $this->getOKElems($possible_elems, false, CompoundRatios::CR1toX);
        echo "1st poss elem: "; var_dump($possible_elems); echo "<br>";
        // if needed, look for one compound element on each side
        if (count($possible_elems) < 1) {
            $this->getOKElems($possible_elems, false, CompoundRatios::CR1to1);
            echo "2nd poss elem: "; var_dump($possible_elems); echo "<br>";
        }
        // if needed, look for few compounds having element:many compounds
        if (count($possible_elems) < 1) {
            $this->getOKElems($possible_elems, false, CompoundRatios::CRXtoY);
            echo "3rd poss elem: "; var_dump($possible_elems); echo "<br>";
        }
        // now, only equal number (number > 1) of compounds with elements
        // on each side are left. Check for non-O, non-H compounds
        if (count($possible_elems) < 1) {
            $this->getOKElems($possible_elems, false, CompoundRatios::CRunk);
            echo "4th poss elem: "; var_dump($possible_elems); echo "<br>";
        }
        if (count($possible_elems) > 0) {
            $cur_step = "Consider compounds with element(s) ";
            $cur_step_elems = " ";    
            foreach ($possible_elems as $elem => $cpds) {
                $cur_step_elems .= $elem.", ";
            }
            $cur_step_elems = substr($cur_step_elems, 0,
                    strlen($cur_step_elems) - 2)." ";
            $cur_step .= $cur_step_elems."for next balancing step.";
            $this->steps[count($this->steps)] = $cur_step;
        }
        if (count($possible_elems) < 1) {
            // only O and/or H left. Check for O first. If already balanced
            // or not there return H. If both exist, check in more detail
            $possible_elem_sym = "O";
            if (!array_key_exists("O", $this->cpds_by_elem) || 
                        !array_key_exists("H", $this->cpds_by_elem)) {
                if (!array_key_exists("O", $this->cpds_by_elem)) {
                    $possible_elem_sym = "H";
                } else if ($this->wksheet["O"][0] == $this->wksheet["O"][1]) {
                    $possible_elem_sym = "H";
                }    
                $possible_elems[$possible_elem_sym] = $this->wksheet[$possible_elem_sym];
            } else {
                // for O/H look for one compound for element on each side first
                $this->getOKElems($possible_elems, true, 
                        CompoundRatios::CR1to1);
                echo "OH 1st poss elem: "; var_dump($possible_elems); echo "<br>";
                // if needed, look for one compound having element:more
                // than one compound
                if (count($possible_elems) < 1) {
                    $this->getOKElems($possible_elems, true, 
                            CompoundRatios::CR1toX);
                    echo "OH 2nd poss elem: "; var_dump($possible_elems); echo "<br>";
                }
                // if needed, look for few compounds having element:many 
                // compounds
                if (count($possible_elems) < 1) {
                    $this->getOKElems($possible_elems, true, 
                            CompoundRatios::CRXtoY);
                    echo "OH 3rd poss elem: "; var_dump($possible_elems); echo "<br>";
                }
                // now, only equal number (number > 1) of compounds with elements
                // on each side are left. Check for non-O, non-H compounds
                if (count($possible_elems) < 1) {
                    $this->getOKElems($possible_elems, true, 
                            CompoundRatios::CRunk);
                    echo "OH 4th poss elem: "; var_dump($possible_elems); echo "<br>";
                }
            }
            $cur_step = "Other elements are balanced. Consider compounds ";
            $cur_step .= "with element ".array_keys($possible_elems)[0].".";
            $this->steps[count($this->steps)] = $cur_step;
        }
            
        $rt_elem = "";
            
        foreach ($possible_elems as $elem => $cnts) {
            if ($cnts[0] != $cnts[1]) {
                $cntdiff = abs($cnts[0] - $cnts[1]);
                if ($cntdiff % 2 == 1 && $cnts[0] > 1 && $cnts[1] > 1) {
                    // if different counts are odd and even
                    $rt_elem = $elem;
                }
                if (strlen($rt_elem) < 1 && $cnts[0] > 1 && $cnts[1] > 1) {
                    // next case: find counts that are both > 1
                    $rt_elem = $elem;
                }
                if (strlen($rt_elem) < 1) {
                    // last case: one count is one, other is not
                    $rt_elem = $elem;
                }
            }
        }
        return $rt_elem;
    }

    private function applyWorksheetChanges($eqside){
        if ($eqside == "reactant") {
            $this->rxnts->changeWorksheet();
        } else {
            $this->prods->changeWorksheet();
        }
        $rxwk = $this->rxnts->getWorksheet();
        $prwk = $this->prods->getWorksheet();
        foreach ($rxwk as $elem => $cnt) {
            $this->wksheet[$elem] = [$rxwk[$elem], $prwk[$elem]];
        }
        //$tmpstep = "Update ".$eqside." atom counts in worksheet";
        //$this->steps[count($this->steps)] = $tmpstep;
    }

    private function findCompoundsOnlyWithElem($cd, $elem) {
        $rv = [];
        $cur_step = "Find difference in product count and reaction count ";
        $cur_step .= "of ".$elem.". It is ".$cd;
        $this->steps[count($this->steps)] = $cur_step;
        foreach ($this->cpds_by_elem[$elem] as $side=>$cnames) {
            $rv[$side] = [];
            $curr_side = $this->rxnts->getCompoundList();
            if ($side == 1) {
                $curr_side = $this->prods->getCompoundList();
            }
            foreach ($cnames as $i=>$cpdname) {
                $cpd = $curr_side[$cpdname];
                $hasOnlyElem = true;
                foreach ($cpd as $e=>$cnt) {
                    if ($e == "#" || $e == "O" || $e=="H" || $e == $elem) {
                        continue;
                    }
                    if ($this->wksheet[$e][0] == $this->wksheet[$e][1]) {
                        $hasOnlyElem = false;
                        break;
                    }
                }
                if ($hasOnlyElem) {
                    $rv[$side][$cpdname] = $cpd;
                }
            }
        }
        return $rv;
    }

    private function compareBalancingofWorksheets(&$wks1, &$wks2, $elem) {
        $right_wks_better = false;;

        // check to be sure that none of the wks have imbalance of elem
        if ($wks1[$elem][0] != $wks1[$elem][1]) {
            $right_wks_better = true;
            return $right_wks_better;
        }
        if ($wks2[$elem][0] != $wks2[$elem][1]) {
            // left side is already "better". Has balanced elem counts
            return $right_wks_better;
        }
        
        $lbal_cnt = 0;
        $rbal_cnt = 0;
        $unbalanced = [];
        foreach ($wks1 as $e=>$ecnts) {
            if ($ecnts[0] == $ecnts[1]) {
                $lbal_cnt++;
            } else {
                $unbalanced[$e] = [0, 0];
            }
            if ($wks2[$e][0] == $wks2[$e][1]) {
                $rbal_cnt++;
            }
        }
        if ($lbal_cnt != $rbal_cnt) {
            unset($unbalanced);
            $right_wks_better = $rbal_cnt > $lbal_cnt;
            return $right_wks_better;
        }
        
        // each worksheet has same number of balanced elements. Check
        // degree of imbalance in unbalanced elements.
        
        $ldiff_part_sum = 0;
        $rdiff_part_sum = 0;
        $ldiff_sum = 0;
        $rdiff_sum = 0;
        foreach ($unbalanced as $e=>$ucnts) {
            $unbalanced[$e][0] = abs($wks1[$e][0] - $wks1[$e][1]); 
            $unbalanced[$e][1] = abs($wks2[$e][0] - $wks2[$e][1]); 
            if ($e != "O" && $e != "H") {
                $ldiff_part_sum += $unbalanced[$e][0];
            }
            $ldiff_sum += $unbalanced[$e][0];
            if ($e != "O" && $e != "H") {
                $rdiff_part_sum += $unbalanced[$e][1];
            }
            $rdiff_sum += $unbalanced[$e][1];
        }
        
        // check non-O/H elements sums first
        if ($ldiff_part_sum != $rdiff_part_sum) {
            unset($unbalanced);
            $right_wks_better = $rdiff_part_sum < $ldiff_part_sum;
            return $right_wks_better;
        }

        // check all elements sums
        if ($ldiff_sum != $rdiff_sum) {
            unset($balanced);
            $right_wks_better = $rdiff_sum < $ldiff_sum;
            return $right_wks_better;
        }
        
        // either worksheets are identical, or there is an indiscernible
        // difference between them
        return $right_wks_better;
    }

    private function changeCoefs($ps, $cpd, $codiff, &$steps, $isdiff=false) {
        $cpdarr = [];
        if (!is_array($cpd)) {
            $cpdarr[$cpd] = $codiff;
        } else {
            $cpdarr = $cpd;
        }
        foreach ( $cpdarr as $cpd => $coef ) {
            if ($ps == "reactant") {
                $this->rxnts->changeCoefficient ( $cpd, $coef, $steps, $isdiff );
            } else {
                $this->prods->changeCoefficient ( $cpd, $coef, $steps, $isdiff );
            }
        }
        unset($cpdarr);
    }
    
    private function findCompoundsToTry(&$cpds, $elem, $cd, $pside) {
        $rawcpds = $this->rxnts->getCompoundList();
        if ($pside == "product") {
            $rawcpds = $this->prods->getCompoundList();
        }
        foreach ($rawcpds as $cur_cpd=>$elems) {
            if ($elems[$elem] > 0 && $elems[$elem] <= $cd) {
                $cpds[$cur_cpd] = $elems;
            }
        }
    }
 
    private function updateWorksheet($elem, $first_balance=false){
        $empty = [];
        // find compound(s) for given element to balance
        $rxcount = $this->wksheet[$elem][0];
        $prcount = $this->wksheet[$elem][1];
        if ($first_balance) {
            $lcm = lcm($rxcount, $prcount);
            $rxcoef = $lcm / $rxcount;
            $prcoef = $lcm / $prcount;
            if ($rxcoef > 1) {
                $cur_step = "Try to balance ".$elem."'s by multiplying ";
                $cur_step .= "reactants' coefficients by ".$rxcoef;
                $this->steps[count($this->steps)] = $cur_step;
                $this->rxnts->changeCoefficient($elem, $rxcoef, $this->steps);
                $this->applyWorksheetChanges("reactant");
            }
            if ($prcoef > 1) {
                $cur_step = "Try to balance ".$elem."'s by multiplying ";
                $cur_step .= "products' coefficients by ".$prcoef;
                $this->steps[count($this->steps)] = $cur_step;
                $this->prods->changeCoefficient($elem, $prcoef, $this->steps);
                $this->applyWorksheetChanges("product");
            }
            return true;
        }

        $count_diff = abs($rxcount - $prcount);
        $only_elem_cpds =
            $this->findCompoundsOnlyWithElem($count_diff, $elem);
        $prefside = $only_elem_cpds[1];
        $ps_str = "product";
        if ($prcount > $rxcount) {
            $prefside = $only_elem_cpds[0];
            $ps_str = "reactant";
        }
        $cur_step = "Inspect ".$ps_str."s to see if compounds with ";
        $cur_step .= $elem." can be adjusted to balance ".$elem;        
        $this->steps[count($this->steps)] = $cur_step;
        $cpds_w_factor_cnts = [];
        $elem_cnt = 0;
        foreach ($prefside as $cpd=>$elems) {
            $cur_count = $elems[$elem];
            $elem_cnt += $cur_count;
            if ($count_diff % $cur_count == 0) {
                $cpds_w_factor_cnts[$cpd] = $elems;
            }
        }
        $cur_step = "Check if the total ".$elem." count on ".$ps_str." side ";
        $cur_step .= "is a >1 factor of ".$count_diff.", the difference in ";
        $cur_step .= $elem;
        $this->steps[count($this->steps)] = $cur_step;
        if ($elem_cnt > 0 && $count_diff % $elem_cnt == 0) {
            $coef_diff = $count_diff / $elem_cnt;
            $cur_step = $count_diff." is exactly ".$coef_diff." times larger ";
            $cur_step .= "than the ".$ps_str." ".$elem." count, ".$elem_cnt;
            $this->steps[count($this->steps)] = $cur_step;
            $cur_step = "Increase coefficients by ".$coef_diff;
            $this->steps[count($this->steps)] = $cur_step;
            
            foreach ($prefside as $cpd=>$elems) {
                $this->changeCoefs($ps_str, $cpd, $coef_diff, $this->steps, 
                        true);
            }
            $this->applyWorksheetChanges($ps_str);
            return true;
        }
        $cur_step = "Total ".$elem." count is not a factor of difference.";
        $this->steps[count($this->steps)] = $cur_step;
        if (count($cpds_w_factor_cnts) != 1) {
            $cur_step = "Balance using one compound with a ".$elem." count ";
            $cur_step .= "that is a factor of difference";
            $cpds_to_try = $cpds_w_factor_cnts;
            if (count($cpds_to_try) < 1) {
                $this->findCompoundsToTry($cpds_to_try, $elem, $count_diff,
                        $ps_str);  
            }
            // initialize defender-challenger worksheets with largest
            // imbalance possible
            $wks1 = $this->wksheet;
            foreach ($wks1 as $e=>$cnts) {
                $wks1[$e] = [32767, 0];
            }
            $wks2 = $wks1;
            $cpds_to_change = [];
            foreach ($cpds_to_try as $cpd=>$elems) {
                $orig_coef = $elems["#"];
                $factor_coef = $count_diff + $elems[$elem];
                if ($count_diff % $elems[$elem] == 0) {
                    $factor_coef = $count_diff / $elems[$elem];
                }
                $this->changeCoefs($ps_str, $cpd, $factor_coef, $empty); 
                $this->applyWorksheetChanges($ps_str);
                $wks2 = $this->wksheet;
                //$this->dumpWS($wks1, "Worksheet 1");
                //$this->dumpWS($wks2, "Worksheet 2");
                $foundNewBalanced = 
                        $this->compareBalancingofWorksheets($wks1, $wks2, 
                            $elem);
                if ($foundNewBalanced) {
                    $wks1 = $wks2;
                    $cpds_to_change[$cpd] = $factor_coef;
                }
                $this->changeCoefs($ps_str, $cpd, $orig_coef, $empty); 
                $this->applyWorksheetChanges($ps_str);
            }
            // check possible sums of compounds, but only for case where
            // number of compounds is 2. Higher numbers too complex to check
            if (count($cpds_to_try) == 2) {
                foreach ($cpds_to_try as $cpd=>$elems) {
                    $orig_coef = $elems["#"];
                    $ac = $elems[$elem];
                    $cpd_atom_cnts[] = [$cpd, $ac, $orig_coef];
                }
                $ac1 = &$cpd_atom_cnts[0][1];
                $cpd1 = &$cpd_atom_cnts[0][0];
                $ac2 = &$cpd_atom_cnts[1][1];
                $cpd2 = &$cpd_atom_cnts[1][0];
                $orig_coef1 = &$cpd_atom_cnts[0][2];
                $orig_coef2 = &$cpd_atom_cnts[1][2];
                $coef_2 = 1;
                $c2_limit = $count_diff / $ac2;
                $coef_1 = ($count_diff - $ac2 * $coef_2)/$ac1;
                while ($coef_2 < $c2_limit) {
                    if ((int)floor($coef_1) == (int)$coef_1) {
                        $coefs_to_try[] = [(int)$coef_1, $coef_2];
                    }
                    $coef_2++;
                    $coef_1 = ($count_diff - $ac2 * $coef_2)/$ac1;
                }
                foreach ($coefs_to_try as $i=>$coefs) {
                    $this->changeCoefs($ps_str, $cpd1, $coefs[0], $empty, 
                        true);
                    $this->changeCoefs($ps_str, $cpd2, $coefs[1], $empty, 
                        true);
                    $this->applyWorksheetChanges($ps_str);
                    $wks2 = $this->wksheet;
                    //$this->dumpWS($wks1, "Worksheet 1");
                    //$this->dumpWS($wks2, "Worksheet 2");
                    $foundNewBalanced = 
                            $this->compareBalancingofWorksheets($wks1, $wks2, 
                                $elem);
                    if ($foundNewBalanced) {
                        $wks1 = $wks2;
                        $cur_step = "Balance by changing coefficients of ";
                        $cur_step .= $elem." compounds such that their ";
                        $cur_step .= "atom count sum is a factor of ";
                        $cur_step .= "the difference";
                        unset($cpds_to_change);
                        $cpds_to_change[$cpd1] = $coefs[0];
                        $cpds_to_change[$cpd2] = $coefs[1];
                    }
                    $this->changeCoefs($ps_str, $cpd1, $orig_coef1, $empty);
                    $this->changeCoefs($ps_str, $cpd2, $orig_coef2, $empty);
                    $this->applyWorksheetChanges($ps_str);
                }
            }
            $is_diff = count($cpds_to_change) > 1;
            $this->changeCoefs($ps_str, $cpds_to_change, 0, $this->steps, 
                    $is_diff);
            $this->applyWorksheetChanges($ps_str);
            //$this->dumpWS($this->wksheet, "After wks chosen");
            $this->steps[count($this->steps)] = $cur_step;
            return true;
        }
        // if there is only one compound that has elem in it
        $ps_index = 0;
        if ($ps_str == "product") {
            $ps_index = 1;
        }
        if (count($this->cpds_by_elem[$elem][$ps_index]) == 1) {
            $cur_cpd = $this->cpds_by_elem[$elem][$ps_index][0];
            $lcm = lcm($rxcount, $prcount);
            $rxcpds = $this->rxnts->getCompoundList();
            $prcpds = $this->prods->getCompoundList();
            if ($ps_str == "reactant") {
                $rxcoef = $lcm / $rxcpds[$cur_cpd][$elem];
                $cur_step = "Try to balance ".$elem."'s by multiplying ";
                $cur_step .= "reactants' coefficients by ".$rxcoef;
                $this->steps[count($this->steps)] = $cur_step;
                $this->rxnts->changeCoefficient($elem, $rxcoef, $this->steps);
                $this->applyWorksheetChanges("reactant");
            }
            if ($ps_str == "product") {
                $prcoef = $lcm / $prcpds[$cur_cpd][$elem];
                $cur_step = "Try to balance ".$elem."'s by multiplying ";
                $cur_step .= "products' coefficients by ".$prcoef;
                $this->steps[count($this->steps)] = $cur_step;
                $this->prods->changeCoefficient($elem, $prcoef, $this->steps);
                $this->applyWorksheetChanges("product");
            }
            return true;
        }
            
        $cur_step .= "Use the algebraic method or half-cell reactions ";
        $cur_step .= "instead";
        $this->steps[count($this->steps)] = $cur_step;
        return false;
    }

    private function reduceCoefficients() {
        $cf = 1;
        $low_coefs = [];
        $factor_cpds = [];
        
        function checkEqSide($eqside, &$low_coefs, &$factor_cpds, $cf) {
            $commonf = $cf;
            foreach ($eqside as $cpd => $elems) {
                $coef_count = count($low_coefs);
                if ($coef_count < 2) {
                    $low_coefs[$cpd] = $elems["#"];
                    $factor_cpds[] = $cpd;
                    $coef_count = count($low_coefs);
                    if ($coef_count == 2) {
                        $commonf = gcf($low_coefs[$factor_cpds[0]], 
                                $low_coefs[$factor_cpds[1]]);
                        if ($commonf < 2) return 1;
                        $low_coefs[$factor_cpds[0]] = 
                                $low_coefs[$factor_cpds[0]] / $commonf;
                        $low_coefs[$factor_cpds[1]] = 
                                $low_coefs[$factor_cpds[1]] / $commonf;
                    }
                } else {
                    if ($elems["#"] % $commonf > 0) return 1;
                    $low_coefs[$cpd] = $elems["#"] / $commonf;
                }
            }
            return $commonf;
        }

        $cf = checkEqSide($this->rxnts->getCompoundList(), $low_coefs, $factor_cpds, $cf);
        if ($cf < 2) return 1;
        $cf = checkEqSide($this->prods->getCompoundList(), $low_coefs, $factor_cpds, $cf);
        if ($cf < 2) return 1;
        
        $empty = [];
        foreach ($this->rxnts->getCompoundList() as $cpd=>$elems) {
            $this->rxnts->changeCoefficient($cpd, $low_coefs[$cpd], $empty);
        }
        foreach ($this->prods->getCompoundList() as $cpd=>$elems) {
            $this->prods->changeCoefficient($cpd, $low_coefs[$cpd], $empty);
        }
        $this->applyWorksheetChanges("reactant");
        $this->applyWorksheetChanges("product");
        return $cf;
    }

    private function formatCompound($cpd) {
        $val_0 = ord("0");
        $substart = "<sub>";
        $subend = "</sub>";
        $printsub = false;
        $rv = "";
        
        for ($i=0; $i < strlen($cpd); $i++) {
            $cur_dig = ord($cpd[$i]) - $val_0;
            if ($printsub) {
                if ($cur_dig < 0 || $cur_dig > 9) {
                    $rv .= $subend;
                    $printsub = false;
                }
            } else {
                if ($cur_dig >= 0 && $cur_dig <= 9) {
                    $rv .= $substart;
                    $printsub = true;
                }
            }
            $rv .= $cpd[$i];
        }
        if ($printsub) {
            $rv .= $subend;
        }
        return $rv;
    }
    
    public function balance() {
        if ($this->isBalanced()) {
            return;
        }
        $cur_elem = $this->findElemToBalance();
        $balanceable = count($this->steps) < $this->MAX_STEPS &&
                $this->updateWorksheet($cur_elem, true);
        while ($balanceable && !$this->isBalanced()) {
            $cur_elem = $this->findElemToBalance();
            $balanceable = count($this->steps) < $this->MAX_STEPS &&
                    $this->updateWorksheet($cur_elem);
        }
        if (!$balanceable) {
            if (substr($this->steps[count($this->steps) - 1], 0, 4) == "HARD") {
                $cur_step = "** HARD OR IMPOSSIBLE TO BALANCE!";
            } else {
                $cur_step = "** # of steps exceeds max steps allowed (";
                $cur_step .= $this->MAX_STEPS.")";
            } 
            array_unshift($this->steps, $cur_step);
        } else {
            $reduction_factor = $this->reduceCoefficients();
            if ($reduction_factor > 1) {
                $cur_step = "Coefficients reduced by common factor of ";
                $cur_step .= $reduction_factor.". This means that a better ";
                $cur_step .= "sum of coefficients could have been used ";
                $cur_step .= "during the balancing process to get the ";
                $cur_step .= "lowest possible integer coefficients.";
                $this->steps[count($this->steps)] = $cur_step;
            }
        }
    }
    
    public function getSteps() {
        return $this->steps;
    }

    public function showReaction($header) {
        echo "\n", $header, ":<br>\n";
        $outstr = "<font size=5>";
        foreach ($this->rxnts->getCompoundList() as $cpd=>$elems) {
            $cpdstr = "";
            if ($elems["#"] > 1) {
                $cpdstr .= $elems["#"];
            }
            $cpdstr .= $this->formatCompound($cpd)." + ";
            $outstr .= $cpdstr;
        }
        $outstr = rtrim($outstr, " +");
        $outstr .= " ==> ";
        foreach ($this->prods->getCompoundList() as $cpd=>$elems) {
            $cpdstr = "";
            if ($elems["#"] > 1) {
                $cpdstr .= $elems["#"];
            }
            $cpdstr .= $this->formatCompound($cpd)." + ";
            $outstr .= $cpdstr;
        }
        $outstr = rtrim($outstr, " +");
        $outstr .= "</font>\n";
        
        echo $outstr; 
    }

    public function dumpWS(&$ws, $header) {
        echo "<pre>", $header, "\n";
        echo "Element,R,P\n";    
        foreach ($ws as $elem=>$cnts) {
            echo $elem, ", ", $cnts[0], ", ", $cnts[1], "\n";
        }
        echo "</pre>";
    }

    public function debug_du_jour() {
        echo "compounds sorted by elements:<br>"; var_dump($this->cpds_by_elem); echo "<hr>";
        foreach ($this->wksheet as $e=>$cnts) {
            echo "findOnly for '", $e, "' returns:<br>";
            var_dump($this->findCompoundsOnlyWithElem(-1, $e)); echo "<br><hr>";
        }
    }
}
