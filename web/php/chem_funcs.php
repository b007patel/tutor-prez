<?php
include "tp_vars.php";

// NYI: 
// - try to clean up code
// --- when possible make any duplicated code into a shared function
//   like before. See testcases.txt on computer for details.
// use localized strings?
// - add CSS/HTML(JS?) output to prettify output

class EqSide {
    private $comps = NULL;
    private $cpds_by_elem = [];
    private $wksheet = NULL;
    
    // check string for digits (i.e., subscripts). If none found, confirm
    // that remaining string is not an element
    public static function isCompound($instr) {
        $i = -1;
        $len = strlen($instr);
        $zero = ord("0");
        $nine = ord("9");
        $is_an_elem = true;
    
        while ($i < $len && $is_an_elem) {
            $i++;
            $curr_code = ord($instr[$i]);
            $is_an_elem = ($curr_code < $zero || $curr_code > $nine);
        }
        if ($is_an_elem) {
            // Ensure element is a legit symbol: A or Ab.
            // Symbols such as c or cd or cD unacceptable
            $is_an_elem = $len <= 2;
            if ($is_an_elem) $is_an_elem = $instr[0] <= "Z";
            if ($is_an_elem && $len > 1) $is_an_elem = $instr[1] >= "a";
        }
        return !$is_an_elem;
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
                        
    public function changeCoefficient($elemorcpd, $coef, &$fulleq, 
            $is_diff=false) {
        if (EqSide::isCompound($elemorcpd)) {
            $this->applyCoefficientChange([$elemorcpd], $coef, $fulleq, 
                    $is_diff);
        } else {
            $this->applyCoefficientChange($this->cpds_by_elem[$elemorcpd],
                    $coef, $fulleq, $is_diff);
        }
    }

    private function applyCoefficientChange($cpds, $coef, &$fulleq, 
            $is_diff) {
        $orig_coef = 0;
        foreach ($cpds as $i=>$compound) {
            if ($is_diff) {
                $orig_coef = $this->comps[$compound]["#"];
            }
            $this->comps[$compound]["#"] = $orig_coef + $coef;
            $cur_step = "new ".$compound." coefficient ";
            $cur_step .= "is ".($orig_coef + $coef);
            if ($fulleq !=  NULL) {
                $fulleq->incIndent();
                $fulleq->logStep($cur_step);
                $fulleq->decIndent();
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

    function __construct($rawside){
        foreach ($rawside as $cpd=>$objs) {
            $this->comps[$cpd] = [];
            foreach ($objs as $i=>$eobj) {
                foreach ($eobj as $elem=>$cnt) {
                    $this->comps[$cpd][$elem] = $cnt;
                }
            }
        }
        $this->setCompoundsByElem();
        $this->start_worksheet();
    }    
}

class Equation {
    private $MAX_STEPS = 200;
    private $MAX_COEF_LOOPS = 200;
    private $MAX_COEF = 50000;
    private $rxnts = NULL;
    private $prods = NULL;
    private $wksheet = NULL;
    private $indent = 0;
    private $cpds_by_elem = [];
    private $steps = [];
    private $errors = [];
    private $raw_json = "";
    private static $dbgfile = NULL;
    private $formattedRxn = "";
    private $last_bal_elem = "";
    
    function __construct($instr){
        Equation::openDbgFile($_SERVER["DOCUMENT_ROOT"]."/php/dbg_out.txt");
        $this->raw_json = $instr;
        $pos_of_bad = strpos($instr, "--BAD--");
        $warning_given = strpos($instr, "WARNING") > 0; 
        if ($pos_of_bad > 0 || $warning_given) {
            $this->setErrorsFromJSON($instr, $pos_of_bad);
        }
        $eqjson = json_decode($instr);
        $rawrxnts = $eqjson->rxnts;
        if ($rawrxnts == NULL || $rawrxnts === undefined) {
            $this->setErrorsFromJSON($instr, $pos_of_bad);
            return;
        }
        $this->rxnts = new EqSide($rawrxnts);
        if ( $this->rxnts->getCompoundList() == NULL ) return;
        $rawprods = $eqjson->prods;
        if ($rawprods == NULL || $rawprods === undefined) return;
        $this->prods = new EqSide($rawprods);
        if ( $this->prods->getCompoundList() == NULL ) return;
        
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
            } else {
                $cur_err = "Reactant element ".$rxelems[$i - 1]." is ";
                $cur_err .= "not in any product";
                $this->errors[count($this->errors)] = $cur_err;
            }
        } else {
            $cur_err = "There are ".count($rxwk)." reactant elements, ";
            $cur_err .= "yet there are ".count($prwk)." product elements. ";
            $cur_err .= "These counts should be equal";
            $this->errors[count($this->errors)] = $cur_err;
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
    
    private static function getHTMLList(&$strs) {
        $cur_lev = -1;
        $fmtted_strs = [];
        for ($i=0; $i < count($strs); $i++) {
            $rawstr = $strs[$i];
            $step_lev = 0;
            $listchg = "";
            while ($rawstr[$step_lev] == "-") {
                $step_lev++;
            }
            $rawstr = trim($rawstr, "-");
            $lev_diff = $step_lev - $cur_lev;
            $cl_arg = ($cur_lev >= 0)?$cur_lev:0;
            if ($lev_diff == 1) {
                $listchg = str_repeat("\t", $cl_arg)."<ul>\n";
                $cur_lev = $step_lev;
            } else if ($lev_diff == -1) {
                $listchg = str_repeat("\t", $cl_arg)."</ul>\n";
                $cur_lev = $step_lev;
            } else if ($lev_diff != 0) {
                Equation::dbgOut(
                        "Indent diff should only be +/-1, not ".$lev_diff);
            }
            $curstr = $listchg.str_repeat("\t", $step_lev)."<li>";
            $curstr .= $rawstr."</li>";
            $fmtted_strs[$i] = $curstr;
        }
        return $fmtted_strs;
    }
    
    private function setErrorsFromJSON($instr, $bpos) {
        $this->formattedRxn = ltrim(substr($instr, $bpos));
        $this->formattedRxn = rtrim($this->formattedRxn, "}]");
        $rawerrs = ltrim(split("\"errstr\"", $instr)[1], ":\"'");
        $rawerrs = substr($rawerrs, 0, strpos($rawerrs, '","') - 1);
        $this->errors = split("~+", $rawerrs);
        foreach ($this->errors as $i=>$err) {
            $this->errors[$i] = trim($err, "~+ ")."\n";
            if (strlen($err) < 1) array_splice($this->errors, $i);
        }
    }
    
    public function getErrors($ret_type="html") {
        if (strtolower($ret_type) != "html") {
            return $this->errors;
        }
        return Equation::getHTMLList($this->errors);
    }
    
    public function getSteps($ret_type="html") {
        if (strtolower($ret_type) != "html") {
            return $this->steps;
        }
        return Equation::getHTMLList($this->steps);
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
        $this->indent = 0;
        return true;
    }
    
    public function incIndent() {
        $this->indent++;    
    }
    
    public function decIndent() {
        if ($this->indent > 0) {
            $this->indent--;
        }    
    }
    
    public function logStep($step) {
        $indent_str = "-";
        $cur_step = $step;
        for ($i=0; $i < $this->indent; $i++) {
            $cur_step = $indent_str.$cur_step;
        }
        $this->steps[count($this->steps)] = $cur_step;
    }
    
    private function logHardStep() {
        $cur_step = "HARD OR IMPOSSIBLE to balance by inspection. ";
        $cur_step .= "Use the algebraic method or half-cell reactions ";
        $cur_step .= "instead";
        $this->logStep($cur_step);
    }
    
    private static function openDbgFile($dbgfname) {
        Equation::$dbgfile = fopen($dbgfname,"w");
    }
    
    private static function closeDbgFile() {
        fclose(Equation::$dbgfile);
    }
    
    private static function rawDbgWrite($instr) {
        fwrite(Equation::$dbgfile, $instr);
    }
    
    private static function dbgOut($instr, $in_arr="junk") {
        if (!is_array($in_arr)) {
            echo $instr, "<br>";
            Equation::rawDbgWrite($instr."\n");
            return;
        }
        
        $tmparr = explode("%[]", $instr);
        $outstr = $tmparr[0];
        $outstr .= print_r($in_arr, true);
        if (count($tmparr) > 1) $outstr .= $tmparr[1];
        echo $outstr, "<br>";
        Equation::rawDbgWrite($outstr."\n");
    }
    
    private function getOKElems(&$pe, $OH, $condition) {
        foreach ($this->cpds_by_elem as $elem => $cpds) {
            if (!$OH) {
                if ($elem == "O" || $elem == "H") continue;
            } else {
                if ($elem != "O" && $elem != "H") continue;
            }
            if ($this->wksheet[$elem][0] == $this->wksheet[$elem][1]) {
                continue;
            }
            $rxcnt = count($cpds[0]);
            $prcnt = count($cpds[1]);
            switch ($condition) {
                case CompoundRatios::CR1to1: {
                    if ($rxcnt == 1 && $prcnt == 1) {
                        $pe[$elem] = $this->wksheet[$elem];
                    }
                    break;
                }
                case CompoundRatios::CR1toX: {
                    if (($rxcnt == 1 && $prcnt > 1) ||
                            ($rxcnt > 1 && $prcnt == 1)) {
                        $pe[$elem] = $this->wksheet[$elem];
                    }
                    break;
                }
                case CompoundRatios::CRXtoY: {
                    if ($rxcnt > 1) {
                        $pe[$elem] = $this->wksheet[$elem];
                    }
                    break;
                }
                case CompoundRatios::CRunk:
                default: {
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
        // if needed, look for one compound element on each side
        if (count($possible_elems) < 1) {
            $this->getOKElems($possible_elems, false, CompoundRatios::CR1to1);
        }
        // if needed, look for few compounds having element:many compounds
        if (count($possible_elems) < 1) {
            $this->getOKElems($possible_elems, false, CompoundRatios::CRXtoY);
        }
        // now, only equal number (number > 1) of compounds with elements
        // on each side are left. Check for non-O, non-H compounds
        if (count($possible_elems) < 1) {
            $this->getOKElems($possible_elems, false, CompoundRatios::CRunk);
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
            $this->logStep($cur_step);
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
                // if needed, look for one compound having element:more
                // than one compound
                if (count($possible_elems) < 1) {
                    $this->getOKElems($possible_elems, true, 
                            CompoundRatios::CR1toX);
                }
                // if needed, look for few compounds having element:many 
                // compounds
                if (count($possible_elems) < 1) {
                    $this->getOKElems($possible_elems, true, 
                            CompoundRatios::CRXtoY);
                }
                // now, only equal number (number > 1) of compounds with elements
                // on each side are left. Check for non-O, non-H compounds
                if (count($possible_elems) < 1) {
                    $this->getOKElems($possible_elems, true, 
                            CompoundRatios::CRunk);
                }
            }
            $cur_step = "Other elements are balanced. Consider compounds ";
            $cur_step .= "with element ".array_keys($possible_elems)[0].".";
            $this->logStep($cur_step);
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
        //NYI: create a div on the webpage for each applied worksheet
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
    }

    private function findCompoundsOnlyWithElem($elem) {
        $rv = [];
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

    private function compareWorksheets(&$wks1, &$wks2, $elem) {
        $right_wks_better = false;;
        
        //dbg
        /*$step_context = 3;
        $laststep = count($this->steps) - 1;
        $firststep = $laststep - $step_context;
        for ($i=$firststep; $i < $laststep; $i++) {
            $this->dbgOut($this->steps[$i]);
        }
        // must force pointer to end, or insertions will just
        // overwrite the existing last element
        end($this->steps);
        $this->dumpWS($wks1, "Worksheet 1");
        $this->dumpWS($wks2, "Worksheet 2");
        */
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
        // difference between them. Leave defender as is
        return $right_wks_better;
    }

    private function changeCoefs($ps, $cpds, $codiff, &$fulleq, $isdiff=false) {
        $cpdarr = [];
        if (!is_array($cpds)) {
            $cpdarr[$cpds] = $codiff;
        } else {
            $cpdarr = $cpds;
        }
        foreach ( $cpdarr as $cpd => $coef ) {
            if ($ps == "reactant") {
                $this->rxnts->changeCoefficient ( $cpd, $coef, $fulleq, $isdiff );
            } else {
                $this->prods->changeCoefficient ( $cpd, $coef, $fulleq, $isdiff );
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

    private function tryEvenMultiples(&$candidate_cpds, $elem, $cd, $ps_str) {
        $cur_step = "Inspect ".$ps_str."s to see if compounds with ";
        $cur_step .= $elem." can be adjusted to balance ".$elem;
        $this->logStep($cur_step);
        $cpds_w_factor_cnts = [];
        $elem_cnt = 0;
        if (count($candidate_cpds) <= 0) {
            $cur_step = "No candidates found for ".$elem;
            $this->logStep($cur_step);
            return false;
        }
        foreach ($candidate_cpds as $cpd=>$elems) {
            $cur_count = $elems[$elem];
            $elem_cnt += $cur_count;
            if ($cd % $cur_count == 0) {
                $cpds_w_factor_cnts[$cpd] = $elems;
            }
        }
        if ($elem_cnt > 0) {
            $cur_step = "Check if the total ".$elem." count on ".$ps_str." ";
            $cur_step .= "side is a >1 factor of ".$count_diff.", the ";
            $cur_step .= "difference in ".$elem;
            $this->logStep($cur_step, 1);
            if ($cd % $elem_cnt == 0) {
                $coef_diff = $cd / $elem_cnt;
                $cur_step = $cd." is exactly ".$coef_diff." times ";
                $cur_step .= "larger than the ".$ps_str." ".$elem." ";
                $cur_step .= "count, ".$elem_cnt;
                $this->logStep($cur_step);
                $cur_step = "Increase coefficients by ".$coef_diff;
                $this->logStep($cur_step);
                 
                foreach ($candidate_cpds as $cpd=>$elems) {
                    $this->changeCoefs($ps_str, $cpd, $coef_diff, 
                            $this, true);
                }
                $this->applyWorksheetChanges($ps_str);
                return true;
            }
        }
    }
    
    private function updateWorksheet($elem, $first_balance=false) {
        $empty = NULL;
        $this->indent = 0;
        // find compound(s) for given element to balance
        $rxcount = $this->wksheet[$elem][0];
        $prcount = $this->wksheet[$elem][1];
        if ($first_balance) {
            $lcm = lcm($rxcount, $prcount);
            if ($lcm > $this->MAX_COEF) {
                $this->logHardStep();
                return false;
            }
            $rxcoef = $lcm / $rxcount;
            $prcoef = $lcm / $prcount;
            if ($rxcoef > 1) {
                $cur_step = "Try to balance ".$elem."'s by multiplying ";
                $cur_step .= "reactants' coefficients by ".$rxcoef;
                $this->logStep($cur_step);
                $this->rxnts->changeCoefficient($elem, $rxcoef, $this);
                $this->applyWorksheetChanges("reactant");
            }
            if ($prcoef > 1) {
                $cur_step = "Try to balance ".$elem."'s by multiplying ";
                $cur_step .= "products' coefficients by ".$prcoef;
                $this->logStep($cur_step);
                $this->prods->changeCoefficient($elem, $prcoef, $this);
                $this->applyWorksheetChanges("product");
            }
            return true;
        }

        $count_diff = abs($rxcount - $prcount);
        $cur_step = "Find difference in product count and reaction count ";
        $cur_step .= "of ".$elem.". It is ".$count_diff;
        $this->logStep($cur_step);
        $only_elem_cpds =
            $this->findCompoundsOnlyWithElem($elem);
        $prefside = $only_elem_cpds[1];
        $ps_str = "product";
        if ($prcount > $rxcount) {
            $prefside = $only_elem_cpds[0];
            $ps_str = "reactant";
        }
        
        $cur_step = "Check compounds only with ".$elem;
        $this->logStep($cur_step);
        $this->incIndent();
        if ($this->tryEvenMultiples($prefside, $elem, $count_diff, 
                $ps_str)) return true;
        $cur_step = "Total ".$elem." count is not a factor of difference.";
        $this->logStep($cur_step);
        $this->decIndent();
        // initialize defender-challenger worksheets with largest
        // imbalance possible
        $wks1 = $this->wksheet;
        foreach ($wks1 as $e=>$cnts) {
            $wks1[$e] = [32767, 0];
        }
        $wks2 = $wks1;
        $cpds_to_change = [];
        $coef_is_diff = false;
        if (count($cpds_w_factor_cnts) <= 0) {
            $this->findCompoundsToTry($cpds_w_factor_cnts, $elem, 
                    $count_diff, $ps_str);
            $cur_step = "Check compounds with ".$elem." and one or more ";
            $cur_step .= "other elememnts";
            $this->logStep($cur_step);
        }
        if (count($cpds_w_factor_cnts) > 1) {
            foreach ($cpds_w_factor_cnts as $cpd=>$elems) {
                $orig_coef = $elems["#"];
                $factor_coef = $count_diff + $elems[$elem];
                if ($count_diff % $elems[$elem] == 0) {
                    $factor_coef = $count_diff / $elems[$elem];
                }
                $this->changeCoefs($ps_str, $cpd, $factor_coef, $empty); 
                $this->applyWorksheetChanges($ps_str);
                $wks2 = $this->wksheet;
                $foundNewBalanced = 
                        $this->compareWorksheets($wks1, $wks2, $elem);
                $step_st = "Balance";
                if ($foundNewBalanced) {
                    $cur_step = $step_st." using ".$cpd.", which has a ".$elem;
                    $cur_step .= " count that is a factor of difference";
                    $this->logStep($cur_step);
                    $wks1 = $wks2;
                    $coef_is_diff = false;
                    $cpds_to_change[$cpd] = $factor_coef;
                }
                $this->changeCoefs($ps_str, $cpd, $orig_coef, $empty); 
                $this->applyWorksheetChanges($ps_str);
            }
            // check possible sums of compounds, but only for case where
            // number of compounds is 2. Higher numbers too complex to check
            if (count($cpds_w_factor_cnts) == 2) {
                foreach ($cpds_w_factor_cnts as $cpd=>$elems) {
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
                if (count($coefs_to_try) > $this->MAX_COEF_LOOPS) {
                    $this->logHardStep();
                    return false;
                }
                foreach ($coefs_to_try as $i=>$coefs) {
                    $this->changeCoefs($ps_str, $cpd1, $coefs[0], $empty, 
                        true);
                    $this->changeCoefs($ps_str, $cpd2, $coefs[1], $empty, 
                        true);
                    $this->applyWorksheetChanges($ps_str);
                    $wks2 = $this->wksheet;
                    // if there is an existing non-dummy defender, then
                    // when a new defender is found re-balancing occurs
                    $step_st = "Balance";
                    if ($foundNewBalanced) $step_st = "Re-balance";
                    $foundNewBalanced = 
                            $this->compareWorksheets($wks1, $wks2, $elem);
                    if ($foundNewBalanced) {
                        $wks1 = $wks2;
                        $coef_is_diff = true;
                        $cur_step = $step_st." by changing coefficients of ";
                        $cur_step .= $elem." compounds such that their ";
                        $cur_step .= "atom count sum is a factor of ";
                        $cur_step .= "the difference";
                        $this->logStep($cur_step);
                        unset($cpds_to_change);
                        $cpds_to_change[$cpd1] = $coefs[0];
                        $cpds_to_change[$cpd2] = $coefs[1];
                    }
                    $this->changeCoefs($ps_str, $cpd1, $orig_coef1, $empty);
                    $this->changeCoefs($ps_str, $cpd2, $orig_coef2, $empty);
                    $this->applyWorksheetChanges($ps_str);
                }
            }
            $this->changeCoefs($ps_str, $cpds_to_change, 0, 
                    $this, $coef_is_diff);
            $this->applyWorksheetChanges($ps_str);
            //$this->dumpWS($this->wksheet, "After wks chosen");
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
            if ($lcm > $this->MAX_COEF) {
                $this->logHardStep();
                return false;
            }
            $rxcpds = $this->rxnts->getCompoundList();
            $prcpds = $this->prods->getCompoundList();
            if ($ps_str == "reactant") {
                $rxcoef = $lcm / $rxcpds[$cur_cpd][$elem];
                $cur_step = "Try to balance ".$elem."'s by multiplying ";
                $cur_step .= "reactants' coefficients by ".$rxcoef;
                $this->logStep($cur_step);
                $this->rxnts->changeCoefficient($elem, $rxcoef, $this);
                $this->applyWorksheetChanges("reactant");
            }
            if ($ps_str == "product") {
                $prcoef = $lcm / $prcpds[$cur_cpd][$elem];
                $cur_step = "Try to balance ".$elem."'s by multiplying ";
                $cur_step .= "products' coefficients by ".$prcoef;
                $this->logStep($cur_step);
                $this->prods->changeCoefficient($elem, $prcoef, $this);
                $this->applyWorksheetChanges("product");
            }
            return true;
        }
        $this->logHardStep();
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

        $cf = checkEqSide($this->rxnts->getCompoundList(), $low_coefs, 
                $factor_cpds, $cf);
        if ($cf < 2) return 1;
        $cf = checkEqSide($this->prods->getCompoundList(), $low_coefs, 
                $factor_cpds, $cf);
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
            $raw_last_step = trim($this->steps[count($this->steps) - 1], "- "); 
            $last_step_start = substr($raw_last_step, 0, 4);
            if ($last_step_start == "HARD") {
                $cur_step = "** ".$raw_last_step;
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
                $this->logStep($cur_step);
            }
        }
        // debug - output all steps to debug file
        Equation::rawDbgWrite("DEBUG list all steps\n");
        Equation::rawDbgWrite("=======".count($this->steps)."=========\n");
        for ($i=0;$i < count($this->steps); $i++) {
            Equation::rawDbgWrite($this->steps[$i]."\n");
        }
        Equation::closeDbgFile();
    }
    
    public function showReaction($header) {
        echo "\n\t\t\t", $header, ":<br>\n";
        $this->formatReaction();
        echo $this->formattedRxn;
    }

    private function formatInvalidReaction($fontsize, $f_end, $no_raw_rxn) {
        // get reaction string from raw JSON string
        function formatRawJSONRxn($rawjson) {
            $raw_rxn = "";
            $raw_cpds = split("rxnts", $rawjson);
            $raw_cpds = split(": "."\[{", $raw_cpds[1]);
            for ($i=0; $i < count($raw_cpds) - 1; $i ++) {
                if (strpos($raw_cpds[$i], "prods") > 0) {
                    if (strrpos($raw_rxn, "+") === false) {
                        $raw_rxn = "= ";
                    } else {
                        $raw_rxn[strrpos($raw_rxn, "+")] = "=";
                    }
                }
                $split1 = split(':\{"', $raw_cpds[$i]);
                $cur_cpd = $split1[1];
                if (strlen($cur_cpd) < 1) $cur_cpd = $split1[0];
                if (strpos($cur_cpd, "], ") > 0) {
                    $split2 = split("}\], ", $cur_cpd);
                    $cur_cpd = $split2[1];
                }
                $raw_rxn .= trim($cur_cpd, '{[""]}')." + ";
            }
            $raw_rxn = rtrim($raw_rxn, " +");
            return $raw_rxn;            
        }
        
        if ($no_raw_rxn) {
            $this->formattedRxn = formatRawJSONRxn($this->raw_json);
        } else {
            $this->formattedRxn = substr($this->formattedRxn, 7);
        }
        $this->formattedRxn = $fontsize.$this->formattedRxn.$f_end;
        $haveNum = false;
        $fmtstr = $fontsize;
        for ($i=strlen($fontsize);
        $i < strlen($this->formattedRxn); $i++) {
                $curnum = ord($this->formattedRxn[$i]) - ord("0");
            if ($curnum >= 0 && $curnum <= 9) {
                if (!$haveNum) {
                    $haveNum = true;
                    $fmtstr .= "<sub>";
                }
            } else if ($haveNum) {
                $fmtstr .= "</sub>";
                $haveNum = false;
            }
            $fmtstr .= $this->formattedRxn[$i];
        }
        $this->formattedRxn = $fmtstr;
    }
    
    private function formatReaction() {
        $fontsize = "<font size=5>";
        $f_end = "</font>";
        $badstr = substr($this->formattedRxn, 0, 7);
        $jscript_bad_eqn = $badstr == "--BAD--";
        $php_bad_eqn = ($this->rxnts == NULL || $this->prods == NULL);
        if ($jscript_bad_eqn || $php_bad_eqn) {
            $this->formatInvalidReaction($fontsize, $f_end, 
                    !($jscript_bad_eqn));
            return;
        }
        $outstr = $fontsize;
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
        $outstr .= $f_end."\n";
        
        $this->formattedRxn = $outstr;
    }

    public function dumpWS(&$ws, $header) {
        echo "<pre>", $header, "\n";
        Equation::rawDbgWrite($header."\n");
        echo "Element,R,P\n";    
        Equation::rawDbgWrite("Element,R,P\n");    
        foreach ($ws as $elem=>$cnts) {
            echo $elem, ", ", $cnts[0], ", ", $cnts[1], "\n";
            Equation::rawDbgWrite($elem.", ".$cnts[0].", ".$cnts[1]."\n");
        }
        echo "</pre>";
        Equation::rawDbgWrite("\n+++++++++++++".count($this->steps)."+++++++++++++\n");
    }

    public function debug_du_jour() {
        echo "compounds sorted by elements:<br>"; var_dump($this->cpds_by_elem); echo "<hr>";
        foreach ($this->wksheet as $e=>$cnts) {
            echo "findOnly for '", $e, "' returns:<br>";
            var_dump($this->findCompoundsOnlyWithElem($e)); echo "<br><hr>";
        }
    }
}

class EqFactory {
    private static $eqfactory;
    private static $created = false;
    private $eqn;
    
    private function __construct() {
        $created = true;
    }
    
    public function newEquation() {
        $rawEqJSON = file_get_contents("php://input");
        if (strlen($rawEqJSON) < 2) {
            return null;
        }
        $eqJSON = stripslashes($rawEqJSON);
        $eqJSON = substr($eqJSON, 0, strlen($eqJSON) - 5)."}]}}";
        $eqJSON = str_replace('""', '"', $eqJSON);
        // fix for errstr member for valid equations
        $eqJSON = str_replace(':",', ':"",', $eqJSON);
        $eqJSON = str_replace('"[', '[', $eqJSON);
        $eqJSON = str_replace(']"', ']', $eqJSON);
        $eqJSON = str_replace('"{', '{', $eqJSON);
        $eqJSON = str_replace('}"', '}', $eqJSON);
        
        $this->eqn = new Equation($eqJSON);
        
        return $this->eqn;
    }
    
    public static function getInstance() {
        if (!$created) $eqfactory = new EqFactory();
        return $eqfactory;
    }
}
