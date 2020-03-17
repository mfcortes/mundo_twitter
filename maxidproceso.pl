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
    
    #print("host ", $hos);
    #print("db  ", $db);
    #print("user ", $user);
    #print("password ", $password);
    
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

sub maxIdproceso()
{
	$conexion=$_[1-1];
	$criterio=$_[2-1];
	
	if ($criterio eq "U" || $criterio eq "u")
	{
		$query="select DISTINCT idproceso from usuarios";
	}
	else
	{
		$query="select DISTINCT idproceso from hashtag";
	}
	#printf "%s\n",$query;
	$resultado = $conexion->prepare($query);
	
	$resultado->execute();
	while (my $valorid = $resultado->fetchrow_array()) 
	{
		print "$valorid ";
	}
	$resultado->finish;
}
$tipo_criterio=$ARGV[1-1];

&carga_ini();
$db=&conecta_mysql();

&maxIdproceso($db,$tipo_criterio);



&close_mysql($db);

