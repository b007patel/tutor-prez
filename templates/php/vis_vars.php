<?php 
	require_once 'vendor/autoload.php';
	use BrowscapPHP\Browscap;
	use BrowscapPHP\Cache;
	use WurflCache\Adapter;

	// browser supports Javascript class keyword. Most browsers
	// support it as of Jun 2020
	$js_browser_id = "_jscls";
	$browscap_cache_parms['dir'] = "/var/www/php";
	$browscap = new Browscap();
	$wurfl_file_cache = new WurflCache\Adapter\File($browscap_cache_parms);
	$bc_cache = new BrowscapPHP\Cache\BrowscapCache($wurfl_file_cache); 
	$browscap->setCache($bc_cache);
	$browser_info = get_object_vars($browscap->getBrowser());
	// because newer Chrome and Firefox support the JS keyword "class",
	// and $_SERVER["HTTP_USER_AGENT"] returns a bunch of
	// 'unknown' values for many browsers, this is the best we can do
	// It also returns version as '0.0' for updated browsers not in
	// browscap.ini yet
	$dbglog = "./bp_php_err.log";
        /*error_log(print_r($browser_info, true), 3, $dbglog);
        error_log("\n\n***".print_r($_SERVER["HTTP_USER_AGENT"], true)."\n",
		3, $dbglog);*/
	$hasJSClass = $browser_info["platform"] != "unknown";
	$brows_ver = $browser_info["version"];
	if ($brows_ver == "unknown" || $brows_ver == 0) {
		$user_agent = $_SERVER["HTTP_USER_AGENT"];
		$ua_regex = $browser_info["browser_name_regex"]."i";
		//error_log("=-=RAW REGEX: ".$ua_regex."\n\n", 3, $dbglog);
		$ua_regex = str_replace(".*$", "(.*)$", $ua_regex);
		//error_log("EDITED REGEX: ".$ua_regex."\n\n", 3, $dbglog);
		preg_match($ua_regex, $user_agent, $vers_match);
		/*error_log("\n>>>>\n".print_r(
			$vers_match, true)."<<<\n\n", 3, $dbglog
		);*/
		$brows_ver = $vers_match[1];
	}
	if ($hasJSClass) {
		$hasJSClass = (
			$browser_info["browser"] == "Chrome" && 
				($brows_ver >= 49)
		);
	}
	if (!$hasJSClass) {
		$hasJSClass = (
			$browser_info["browser"] == "Firefox" &&
			($brows_ver >= 45)
		);
	}
	if (!$hasJSClass) {
		$hasJSClass = (
			$browser_info["browser"] == "Edge" &&
			($brows_ver >= 60)
		);
	}
	if (!$hasJSClass) {
		$js_browser_id = "_etc_nojscls";
	}

	$js_suffix = $js_browser_id.".js";
	$add_css_sheets = "../css/styles.css";
?>
