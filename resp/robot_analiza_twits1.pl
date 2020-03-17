use utf8;
use Encode;
use Scalar::Util 'blessed';
use Net::Twitter;
use Data::Dumper;
use DBI;
use DB_File;
use DateTime;
use Encode qw/encode_utf8/;
use Config::Simple;




$, = "\t", $\ = "\n";

my %memo;
my %variablesini;


sub  trim { 
	my $s = shift; 
	$s =~ s/^\s+|\s+$//g; 
	return $s 
};


sub fecha_actual()
{
  $dt = DateTime->new(
      year       => 1964,
      month      => 10,
      day        => 16,
      hour       => 16,
      minute     => 12,
      second     => 47,
      nanosecond => 500000000,
  );

  $dt = DateTime->now; # same as ( epoch => time() )

  $ymd = $dt->ymd;           # 2002-12-06
  
  return $ymd;
} 

sub calcula_subid()
{
	$key=$_[1-1];
	
	$subid=substr($key,length($key)-2);
	
	return $subid;
}

sub esRT()
{
	$str_analisis=trim($_[1-1]);
	
	if ($str_analisis =~/^RT /)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}



sub registraTwits()
{
	$connection=$_[1-1];
	
	$consumer_key = q(eVHwpP1pdCxoViQxL6XK9TaN5);
	$consumer_secret = q(nriMp2IFvQ2WlwEHOERVulgUCu8xwVrkGEAABexmIDWZ3QNaio);
	$access_token = q(3234203725-U41dyNuq3ea1xYl5rSciUsz8gDeQFWutMfdw0ju);
	$access_token_secret = q(YSuXIswRLik34cOg7V951XbziqMBjbQFeVR71f0AroUDu);

	my $t = Net::Twitter->new(
    	traits              => [qw/API::RESTv1_1/],
    	consumer_key        => $consumer_key,
    	consumer_secret     => $consumer_secret,
    	access_token        => $access_token,
    	access_token_secret => $access_token_secret,
	);

	#$query = "select idtwits, descnvotwits from twits where estado=\"apub\"";
	#Se armo especialmente para Huelga entel 
	#$query = "select idtwits, descTwits from twits as t,usuarios as u where t.usuarios_nickName=u.nickName and u.monitoreo=1 and  descTwits like \"%copa%\" and estado!=\"pub\" and errorpublicar is null";
	
	$query = "select idtwits, descTwits from twits as t,usuarios as u where t.usuarios_nickName=u.nickName and u.monitoreo=1 and t.estado=\"pub\" and errorpublicar is null";
	
	
	$sth = $connection->prepare($query);
	
	# execute your SQL statement
	$sth->execute();
	
	while (my $ref = $sth->fetchrow_hashref()) 
	{
		my $s=$ref->{'descTwits'};
		my $id=$ref->{'idtwits'};
		
		#$s =~ s/[^[:ascii:]]+//g;      # Strip Non-ASCII Encoded Characters
    	#$s =~ s/"/\\"/g;               # Strip Non-ASCII Encoded Characters
    	#$s =~ s/'/\\'/g;               # Strip Non-ASCII Encoded Characters
    	$s=&trim($s);
    	if (&esRT($s) == 1)
    	{
    		$posi_chr=index($s,":");
    		$s=substr($s,$posi_chr+1);
    	}
    	
    	$largo_str=length($s);
    	$marca="#HAL ";
    	if ($largo_str<100-length($marca))
    	{
    	   $s=$marca.$s;
    	}
    	#$s = encode('utf-8',$s);
    	printf("Postea %s: [%s] : %d\n",$id,$s,$largo_str);
    	
    	my $result = $t->update($s);
    	if ( my $err = $@ ) {
      		print "Error de Twits [$err ]\n	";
     		die $@ unless blessed $err && $err->isa('Net::Twitter::Error');
     		$query = "update twits set estado=\"ing\", errorpublicar=1 where idtwits=\"$id\"";
			#printf "Actualiza estado Twits en tabla [%s]\n",$query;
			$sth_update = $connection->prepare($query);
			$sth_update->execute();
			$sth_update->finish;
			
		}
		else
		{
			$query = "update twits set estado=\"twt\", errorpublicar=0 where idtwits=\"$id\"";
			#printf "Actualiza estado Twits en tabla [%s]\n",$query;
			$sth_update = $connection->prepare($query);
			$sth_update->execute();
			$sth_update->finish;
		}
    	
	}
	$sth->finish;
		
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
	#$dbh->disconnect or warn "Disconnection error: $DBI::errstr\n";
}

sub close_mysql()
{
    #disconnect  from database
	$_[1-1]->disconnect or warn "Disconnection error: $DBI::errstr\n";
}


$dbh=&conecta_mysql();
&registraTwits($dbh);
&close_mysql($dbh);











