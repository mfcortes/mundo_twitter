use Config::Simple

$inifile="./cfg/twitter.ini";


if ( -e $inifile )
{
	Config::Simple->import_from($inifile,\%config);
	
	
	print $config{'mysql.basename'};
}