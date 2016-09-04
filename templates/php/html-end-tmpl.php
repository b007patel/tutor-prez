
	<!-- Bootstrap core JavaScript
	================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<?php
	//echo '	<script src="https://'.$_SERVER['SERVER_NAME'].'/js/lightbox.min.js"></script>'.chr(10);
	echo '	<script src="https://'.$_SERVER['SERVER_NAME'].'/js/custom.js"></script>'.chr(10);
	$ord_a = ord("a"); $ord_z = ord("z");
	$cjs = explode(",", $custom_scripts);
	foreach ($cjs as $i=>$js_name) {
		$js_prefix = '<script src="';
		$cur_ord = ord(strtolower(substr($js_name, 0, 1)));
		if ($cur_ord >= $ord_a && $cur_ord <= $ord_z) {
			$js_prefix .= '../js/';
		}
		$js_prefix = trim($js_prefix);
		echo <<<"SCR"
	$js_prefix$js_name$js_suffix"></script>

SCR;
	}
?>
	</body>
</html>
