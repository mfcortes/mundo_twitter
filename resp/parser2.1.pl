use Net::Twitter;
use Data::Dumper;
use Encode;
use DBI;
use DB_File;
use DateTime;



$, = "\t", $\ = "\n";

my %memo;

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
	
	$subid=substr($key,length($key)-1);
	
	return $subid;
}

sub open_db()
{
	#$fecha=fecha_actual();
	
	
	for ($i=0;$i<=9;$i++)
	{
		$archivo_DB="Base_Twits_".$i.".db";
		tie(%memo[1], "DB_File", $archivo_DB, O_RDWR|O_CREAT, 0666, $DB_BTREE) || die "no puedo abrir arvchivo `mytree': $!";
	}	
}

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
	#$dbh->disconnect or warn "Disconnection error: $DBI::errstr\n";
}

sub close_mysql()
{
    #disconnect  from database
	$_[1-1]->disconnect or warn "Disconnection error: $DBI::errstr\n";
}


sub close_db()
{
	
	for ($i=0;$i<=9;$i++)
	{
		untie %memo[$i];
	}	
}

sub registraDB()
{
    $key=$_[1-1];
	$usuario=$_[2-1];
	$mensaje=$_[3-1];
	$connection=$_[4-1];
	
	$llave=$usuario."|".$key;
	$subid=&calcula_subid($key);
    if (!exists($memo[$subid]{$llave}))
	{
		
		$memo[$subid]{$llave}=$mensaje;
		$query = "insert into twits (idtwits,usuarios_nickName,estado,descTwits) values (\"$key\",\"$usuario\",\"ing\",\"$mensaje\")";
		$ingresa = $connection->prepare($query);

		# execute your SQL statement
		$ingresa->execute();
		$ingresa->finish;
	}
	else
	{
		printf "Registro Ya ingresado [%s]\n",$key;
	}
	
}





$dbh=&conecta_mysql();
&open_db();


$consumer_key = q(V3Q1Q7ykrYBbWSGkOnaW3Kcpw);
$consumer_secret = q(jCqbki4yZ2gB02B636cJn6zSPfcs40vtn8fxEE8s4EovJpgzgc);
$access_token = q(30951060-oYcBzn1d8btXcdRf1PNdw0QFBEa1QIJiVpqscnM3t);
$access_token_secret = q(do2VWuBoIzekZ0MjMflcFx3Mq1DzO2adBcx90B9XUMySc);

my $t = Net::Twitter->new(
    traits              => [qw/API::RESTv1_1/],
    consumer_key        => $consumer_key,
    consumer_secret     => $consumer_secret,
    access_token        => $access_token,
    access_token_secret => $access_token_secret,
);

    my $sql_usuarios="select nickName from usuarios";
	$statement = $dbh->prepare($sql_usuarios);
	# execute your SQL statement
	$statement->execute();
	
	while (@data = $statement->fetchrow_array()) 
	{
        my $user_name = "@".$data[0];
        print "ANALIZANDO \t$user_name\n";
         

		my $search_term = "from:$user_name";
		print "$search_term\n";
		my $result = $t->search($search_term, {lang => 'es', count => 500});

		#my $identity; 
		foreach my $status (@{$result->{'statuses'}}) 
		{
    		my $identity = $status->{id};              # Tweet ID
    		my $s = $status->{text};                # Tweeted Text
    		$s =~ s/[^[:ascii:]]+//g;               # Strip Non-ASCII Encoded Characters
    		&registraDB($status->{id},$status->{user}->{screen_name},$s,$dbh);
		}
	}	


&close_db();
&close_mysql($dbh);











