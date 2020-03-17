use Config::Simple;

my %variablesini;


sub carga_ini()
{
	$inifile="./cfg/twitter.ini";


	if ( -e $inifile )
	{
		Config::Simple->import_from($inifile,\%variablesini);
	}
	else
	{
		print("Error no existe archivo $inifile");
		exit 1;
	}
}


&carga_ini();
$host=$variablesini{'servidor.host'};


$curl="curl -o temporal.html ".$host."/mineriaOpinion/analisisSentimiento.php";
`$curl`;
