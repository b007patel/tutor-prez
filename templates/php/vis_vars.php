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
	
	/**
		A list item tied to an image.
	*/
	class ImageLI
	{
		
		/*BP: for footer baseIndent=4, for technologies ul baseIndent=6
		BP: for footer container defaults to "footer", ul container="ul"*/

		private $__label = "";
		private $__link = "";
		private $__cssID = "";
		private $__imgloc = "";
		private $__ttContainer = "";
		private $__baseIndent = -1;
		private $__showLabel = false;

		function __construct( $baseIndent = 1, $ttContainer = "footer" )
		{
			$this->__baseIndent = $baseIndent;
			$this->__ttContainer = $ttContainer;
		}

		public function getLabel()
		{
			return $this->__label;
		}

		public function setLabel( $label )
		{
			$this->__label = $label;
		}

		function getLink()
		{
			return $this->__link;
		}

		function setLink( $link )
		{
			$this->__link = $link;
		}
			
		function getCssID()
		{
			return $this->__cssID;
		}

		function setCssID( $cssID )
		{
			$this->__cssID = $cssID;
		}
			
		function getImageLoc()
		{
			return $this->__imgloc;
		}

		function setImageLoc( $imgloc )
		{
			$this->__imgloc = $imgloc;
		}
						
		function getTooltipContainer()
		{
			return $this->__ttContainer;
		}
				
		function getBaseIndent()
		{
			return $this->__baseIndent;
		}

		function isLabelShown()
		{
			return $this->__showLabel;
		}

		function showLabel( $shouldShowLabel )
		{
			$this->__showLabel = $shouldShowLabel;
		}

		function listItemMarkup( )
		{
			$liPart = "<li>".PHP_EOL;
			$liMarkup = str_pad( $liPart, $this->__baseIndent + strlen($liPart), "\t", STR_PAD_LEFT );
			$liPart = "\t<span>".PHP_EOL;
			$liMarkup .= str_pad( $liPart, $this->__baseIndent + strlen($liPart), "\t", STR_PAD_LEFT );
			$liPart = "\t\t<a href=\"$this->__link\" title=\"$this->__label\" id=\"$this->__cssID\" ";
			$liMarkup .= str_pad( $liPart, $this->__baseIndent + strlen($liPart), "\t", STR_PAD_LEFT );
			if ( ! $this->__showLabel ) {
				$liMarkup .= "data-toggle=\"tooltip\" data-container=\"$this->__ttContainer\" data-placement=\"auto top\"";
			}
			$liMarkup .= ">".PHP_EOL;
			$liPart = "\t\t\t<img src=\"$this->__imgloc\" class=\"img-responsive\">".PHP_EOL;
			$liMarkup .= str_pad( $liPart, $this->__baseIndent + strlen($liPart), "\t", STR_PAD_LEFT );
			if ( $this->__showLabel ) {
				$liMarkup .= " $this->__label";
			}
			$liPart = "\t\t</a>".PHP_EOL;
			$liMarkup .= str_pad( $liPart, $this->__baseIndent + strlen($liPart), "\t", STR_PAD_LEFT );
			$liPart = "\t</span>".PHP_EOL;
			$liMarkup .= str_pad( $liPart, $this->__baseIndent + strlen($liPart), "\t", STR_PAD_LEFT );
			$liPart = "</li>".PHP_EOL;
			$liMarkup .= str_pad( $liPart, $this->__baseIndent + strlen($liPart), "\t", STR_PAD_LEFT );

			return $liMarkup;
		}
	}

	function img_cmp( $a, $b ) {
		if ( $a["cssID"] == $b["cssID"] ) {
			return 0;
		}
		
		return ( $a["cssID"] < $b["cssID"] ) ? -1 : 1;
	}

	$footer_imgs = [
		[ "link" => "https://www.positivessl.com/", "label" => "Positive SSL certificate", 
			"cssID" => "comodoTL", "imgloc" => "/img/comodo_secure_113x59_transp.png" ],
		[ "link" => "http://www.ubuntu.com/server/", "label" => "Ubuntu 14.04.2 LTS", 
			"cssID" => "UbuntuMk", "imgloc" => "/img/ubuntu-orange-hex.png" ],
		[ "link" => "https://httpd.apache.org/", "label" => "Apache HTTPD 2.4.7", 
			"cssID" => "ApachePB", "imgloc" => "/img/pb-apache.png" ],
		[ "link" => "https://aws.amazon.com/", "label" => "Amazon Web Services", 
			"cssID" => "AWSMk", "imgloc" => "/img/aws-logo.png" ],
		[ "link" => "https://getbootstrap.com/", "label" => "Bootstrap 3.5.5", 
			"cssID" => "BootstrapMk", "imgloc" => "/img/bootstrap-solid.svg" ]
	];

	$tech_imgs = $footer_imgs;

	$tech_imgs[] = [ "link" => "https://www.mysql.com/",
			"label" => "MariaDB using MySQL 5.5 interfaces", 
			"cssID" => "MySQLPB", "imgloc" => "/img/pb-mysql.svg" ];
	$tech_imgs[] = [ "link" => "https://www.mariadb.org/",
			"label" => "MariaDB 5.5.46", "cssID" => "MariaDBPB",
			"imgloc" => "/img/pb-mariadb.png" ];

	usort( $tech_imgs, "img_cmp" );

 ?>
