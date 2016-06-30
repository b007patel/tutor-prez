<?php

include "../php/sci_funcs.php";

echo <<<'EOT'
<table class='center' style='width: 800px'> 
<tr><td>
<form name='balance' id='balance' action='balance.php' method='post' style='margin-bottom:0;'>
<label><b>Enter a chemical equation to balance:</b><br>
EOT;
echo "<input autofocus name='reaction' id='reaction' value='",$_POST["reaction"],"' maxlength='200' style='width: 80%;' placeholder='Enter a chemical equation to balance'></label>\n";
echo <<<'EOS'
<input type='submit' value='Balance'>
</form>
</td></tr>
<tr><td>
EOS;

//$n1 = 15; $n2 = 24;
//echo "for ", $n1, " and ", $n2, " LCM=";
//echo lcm($n1, $n2), ", GCF=", gcf($n1, $n2), "<br>";
//echo "<hr>";
if (strlen($_POST["reaction"]) > 0) {
    $eqn = new Equation($_POST["reaction"]);
    $rxnts = $eqn->getReactants();
    $prods = $eqn->getProducts();
    if ($rxnts == NULL || $prods == NULL) {
        echo $_POST["reaction"], " is INVALID!!<br>";
    } else {
        $eqn->showReaction("Starting (Unbalanced) reaction");
        echo "<hr><br>";
        //$eqn->debug_du_jour();
        $eqn->balance();
        echo <<<"TMP"
Steps in balancing:<br>
=============<br>

TMP;
        $steplist = $eqn->getSteps();
        $too_many_steps = substr($steplist[0], 0, 2) == "**";
        if (!$too_many_steps) { 
            foreach ($eqn->getSteps() as $bal_step) {
                echo <<<"TMP"
$bal_step<br>

TMP;
            }
        } else {
            echo <<<"TMP"
$steplist[0]<br>
        
TMP;
        }
        echo <<<'TMP'

<hr>
====final worksheet====<br>

TMP;
        foreach ($eqn->getWorksheet() as $elem => $cnts) {
            echo <<<"TMP"
<pre>$elem\t$cnts[0]\t$cnts[1]</pre>

TMP;
        }
        echo "\n<br><hr><br>";
        if ($too_many_steps) { 
            echo <<<"TMP"

<div id="extra_steps" style="display: none;">
Unabridged steps in balancing:<br>
=============<br>

TMP;
            for ($i = 1; $i < count($steplist); $i++) {
                echo <<<"TMP"
- $steplist[$i]<br>

TMP;
            }
            echo "<hr></div>";
        } else {
            $eqn->showReaction("Balanced reaction");
        }
    }
}

echo <<<'EOT'
</td></tr>
</table>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<script src="../js/tp_common.js"></script>
<script src="../js/chem_validate.js"></script>
<script>
		var eq = new ChemRxn($("input#reaction").val());
</script>
EOT;
