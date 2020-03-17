use Net::Twitter;
use Data::Dumper;
use DBI;
use DB_File;
use DateTime;
use Config::Simple;
use IO::Socket::SSL;
#use LWP::Protocol::https;

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

sub open_db()
{
	$numeroproceso=$_[1-1];
	$tipo_consulta=$_[2-1];
	
	$archivo_DB="./db_file/Base_Twits_".$tipo_consulta."_".$numeroproceso.".db";
	tie(%memo, "DB_File", $archivo_DB, O_RDWR|O_CREAT, 0666, $DB_BTREE) || die "no puedo abrir arvchivo `mytree': $!";

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
            	               
    $dbh->do('SET NAMES utf8');
	$dbh->{'mysql_enable_utf8'} = 1;        	               

	return $dbh;
}

sub close_mysql()
{
    #disconnect  from database
	$_[1-1]->disconnect or warn "Disconnection error: $DBI::errstr\n";
}


sub close_db()
{
	untie %memo;
}

sub registraDB()
{
    $key=$_[1-1];
	$criterio=$_[2-1];
	$mensaje=$_[3-1];
	$connection=$_[4-1];
	$fecha_at=$_[5-1];
	$q_retwits=$_[6-1];
	$es_retwits=$_[7-1];
	$favorite_count=$_[8-1];
	$nick_twitsoriginal=$_[9-1];
	$id_respuestatwitsoriginal=$_[10-1];
	$latitud_location=$_[12-1];
	$longitud_location=$_[11-1];
	$tipo_location=$_[13-1];
	$url_imagen=$_[14-1];
	$follower_count=$_[15-1];
	$tipo_consulta=$_[16-1];
	$user_twits=$_[17-1];
	
	
	
	$llave=$criterio."|".$key;
	
	#$flag_error=0;
	#if (length($mensaje)>120 || $mensaje =~/!/) 
	#{
	#	printf("[ANALISIS] [%s][%.0f]\n",$key,length($mensaje));
	#	print (Dumper(\$mensaje));
	#	$flag_error=1;
	#}
	
	#$datos_db=$fecha_at."|".$q_retwits."|".$es_retwits."|".$favorite_count."|". $nick_twitsoriginal."|".$id_respuestatwitsoriginal."|".$latitud_location."|".$longitud_location."|".$tipo_location."|".$url_imagen."|".$follower_count."|".$mensaje;
    
    #Se comento por que no se usan los datos del DB seria bueno sacar todo lo que no se usa 
    #Y dejar solo los cambios que se generaron en los q de retwits y en los q de favorite
    
	
	
	$datos_db=$fecha_at."|".$q_retwits."|".$es_retwits."|".$favorite_count."|".$nick_twitsoriginal;
    
    
    
    
    chomp($datos_db);
    $total++;
    #print "llave-DATA DB |$llave - $|$datos_db\n";
    if (!exists($memo{$llave}))
    {
		#inserta El NUevo Twits
		$memo{$llave}=$datos_db;
		if ($tipo_consulta eq "U" || $tipo_consulta eq "u")
		{
			$query = "insert into twits 	(idtwits,usuarios_nickName,estado,descTwits,fechatwits,esretwits,retwitscount,favoritecount,respuestatwitsoriginal,id_respuestatwitsoriginal,lat_loc,long_loc,type_loc,url_imagen,follower_count,fechainsert) values (\"$key\",\"$criterio\",\"ing\",\"$mensaje\",STR_TO_DATE(\"$fecha_at\",\"%a %b %d %H:%i:%s %Y\"),$es_retwits,$q_retwits,$favorite_count,\"$nick_twitsoriginal\",\"$id_respuestatwitsoriginal\",\"$latitud_location\",\"$longitud_location\",\"$tipo_location\",\"$url_imagen\",$follower_count,now())";
			#if ($flag_error==1)
			#{
			#	print (Dumper(\$query));
			#}
		}
		else
		{
			$query = "insert into twits_hashtag 	(id_user_twits,idtwits,hashtag_hashtag,estado,descTwits,fechatwits,esretwits,retwitscount,favoritecount,respuestatwitsoriginal,id_respuestatwitsoriginal,lat_loc,long_loc,type_loc,url_imagen,follower_count,fechainsert) values (\"$user_twits\",\"$key\",\"$criterio\",\"ing\",\"$mensaje\",STR_TO_DATE(\"$fecha_at\",\"%a %b %d %H:%i:%s %Y\"),$es_retwits,$q_retwits,$favorite_count,\"$nick_twitsoriginal\",\"$id_respuestatwitsoriginal\",\"$latitud_location\",\"$longitud_location\",\"$tipo_location\",\"$url_imagen\",$follower_count,now())";
		
		}
		#printf "%s\n",$query;
		$ingresa = $connection->prepare($query);

		# execute your SQL statement
		$ingresa->execute();
		$ingresa->finish;
	}
	else
	{
		#Registro ya existe pero si tiene RT se updatea el Q de RT
		@arr_data=split(/\|/,$memo{$llave});
		$q_retEnDB=$arr_data[2-1];
		$q_favoriteCount=$arr_data[4-1];
		if ($q_retwits!=$q_retEnDB || $favorite_count!=$q_favoriteCount)
		{
			printf "Registro Ya ingresado [%s] y con DIFERENTE numero de Retwits [%d -> %d] o Favorite Count [%d -> %d]\n",$key,$q_retEnDB,$q_retwits,$q_favoriteCount,$favorite_count;
			$memo{$llave}=$datos_db;
			$query = "update twits SET retwitscount=$q_retwits,favoritecount=$q_favoriteCount where idtwits=\"$key\"";
			$ingresa = $connection->prepare($query);

			# execute your SQL statement
			$ingresa->execute();
			$ingresa->finish;
		}
		
	}
}



#MAIN
$idProceso=$ARGV[1-1];
$consumer_key =$ARGV[2-1]; 
$consumer_secret = $ARGV[3-1];
$access_token = $ARGV[4-1];
$access_token_secret = $ARGV[5-1];
$tipo_proceso= $ARGV[6-1]; #En esta opcion se especifica si es por Usuario o por Hashtag (U/T)

$numparam=@ARGV;




if ($numparam!=6)
{
	printf ("debe ingresar idproceso 1,2,3,4,...etc\n");
	printf ("debe ingresar Credenciales Twitter\n");
	
	exit 0;
}

#Se cargan variables de host y de Base datos
&carga_ini();

$dbh=&conecta_mysql();
&open_db($idProceso,$tipo_proceso);


#$consumer_key = q(75H8kLNN1nVB10npFCRU9ARm5);
#$consumer_secret = q(9wHl7V9SDmO7UoQa6GLyFEh1ApsY3gNgvIfdltEYOucvmNDF3N);
#$access_token = q(30951060-gKq54u2hxfu14j1kT4BAgMiXpIVTAYFk8cd4vedQb);
#$access_token_secret = q(tZYd61T45yRtuAEgk2RKfLQLaypmGwwv22AfSJcDS45zl);

my $t = Net::Twitter->new(
    traits              => [qw/API::RESTv1_1/],
    consumer_key        => $consumer_key,
    consumer_secret     => $consumer_secret,
    access_token        => $access_token,
    access_token_secret => $access_token_secret,
);


	#my $result = $t->rate_limit_status();
	#print 'remaining-hits: '.$result->{remaining_hits};
    #print 'reset-time    : '.$result->{reset_time};

		
	if ($tipo_proceso eq 'U' || $tipo_proceso eq 'u')
	{
 		$sql_c="select nickName from usuarios where idproceso=$idProceso and monitoreo=1";
 	}
 	else
 	{
 		if ($tipo_proceso eq 'H' || $tipo_proceso eq 'h')
 		{
 			$sql_c="select desc_hashtag from hashtag where idproceso=$idProceso and monitoreo=1";
 		}
 		else
 		{
 			print "\n--->$tipo_proceso : Error en argumento tipo de criterio U|H";
 			exit 1;
 		}
 	}
 	
 	
 	
 		
 	$lista_consultar = $dbh->prepare($sql_c);
	# execute your SQL statement
	$lista_consultar->execute();
	# print "-------------> $sql_c \n";
	#print Dumper(\$lista_consultar);
	#Recuperamos el MaxID 
	
	
	while (my $param_consulta = $lista_consultar->fetchrow_array()) 
	{
		#print "BUSCANDO PARAM [$param_consulta]";
		if ($tipo_proceso eq "U" || $tipo_proceso eq "u")
		{
			#Consulta por Usuario
        	$search_term = "from:@".$param_consulta;
        }
        else
        {
        	#Consulta por hashtag
        	$search_term = "#".$param_consulta;
        }
        print "\nANALIZANDO $search_term \n";
         

		#my $search_term = $str_query; #from:$user_name";
		#my $result = $t->search($search_term, {lang => 'es', count => 100});
		my $result = $t->search($search_term, {lang => 'es', count => 300,include_rts =>1});
		

		#my $identity; 
		#print "************************************\n";
		#print Dumper(\@{$result->{'statuses'}});
		#print "************************************\n";
		foreach my $status (@{$result->{'statuses'}}) 
		{
			
			$p1_fecha=&trim(substr($status->{created_at},0,20));
			$p2_fecha=&trim(substr($status->{created_at},25));
			$fecha_fta=$p1_fecha." ".$p2_fecha;
        
            #my $tweet = $twitter->show_status($status->{'id'});
    		my $identity = $status->{id};              # Tweet ID
    		
    		my $s = $status->{text};       # Tweeted Text
    		
    		#$s =~ s/[^[:ascii:]]+//g;      # Strip Non-ASCII Encoded Characters
    		$s =~ s/"/\\"/g;               # Strip Non-ASCII Encoded Characters
    		#$s =~ s/'/\\'/g;               # Strip Non-ASCII Encoded Characters
    		#$s = encode('utf-8',$s);
    		#$s=encode_utf8($s);;
    		#printf "Salida -> [$s]\n";
    		$rt=&esRT($s);
    		
    		
			#$llave_tipo_consulta=$status->{user}->{screen_name}
    	
    		&registraDB($status->{id},$param_consulta,$s,$dbh,$fecha_fta,$status->{retweet_count},$rt,$status->{favorite_count},$status->{in_reply_to_screen_name},$status->{in_reply_to_status_id},$status->{coordinates}->{coordinates}[0],$status->{coordinates}->{coordinates}[1],$status->{coordinates}->{type},$status->{user}->{profile_image_url_https},$status->{user}->{followers_count},$tipo_proceso,$status->{user}->{screen_name});
    		
		}
	}
	$lista_consultar->finish();	
	&close_db();
	&close_mysql($dbh);











