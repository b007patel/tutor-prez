<?php 
	$js_browser_id = "";
	$browser_info  = get_browser(NULL, true);
	// because newer Chrome and Firefox support the JS keyword "class",
	// and $_SERVER["HTTP_USER_AGENT"] returns a bunch of
	// 'unknown' values for many browsers, this is the best we can do
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
?>
