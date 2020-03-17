use DBI;
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


sub conecta_mysql()
{
	$host=$variablesini{'mysql.host'};
    $db=$variablesini{'mysql.basename'};
    $user=$variablesini{'mysql.user'};
    $password=$variablesini{'mysql.password'};
    
	#connect to MySQL database
	my $dbh   = DBI->connect ("DBI:mysql:database=$db:host=$host",
    	                       $user,
        	                   $password) 
            	               or die "Can't connect to database: $DBI::errstr\n";

	return $dbh;
}

sub close_mysql()
{
    #disconnect  from database
	$_[1-1]->disconnect or warn "Disconnection error: $DBI::errstr\n";
}

sub credenciales()
{
	$idproceso=$_[1-1];
	$conexion=$_[2-1];
	
	$query="select idproceso,consumerkey,consumersecret,accestoken,accestokensecret from credencialestwiter where idproceso=$idproceso";
	#print "$query\n";
	$resultado = $conexion->prepare($query);
	
	$resultado->execute();
	@valor=$resultado->fetchrow_array();
	$resultado->finish;
	printf("%d %s %s %s %s\n",$valor[0],$valor[1],$valor[2],$valor[3],$valor[4]);
	
	
}

$idproceso=$ARGV[1-1];
&carga_ini();
$db=&conecta_mysql();
&credenciales($idproceso,$db);
&close_mysql($db);

