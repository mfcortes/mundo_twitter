<?php
	require_once("conexionBD.php");
	
		
	class opinion
    {
        public $numtrx;
        function __construct($conexion)
        {
            $this->conexion=$conexion;
            $numtrx=0;
        }
      	
		public function consulta($tempLlave)
		{
		
			if ($tempLlave!="")
			{
				$strSql="select sentimiento,count(*) from twits_hashtag where hashtag_hashtag='$tempLlave' and analisissent=1 and certsentimiento>95 group by sentimiento";
        	
        	}
        	else
        	{
        		$strSql="select  DISTINCT hashtag_hashtag from twits_hashtag";
        	}
        	#echo $strSql;
        	
        	$row=mysql_query($strSql,$this->conexion);
       	
       		$rawdata = array();
       		$qreg=0;	
       		
       		while ($elemento = mysql_fetch_row($row))
          	{
          		 $rawdata[$qreg] = $elemento;
          		 $qreg++;         		
          	}
          	if ($qreg!=0)
          	{     
          		echo json_encode($rawdata);
          	}
          	else
          	{
          		echo json_encode("Error no existe Data");
          	}	
	    }
	}
	
	$tAccion=$_GET['tipoAccion'];
	$archivo_ini="twitter.ini";
	
	$array_ini = parse_ini_file($archivo_ini, true);
	
	$host=$array_ini["mysql"]["host"];
	$base=$array_ini["mysql"]["basename"];
	$user=$array_ini["mysql"]["user"];
	$pasword=$array_ini["mysql"]["password"];
	
	$oConexionDB=new conexionDBmysql($host,$user,$pasword,$base);
    
	#$oConexionDB=new conexionDBmysql("localhost","lacuarta","lacuarta","twitlacuarta");
    
    $analisisSentimientos = new opinion($oConexionDB->conexion);
    
 	$analisisSentimientos->consulta($tAccion);
 	
?>