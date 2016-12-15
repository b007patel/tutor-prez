<?php 
	require_once 'vendor/autoload.php';
	use BrowscapPHP\Browscap;
	use BrowscapPHP\Cache;
	use WurflCache\Adapter;

	$js_browser_id = "";
	$browscap_cache_parms['dir'] = "/var/www/php";
	$browscap = new Browscap();
	$wurfl_file_cache = new WurflCache\Adapter\File($browscap_cache_parms);
	$bc_cache = new BrowscapPHP\Cache\BrowscapCache($wurfl_file_cache); 
	$browscap->setCache($bc_cache);
	$browser_info = get_object_vars($browscap->getBrowser());
	// because newer Chrome and Firefox support the JS keyword "class",
	// and $_SERVER["HTTP_USER_AGENT"] returns a bunch of
	// 'unknown' values for many browsers, this is the best we can do
	//$isChromeOrFF = $browser_info["platform"] != "unknown";
	$isChromeOrFF = $browser_info["platform"] != "unknown";
	if ($isChromeOrFF) {
		$isChromeOrFF = ($browser_info["browser"] == "Chrome" && 
				$browser_info["version"] >= 49);
		if (!$isChromeOrFF) {
			$isChromeOrFF = (
					$browser_info["browser"] == "Firefox" &&
					$browser_info["version"] >= 45);
		}
	}
	if ($isChromeOrFF) {
		$js_browser_id = "_chfx";
	}

	$js_suffix = $js_browser_id.".js";
	$add_css_sheets = "../css/styles.css";
?>
