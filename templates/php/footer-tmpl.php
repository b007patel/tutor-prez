<?php
if (!$GLOBALS['have_footer']) {
	echo <<<'EOB'

	</div>

	<footer class="footer hidden-xs">
 		<div class="container">
			<ul id="footer-imgs">
				<li>
					<span>
						<p class="footer-text text-center">This site uses</p>
					</span>
				</li>


EOB;
	foreach ( $footer_imgs as $currILI ) {
		$ili = new ImageLI( 4, "footer" );
		$ili->setLabel( $currILI["label"] );
		$ili->setLink( $currILI["link"] );
		$ili->setCssID( $currILI["cssID"] );
		$ili->setImageLoc( $currILI["imgloc"] );
		echo $ili->listItemMarkup();
	}

	echo <<<'EOD'
			    <li>
			        <span>
			            <a class="footer-text text-center" href="/about.php#technologies">and more...</a>
			        </span>
			    </li>
						
			</ul>
		</div>
	</footer>
	
EOD;
}
