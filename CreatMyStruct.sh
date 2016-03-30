#!/bin/bash	
	echo 'Bienvenue dans mon "CreatMyArch"';

	# rep=$(pwd);

# Read
	echo 'Entrez un nom de dossier :';
	read nameDir;
	echo 'Entrez le nom du projet :';
	read nameProject;
	echo 'Dans un dossier "src" ? [y/n]';
	read srcDir;
	echo "Intégrer CDN Font Awesome ? [y/n]";
	read fontAwesome;
	echo "Intégrer CDN JQuery ? [y/n]";
	read JQuery;
	echo "Utiliser LESS ? [y/n]";
	read rless;
# end Read
	mkdir $nameDir;
	cd $nameDir
	
	if [[ $srcDir == 'y' || $srcDir == 'Y' ]]; then
		mkdir 'src';
		cd 'src';
	fi

	clear

	echo '-------- Création des dossiers --------';

	mkdir -p 'app/class';
	mkdir -p 'app/views/inc';
	mkdir -p 'app/core';
	mkdir -p 'app/controllers';
	mkdir -p 'app/config';

	echo '------------- En cours .. -------------';

	mkdir -p 'public/assets/css';
	mkdir -p 'public/assets/js';
	mkdir -p 'public/assets/img';

	echo '--- Création des dossiers terminé ! ---';
	echo '---------------------------------------';
	echo '-------- Création des fichiers --------';

	dirApp="../app";

# /app/
	# ./config/
	echo "<?php
	session_start();
	
	function myAutoloader(\$class) {
		require_once('../app/class/' . ucfirst(\$class) . '.class.php');
	}
	spl_autoload_register('myAutoloader');
	\$_PAGE = new Page();

	require_once('functions.php');" > 'app/config/config.php';

	echo "<?php
	" > 'app/config/functions.php';

	# controllers / core
	echo "<?php
	" > 'app/controllers/home.controllers.php';
	echo "<?php
	" > 'app/core/home.core.php';

	# class

	echo "<?php
class Page {
	public \$nameProject = '$nameProject';

	public function getInfo(\$info){
		return \$this->\$info;
	}
}
	" > 'app/class/Page.class.php';
	# views/
	# ./inc/
	echo "<!DOCTYPE html>
<html lang=\"en\">
<head>
	<meta charset=\"UTF-8\">
	<title><?= \$_PAGE->getInfo('nameProject'); ?></title>" > 'app/views/inc/head.php';
	if [[ $fontAwesome == 'y' || $fontAwesome == 'Y' ]]; then
		echo "	<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css\">" >> 'app/views/inc/head.php';
		monIcon='<i class="fa fa-home"></i>';
	else
		monIcon='';
	fi
	
	echo "	<link rel=\"stylesheet\" href=\"/assets/css/style.css\">
</head>
<body>" >> 'app/views/inc/head.php';
	
	# ./
	echo "	<div class=\"warp\">
		<h1 class=\"titlePage\">$monIcon Hello World !</h1>
	</div>" > 'app/views/home.php';


	if [[ $JQuery == 'y' || $JQuery == 'Y' ]]; then
		echo "	<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/2.2.2/jquery.min.js\"></script>" >> 'app/views/inc/footer.php';
		echo '$(function(){});' > 'public/assets/js/app.js'; # 
	else
		echo '' > 'public/assets/js/app.js';
	fi

	echo "	<script src=\"/assets/js/app.js\"></script>
</body></html>" >> 'app/views/inc/footer.php';

	echo '------------- En cours .. -------------';

# /public
	# ./
	echo "<?php
	require_once('$dirApp/config/config.php');

	require_once('$dirApp/controllers/home.controllers.php');
	require_once('$dirApp/core/home.core.php');

	require_once('$dirApp/views/inc/head.php');
	require_once('$dirApp/views/home.php');
	require_once('$dirApp/views/inc/footer.php');" > 'public/index.php';

	# assets/

	csss="*{padding:0;margin:0;box-sizing:border-box;}";
	csse="body{background-color:#F4F4F4;font-family:sans-serif;}
.warp{max-width:1200px;margin:0 auto;background-color:#292929;color:#FFF;}
	.titlePage{font-size:64px;font-weight:900;text-align:center;}";
		#less/css
		if [[ $rless == 'y' || $rless == 'Y' ]]; then
			mkdir -p 'public/assets/less';
			echo "$csss
@import url('mixins');
@import url('global');
$csse" > 'public/assets/less/style.less';
			echo "" > 'public/assets/less/global.less';
			echo "" > 'public/assets/less/mixins.less';
			lessc 'public/assets/less/style.less' 'public/assets/css/style.css' > /dev/null
		else
			echo "$csss
$csse" > 'public/assets/css/style.css';
		fi


	echo '--- Création des fichiers terminé ! ---';
	echo '---------------------------------------';
	echo '--------- Création terminé ! ----------';