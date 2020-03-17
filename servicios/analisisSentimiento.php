<?php
	require_once("conexionBD.php");
	
	class insertaStimientos
    {
        
        public $numtrx;
        
        function __construct($conexion)
        {
            $this->conexion=$conexion;
            $numtrx=0;
        }
        

		public function analisisSentimiento($tempMensaje)
		{
			$curl = curl_init();

			curl_setopt_array($curl, array(
  				CURLOPT_URL => "http://api.meaningcloud.com/sentiment-2.1",
  				CURLOPT_RETURNTRANSFER => true,
  				CURLOPT_ENCODING => "",
  				CURLOPT_MAXREDIRS => 10,
  				CURLOPT_TIMEOUT => 30,
  				CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
  				CURLOPT_CUSTOMREQUEST => "POST",
  				CURLOPT_POSTFIELDS => "key=03251e2ff7438ac2c5d99409f5648180&lang=es&txt=$tempMensaje&model=general",
  				CURLOPT_HTTPHEADER => array("content-type: application/x-www-form-urlencoded"),
			));
		

			$response = curl_exec($curl);
			$err = curl_error($curl);

			curl_close($curl);

			if ($err) {
  				echo "cURL Error #:" . $err;
			} else {
  				#echo $response;
  				$array = json_decode($response);
  				return array ($array->score_tag, $array->confidence );
  			}
		}
        
        public function inserta()
        {
        
        	$strSql="select idtwits,descTwits from twits_hashtag where (analisissent is null or analisissent=0) order by fechainsert desc limit 1500";
        
        	#echo $strSql;
        	$row=$mysqli->query($strSql,$this->conexion);
       		
       		while ($elemento = mysql_fetch_row($row))
          	{
				$id_mensaje=$elemento[0];
				$desc_mensaje=$elemento[1];
				
				#echo "--> $desc_mensaje <br>";
				list ($sentimiento,$certesa)=$this->analisisSentimiento($desc_mensaje);
				
				#echo "$sentimiento|$certesa";
				
				$salida1=preg_replace ( '/"/','/\"/', $sentimiento);
           		$salida2=preg_replace ( "/'/","/\'/",$salida1);
           
				$strSQL="update twits_hashtag SET analisissent=1,sentimiento='$salida2',certsentimiento=$certesa where idtwits='$id_mensaje'";
				
				$estado_accion=$mysqli->query($strSQL,$this->conexion);
           		$numtrx++;
				//echo "$estado"."@"."<br>";	
          	} 
          	
        
        	 
            #echo "$strSQL";
      
           # $estado_accion=mysql_query($strSQL,$this->conexion);
            #header('Location: CuentaNodos.php');
           return $numtrx;
        }
        
        function __destruct()
		{
            if ($this->conexion)
            {
                mysql_close($this->conexion);
            }
            return true;
		}

    }
	$archivo_ini="twitter.ini";
	
	$array_ini = parse_ini_file($archivo_ini, true);
	
	$host=$array_ini["mysql"]["host"];
	$base=$array_ini["mysql"]["basename"];
	$user=$array_ini["mysql"]["user"];
	$pasword=$array_ini["mysql"]["password"];


	$oConexionDB=new conexionDBmysql($host,$user,$pasword,$base);
    
    $regularizaSentimientos = new insertaStimientos($oConexionDB->conexion);
    
 	$num_q=$regularizaSentimientos->inserta();
 	echo "Proceso terminado Se regularizaron <br>";
 	echo $num_q;
 	echo "<br>Registros <br>";

?>