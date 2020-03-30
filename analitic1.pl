use Encode;
use DBI;
use POSIX qw( isdigit );
use Config::Simple;



$, = "\t", $\ = "\n";

my %memo;
my %variablesini;

my $cuenta=0;
my $total=0;

sub  trim { 
	my $s = shift; 
	$s =~ s/^\s+|\s+$//g; 
	return $s 
};


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


	open(FD,"./cfg/noconsiderar.txt") or  die "no puedo abrir archivo ";
	while (<FD>)
	{
		chop;
		$nocontar{$_}=1;
	}
	close(FD);
	
	&carga_ini();
	
	$dbh=&conecta_mysql();

	#my $sql_data="select descTwits from twits where fechatwits > DATE_SUB(now(), INTERVAL 120 MINUTE)";
 	#my $sql_data="select descTwits,retwitscount+favoritecount from twits as t,usuarios as u where t.usuarios_nickName=u.nickName and u.monitoreo=1 and t.estado!=\"pub\" and fechatwits > DATE_SUB(now(), INTERVAL 120 MINUTE)";
	my $sql_data="select descTwits,retwitscount+favoritecount from twits_hashtag as t where t.estado!=\"pub\" and fechatwits > DATE_SUB(now(), INTERVAL 120 MINUTE)";

 	$twits = $dbh->prepare($sql_data);
	$twits->execute();
	$filtrado=0;
	$qpalabras=0;
	
	$desc_max="NIL";
	$memo{$desc_max}=0;
	while (my @desctwits = $twits->fetchrow_array()) 
	{
		@arr=split(/ /,$desctwits[0]);
		$pesotwits=$desctwits[1];
		$nelem=@arr;
		for ($i=0;$i < $nelem;$i++)
		{
			$qpalabras++;
			if (!isdigit($arr[$i]) and $arr[$i]!~"@" and $arr[$i]=~/^[a-zA-Z]+$/ and length($arr[$i])>3)
			{
				$desc_lowcase=lc $arr[$i];
				$desc_lowcase=trim($desc_lowcase);
				#printf "Analisis -> |%s|\n",$desc_lowcase;
				if (! exists($nocontar{$desc_lowcase}))
				{
					#$memo{$desc_lowcase}+=$pesotwits;
					$memo{$desc_lowcase}+=$qpalabras+$pesotwits;
					if ($q_max{$desc_max}<$memo{$desc_lowcase})
					{
						$desc_max=$desc_lowcase;
						$q_max{$desc_max}=$memo{$desc_lowcase};
					}
				}
				else
				{
					$filtrado++;
				}
			}
			else
			{
				$filtrado++;
			}	
		}
	}
	$twits->finish();
	
	
	
	printf "Analisis Twits %s : %.0f\n",$desc_max,$q_max{$desc_max};
	
	
	my $sql_exploara="update twits_hashtag set twits_hashtag.estado=\"pub\" where  twits_hashtag.estado!=\"pub\" and twits_hashtag.fechatwits > DATE_SUB(now(), INTERVAL 120 MINUTE) and twits_hashtag.descTwits like '%$desc_max%'";
   
    $twits_explo = $dbh->prepare($sql_exploara);
	$twits_explo->execute();
	
	printf("Se filtraron %.0f  de %0.f palabras\n",$filtrado,$qpalabras);
	
	
	&close_mysql($dbh);


