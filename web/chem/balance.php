<?php
//NYI:
// use localized strings?
include "../php/chem_funcs.php";
$page_title = "Chemical Reaction Balancer (by Inspection)";
include "../php/html-start-tmpl.php";
//include "../php/nav_tmpl.php";
echo <<<"EOT"
	<h2>Chemical Reaction Balancer</h2>
	<div id="rxn_main" class="bdrtop col-sm-24 col-md-12">
		<table class='center col-sm-24 col-md-12">
		<div id="rxn_form"> 
			<form id='balance' action='#' method="" style='margin-bottom:0;'>
			<tr>
				<td><label class="col-sm-24 col-md-12"><b>Enter a chemical equation to balance:</b><br></td>
			</tr>
			<tr>
				<td style='padding-left: 15px;'>
					<input autofocus id='reaction' style='width: 97%;' 
						placeholder='Enter a chemical equation to balance'
						oninput='ChemRxn.rxnChanged(this);'
						onkeypress='return kpEnterHandler(event, ChemRxn.postReaction);'>
				</label></td>
				<td><input type='button' id="bal_button" value='Balance' onclick="ChemRxn.postReaction();"></td>
			</form>
			</tr>
		</div>
		<tr id="loadjs" style="display: none;">
			<td>
				<h2>Balancing equation...</h2>
				<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>
				<span class="sr-only">Balancing...</span>
			</td>
		</tr>
		<tr id="balance_details">
			<td>

EOT;
$eqf = EqFactory::getInstance();
$eqn = $eqf->newEquation();
if ($eqn != NULL) {
    $rxnts = $eqn->getReactants();
    $prods = $eqn->getProducts();
    if ($rxnts == NULL || $prods == NULL) {
        echo "<br>\n<div id='rxn_errors' class='bdrtop'>\n";
        $eqn->showReaction("The reaction:");
        echo "<br>is INVALID!!<br>\n";
        echo "<br>Error(s):<br><ul>";
        foreach ($eqn->getErrors() as $i=>$err) {
            echo $err;
        }
        echo "</ul>\n";
    } else {
        if (count($eqn->getErrors()) > 0) {
            echo "<br><div id='rxn_warns' class='bdrtop bdrbtm'>Warning(s):<br>\n";
            foreach ($eqn->getErrors() as $i=>$err) {
                echo $err;
            }
            echo "</ul>\n<br></div>";
        }
        echo "<div id='rxn_unbal'>";
        $eqn->showReaction("Starting (Unbalanced) reaction");
        $eqn->balance();
        echo <<<"TMP"
		</div>

TMP;
        $steplist = $eqn->getSteps();
        $too_many_steps = false;
        if (count($steplist) > 0) {
            // 9 = strlen("<ul>\n<li>")
            $too_many_steps = substr(trim($steplist[0]), 9, 2) == "**";
        }
        if ($too_many_steps) { 
            // because the first step is omitted (no need to repeat the
            // "too hard to balance..." msg) insert a <ul> tag manually
            echo <<<"TMP"

		<div id="extra_steps" class="bdrtop" style="display: none;">
			<h3>Unabridged steps in balancing</h3>
			<ul>
TMP;
            for ($i = 1; $i < count($steplist); $i++) {
                echo <<<"TMP"
			$steplist[$i]
TMP;
            }
        } else {
            echo "\t\t<div id='rxn_bal' class='bdrtop'>\n";
            $eqn->showReaction("Balanced reaction");
        }
        echo <<<"TMP"
		</div>
		<div id="rxn_steps" class="bdrtop">
			<h3>Steps in balancing</h3>

TMP;
        if (!$too_many_steps) { 
            foreach ($steplist as $bal_step) {
                echo <<<"TMP"
			$bal_step

TMP;
            }
        } else {
            echo <<<"TMP"
			$steplist[0]
        
TMP;
        }
        $last_wks_prefix = '<div id="wks_st'.count($steplist).'" ';
        $last_wks_prefix .= 'class="bdrtop wksheet">';
        echo <<<"TMP"
		</div>
                $last_wks_prefix
			<h3>Final Worksheet</h3>

TMP;
        foreach ($eqn->getWorksheet() as $i => $wkrow) {
            echo <<<"TMP"
			$wkrow

TMP;
        }
        echo "</div>\n\t\t<br>";
    }
}

echo <<<"EOT"
				</td>
			</tr>
		</div>
		</table>
	</div>
EOT;
//include "../php/footer-tmpl.php";
$custom_scripts = "tp_common,chem_validate";
Equation::closeDbgFile();
include "../php/html-end-tmpl.php";
