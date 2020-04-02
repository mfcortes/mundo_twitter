#use Encode;
use Scalar::Util qw/blessed/;
use Net::Twitter;
use Data::Dumper;
use DBI;
use DB_File;
use DateTime;
use Encode qw/decode encode_utf8 decode_utf8/;
use Config::Simple;
use IO::Socket::SSL;
use Try::Tiny;


$, = "\t", $\ = "\n";

my %memo;
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
	$consumer_key = $_[2-1];
	$consumer_secret = $_[3-1];
	$access_token = $_[4-1];
	$access_token_secret = $_[5-1] ;


	print "$consumer_key \n";
	print "$consumer_secret \n";
	print "$access_token \n";
	print "$access_token_secret \n";

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
	
	$query = "select idtwits, descTwits from twits_hashtag as t where t.estado=\"pub\" and (errorpublicar is null or errorpublicar=0)  ";
	
	print(Dumper($query));
	
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
		
		#$s = encode('utf-8',$s);
    	#$s=&trim($s);
		$s=Encode::encode("utf8", $s);
		$s=Encode::decode("utf8", $s);
    	
    	
    	#printf("Postea %s: [%s] : %d\n",$id,$s,$largo_str);
    	
		my $result = try {
			$t->update($s);
			$query = "update twits_hashtag set estado=\"twt\", errorpublicar=0 where idtwits=\"$id\"";
			#printf "Actualiza estado Twits en tabla [%s]\n",$query;
			$sth_update = $connection->prepare($query);
			$sth_update->execute();
			$sth_update->finish;
		}
		catch {
			die $_ unless blessed($_) && $_->isa('Net::Twitter::Error');
			
			printf("HTTP Response Code: %s\n", $_->code);
			printf("HTTP Message......: %s\n", $_->message);
         	printf("Twitter error.....: %s\n", $_->error);
         	#printf("Stack Trace.......: %s\n", $_->stack_trace->as_string);
     		$query = "update twits_hashtag set estado=\"err\", errorpublicar=1 where idtwits=\"$id\"";
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
        	                   $password,
     							{
         							mysql_enable_utf8 => 1
     							}) 
            	               or die "Can't connect to database: $DBI::errstr\n";

	return $dbh;
	#$dbh->disconnect or warn "Disconnection error: $DBI::errstr\n";
}

sub close_mysql()
{
    #disconnect  from database
	$_[1-1]->disconnect or warn "Disconnection error: $DBI::errstr\n";
}

$consumer_key =$ARGV[1-1]; 
$consumer_secret = $ARGV[2-1];
$access_token = $ARGV[3-1];
$access_token_secret = $ARGV[4-1];

&carga_ini();

$dbh=&conecta_mysql();
&registraTwits($dbh,$consumer_key,$consumer_secret,$access_token, $access_token_secret);
&close_mysql($dbh);











