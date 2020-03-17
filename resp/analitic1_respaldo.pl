use Encode;
use DBI;
use POSIX qw( isdigit );


$, = "\t", $\ = "\n";

my %memo;
my $cuenta=0;
my $total=0;

sub  trim { 
	my $s = shift; 
	$s =~ s/^\s+|\s+$//g; 
	return $s 
};


sub conecta_mysql()
{
	$db="twitlacuarta";
	$host="localhost";
	$user="lacuarta";
	$password="lacuarta";  # the root password
    
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


	open(FD,"noconsiderar.txt") or  die "no puedo abrir archivo ";
	while (<FD>)
	{
		chop;
		$nocontar{$_}=1;
	}
	close(FD);
	
	$dbh=&conecta_mysql();

	#my $sql_data="select descTwits from twits where fechatwits > DATE_SUB(now(), INTERVAL 120 MINUTE)";
 	my $sql_data="select descTwits,retwitscount+favoritecount from twits as t,usuarios as u where t.usuarios_nickName=u.nickName and u.monitoreo=1 and t.estado!=\"pub\" and fechatwits > DATE_SUB(now(), INTERVAL 20 MINUTE)";


 	$twits = $dbh->prepare($sql_data);
	$twits->execute();
	$filtrado=0;
	$qpalabras=0;
	
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
	
	
	
	printf "Analisis Twits\n";
	foreach my $name (sort { $memo{$a} <=> $memo{$b} } keys %memo) 
	{
    	printf "--->%s:  %.0f\n", $name, $memo{$name};
    	
    	if (0)
    	{
   	 	my $sql_exploara="select usuarios_nickName,descTwits from twits as t,usuarios as u where t.usuarios_nickName=u.nickName and u.monitoreo=1 and fechatwits > DATE_SUB(now(), INTERVAL 120 MINUTE) and descTwits like '%$name%'";
    	#printf "SQL |%s|\n",$sql_exploara;
      	$twits_explo = $dbh->prepare($sql_exploara);
	    $twits_explo->execute();
		
		my $mensaje_top = {};
    	
		while (my @desctwits_explo = $twits_explo->fetchrow_array()) 
		{
			$string_twits=$desctwits_explo[0].":".$desctwits_explo[1];
			$mensaje_top{$string_twits}++;
    	}
    	$twits_explo->finish();
    	
    	while ( my ($key_top, $value_top) = each(%mensaje_top) ) 
    	{
        	print "\t$key_top\n";
    	}
    	undef %mensaje_top;
		}
    	
    	
	}
	printf("Se filtraron %.0f  de %0.f palabras\n",$filtrado,$qpalabras);
	
	
	&close_mysql($dbh);


