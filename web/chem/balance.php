<?php
//NYI:
// use localized strings?
include "../php/chem_funcs.php";

echo <<<'EOT'
<table class='center' style='width: 800px'> 
<tr><td>
<form name='balance' id='balance' action='#' method="" style='margin-bottom:0;'>
<label><b>Enter a chemical equation to balance:</b><br>
EOT;
echo "<input autofocus name='reaction' id='reaction' maxlength='200' style='width: 80%;' placeholder='Enter a chemical equation to balance' oninput='rxnChanged(this);' onkeypress='return kpHandler(event);'></label>\n";
echo <<<'EOS'
<input type='button' name="bal_button" value='Balance' onclick="postReaction();" ;>
</form>
</td></tr>
<tr><td>
EOS;

$eqf = EqFactory::getInstance();
$eqn = $eqf->newEquation();
if ($eqn != NULL) {
    $rxnts = $eqn->getReactants();
    $prods = $eqn->getProducts();
    if ($rxnts == NULL || $prods == NULL) {
        $eqn->showReaction("The reaction:");
        echo "<br>is INVALID!!<br>";
        echo "<br>Error(s):<br>";
        foreach ($eqn->getErrors() as $i=>$err) {
        	echo "- ", $err, "<br>";
        }
    } else {
    	if (count($eqn->getErrors()) > 0) {
    		echo "<br>Warning(s):<br>";
    	    foreach ($eqn->getErrors() as $i=>$err) {
        		echo "- ", $err, "<br>";
        	}
        	echo "<br><br>";
    	}
        $eqn->showReaction("Starting (Unbalanced) reaction");
        echo "<hr><br>";
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
    var cur_txt, last_txt;
    function rxnChanged(tb) {
        cur_txt = tb.value;
    };
        
	function kpHandler(event) {
    	if (event.which == 13 || event.keyCode == 13) {
        	postReaction();
        	return false;
    	}
    	return true;
	};

    function postReaction() {
        var eq = new ChemRxn(cur_txt);
        var post_json = JSON.stringify(eq);
		var xhr = new XMLHttpRequest();
        last_txt = cur_txt;
        xhr.open("POST", "balance.php");
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
        xhr.send(post_json);
        
        //console.log("xhr:", xhr);
        xhr.onloadend = function () {
            document.body.innerHTML = xhr.responseText;
            $("input#reaction").val(last_txt);
        };
    };
</script>
EOT;
