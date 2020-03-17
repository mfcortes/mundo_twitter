<?php
	
	require_once("conexionBD.php");
	
	class recuperaData extends conexionDBmysql
	{
	   function __construct()
       {
            //$this->idEmpresa=$idEmpresa;
            parent::__construct("localhost","lacuarta","lacuarta","twitlacuarta");
       }
      
      
      
       function consulta2Columnas($tempSql,$nomreTipoAgrupacion,$nombreSerie,$limiteColumnas = 0)
       {
       		$row=mysql_query($tempSql,$this->conexion);
       		
       		if ($limiteColumnas==0)
       		{
       			$limiteColumnas=mysql_num_rows($row);
       		}
       		$i=0;
       		$arr_retorno[0]['name']=$nomreTipoAgrupacion;
       		$arr_retorno[1]['name']=$nombreSerie;
       		while ($elemento = mysql_fetch_row($row))
          	{
				$qElementos=$elemento[0];
            	$grupo=trim($elemento[1]);
            	if ($i<$limiteColumnas )
            	{
            		$arr_retorno[0]['data'][$i]=$grupo;
            		$arr_retorno[1]['data'][$i]=$qElementos/1;
            	}	
            	$i++;
          	} 
          	// Se debuelven datos
          		
            $retorno_data=json_encode($arr_retorno);
          	unset($arr_retorno);
          	return $retorno_data;
       }
       
       
            
       
       function consulta3Columnas($tempSql,$nomreTipoAgrupacion,$nombreSerie)
       {
       		
       
       		$row=mysql_query($tempSql,$this->conexion);
       		$data=array();
       		
       		$i=0;
       		$tiposEstados=array();
			$fAgrupacion=array();
			while ($elemento = mysql_fetch_row($row))
          	{
				$qElementos=$elemento[0];
            	$estado=trim($elemento[1]);
            	$fechaAgrupacion=trim($elemento[2]);
            	//$elem[$fechaAgrupacion][$estado] += $qElementos;
            	isset($elem[$fechaAgrupacion][$estado]) ? $elem[$fechaAgrupacion][$estado] += $qElementos : $elem[$fechaAgrupacion][$estado] = $qElementos;
            	$tiposEstados[$estado]=$estado;
            	$fAgrupacion[$fechaAgrupacion]=$fechaAgrupacion;
            	$i++;
            	//echo "$estado"."@"."<br>";	
          	} 
          	
          	//OPTIMIZAR
          	$arr_retorno[0]['name']=$nomreTipoAgrupacion;
          	$k=0;
          	foreach ($fAgrupacion as $elemFecha)
          	{
          		$arr_retorno[0]['data'][$k]=$elemFecha;
          		$k++;
          	}
          	//OPTIMIZAR
          	
          	$j=1;
          	foreach ($tiposEstados as $elemEstado)
          	{
          		$arr_retorno[$j]['name']=$elemEstado;
          		$arreglo_data=array();
          		
          		$k=0;
          		foreach ($fAgrupacion as $elemFecha)
          		{
          			if (isset($elem[$elemFecha][$elemEstado]))
          			{
          				$valor=$elem[$elemFecha][$elemEstado];
          			}
          			else
          			{
          				$valor=0;
          			}
          			$arreglo_data[$k]=$valor/1;
          			$k++;
          			
          		}
          		$arr_retorno[$j]['data']=$arreglo_data;
          		$j++;         		
          	}
          	
          	
          	          	
          	$retorno_data=json_encode($arr_retorno);
          	unset($arr_retorno);
          	unset($fAgrupacion);
          	unset($tiposEstados);
          	return $retorno_data;

       }
       	
       
       function generaExcel($tempSql,$nombreArchivo)
       {
       
       		$row=mysql_query($tempSql,$this->conexion);
       		
       		header('Content-type: application/vnd.ms-excel');
			header("Content-Disposition: attachment; filename=trabajo.xls");
			header("Pragma: no-cache");
			header("Expires: 0");

			echo "<table cellspacing='0' cellpadding='0'>";
       		while ($elemento = mysql_fetch_row($row))
          	{
          		echo "<tr>";
          		for ($i=0;$i<count($elemento);$i++)
          		{
          			echo "<td>$elemento[$i]</td>";
          		}
          		echo "</tr>";
			}
			echo "</table>";
			
       }
       
       function Hconsulta3Columnas($tempSql,$nomreTipoAgrupacion,$nombreSerie)
       {
       		
       
       		$row=mysql_query($tempSql,$this->conexion);
       		$data=array();
       		
       		$i=0;
       		$tiposEstados=array();
			$fAgrupacion=array();
			while ($elemento = mysql_fetch_row($row))
          	{
				$qElementos=$elemento[0];
            	$estado=trim($elemento[1]);
            	$fechaAgrupacion=trim($elemento[2]);
            	//$elem[$fechaAgrupacion][$estado] += $qElementos;
            	isset($elem[$fechaAgrupacion][$estado]) ? $elem[$fechaAgrupacion][$estado] += $qElementos : $elem[$fechaAgrupacion][$estado] = $qElementos;
            	$tiposEstados[$estado]=$estado;
            	$fAgrupacion[$fechaAgrupacion]=$fechaAgrupacion;
            	$i++;
            	//echo "$estado"."@"."<br>";	
          	} 
          	
          	//OPTIMIZAR
          	$arr_retorno[0]['name']=$nomreTipoAgrupacion;
          	$k=0;
          	foreach ($fAgrupacion as $elemFecha)
          	{
          		$arr_retorno[0]['data'][$k]=$elemFecha;
          		$k++;
          	}
          	//OPTIMIZAR
          	
          	$j=1;
          	foreach ($tiposEstados as $elemEstado)
          	{
          		$arr_retorno[$j]['name']=$elemEstado;
          		$arreglo_data=array();
          		
          		$k=0;
          		foreach ($fAgrupacion as $elemFecha)
          		{
          			if (isset($elem[$elemFecha][$elemEstado]))
          			{
          				$valor=$elem[$elemFecha][$elemEstado];
          			}
          			else
          			{
          				$valor=0;
          			}
          			$arreglo_data[$k][0]=($elemFecha.'000')/1;
          			$arreglo_data[$k][1]=$valor/1;
          			$k++;
          			
          		}
          		$arr_retorno[$j]['data']=$arreglo_data;
          		$arr_retorno[$j]['tooltip']['valueDecimals']=2;
          		$j++;         		
          	}
          	
          	
          	          	
          	$retorno_data=json_encode($arr_retorno);
          	unset($arr_retorno);
          	unset($fAgrupacion);
          	unset($tiposEstados);
          	return $retorno_data;

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
    $tAccion=$_GET['tipoAccion'];
    $despliege=$_GET['grafOdespliege'];
	
    	
    $graficaData = new recuperaData();
    $valTime=time();
	$agnoMesActual= date("Ym", $valTime);
    
   
   
    
    switch ($tAccion)
    {
    	case "graftwitfecha":
    			//$salida=$graficaData->qTipoAgrupacionesG1();
    			$strSQL="select count(*),usuarios_nickName,date_format(fechatwits,'%Y%m%d') AS agnomes 
       					from twits where EXTRACT(YEAR_MONTH FROM fechatwits)>=201601
       					group by usuarios_nickName,agnomes order by agnomes";

 				$nombreSerie='Twits por Dia';
            	$tipo='Fecha';
            	$salida=$graficaData->consulta3Columnas($strSQL,$tipo,$nombreSerie);
            	
            	
    		break;
    	case "graftwit":
    		$strSQL="select count(*) as cantidad, usuarios_nickName from twits group by usuarios_nickName order by cantidad desc";
 			$nombreSerie='Agrupa Twits';
            $tipo='Twits Generados';		 
    		//$salida=$graficaData->qTipoAgrupacionesG2();
    		$salida=$graficaData->consulta2Columnas($strSQL,$tipo,$nombreSerie,20);
    		break;	
    		
    	case "grafhastag":
    		$strSQL="select count(*) as cantidad, hashtag_hashtag from twits_hashtag group by hashtag_hashtag order by cantidad desc";
 			$nombreSerie='Agrupa Twits';
            $tipo='Twits Generados';		 
    		$salida=$graficaData->consulta2Columnas($strSQL,$tipo,$nombreSerie,20);
    		break;	
    	
    	#CASOS NO USADOS	
    	case "sla3":
    		$strSQL="select count(*) as cantidad, r.gerencia from incidentes i, resolutores r where 
       				 EXTRACT(YEAR_MONTH FROM i.fecha_creacion)>=201201 and (i.estado='Cerrado' or i.estado='Resuelto')
              		 and i.grupo = r.id_grupo and i.tiempo_solucion*24 <= r.maxola and maxola!=0.0
              		 group by r.gerencia order by cantidad desc";
            $nombreSerie='Incidente Resueltos';
            $tipo='gerencia';
            $salida=$graficaData->consulta2Columnas($strSQL,$tipo,$nombreSerie);
            break;
    	case "sla4":
    		$strSQL="select count(*) as cantidad, r.gerencia from incidentes i, resolutores r where 
              		 EXTRACT(YEAR_MONTH FROM i.fecha_creacion)>=201201 	
              		 and (i.estado='Cerrado' or i.estado='Resuelto')
         			 and i.grupo = r.id_grupo and i.tiempo_solucion*24 > r.maxola and maxola!=0.0
         			 group by r.gerencia order by cantidad desc;";
         	$nombreSerie='Incidentes Cerrados';
         	$tipo='grupos';
         	$salida=$graficaData->consulta2Columnas($strSQL,$tipo,$nombreSerie);
         	break;
    	case "sla5":
    		$strSQL="select count(*) as cantidad, r.gerencia from incidentes i, resolutores r where 
              		 EXTRACT(YEAR_MONTH FROM i.fecha_creacion)>=201201 	
              		 and (i.estado!='Cerrado' and i.estado!='Resuelto' and i.estado!='Cancelado')
         			 and i.grupo = r.id_grupo and i.tiempo_solucion*24 >= r.maxola and maxola!=0.0
         			 group by r.gerencia order by cantidad desc;";
         	$nombreSerie='Incidentes Pendientes';
         	$tipo='gerencia';
         	$salida=$graficaData->consulta2Columnas($strSQL,$tipo,$nombreSerie);

    		break;
    	case "sla6":
    		$strSQL="select count(*) as cantidad, r.gerencia from incidentes i, resolutores r where 
              		 EXTRACT(YEAR_MONTH FROM i.fecha_creacion)>=201201 	
              		 and (i.estado!='Cerrado' and i.estado!='Resuelto' and i.estado!='Cancelado')
         			 and i.grupo = r.id_grupo and i.tiempo_solucion*24 < r.maxola and maxola!=0.0
         			 group by r.gerencia order by cantidad desc";
         	$nombreSerie='Incidentes Pendientes Cumplen SLA';
         	$tipo='gerencia';
         	$salida=$graficaData->consulta2Columnas($strSQL,$tipo,$nombreSerie);
			break;
		case "sla7":
			$strSQL="select round(avg(tiempo_solucion*24),2) promedio, grupo from incidentes i, resolutores r 
                     where i.grupo=r.id_grupo 
                     and EXTRACT(YEAR_MONTH FROM i.fecha_creacion) > 201201 
                     and r.maxola!=0.00 and (i.estado!='Cerrado' and i.estado!='Resuelto')
	                 group by grupo order by promedio desc";	
    		$nombreSerie='Incumplimiento SLA';
         	$tipo='grupo';
         	$salida=$graficaData->consulta2Columnas($strSQL,$tipo,$nombreSerie,20);
			break;
			
		case "sla8":
			$strSQL="select count(*) as cant ,i.grupo, EXTRACT(YEAR_MONTH FROM fecha_creacion) AS agnomes 
      			from (select count(*) as cantidad, i2.grupo from incidentes i2 where i2.estado!='Cerrado' 
                										and i2.estado!='Resuelto' 
                										and i2.fecha_creacion!='0000-00-00 00:00:00'
                										and EXTRACT(YEAR_MONTH FROM i2.fecha_creacion) > 201201
                										group by i2.grupo
                										order by cantidad desc limit 7) A
                										, incidentes i where 
               	 	i.grupo = A.grupo
                and i.estado!='Cerrado' 
                and i.estado!='Resuelto' 
                and i.fecha_creacion!='0000-00-00 00:00:00'
                and EXTRACT(YEAR_MONTH FROM i.fecha_creacion) > 201201
                group by i.grupo,agnomes order by agnomes, cant desc";
 			$nombreSerie='TOP 7 Grupos, Incidentes Abiertos por Mes';
         	$tipo='Fecha';
         	$salida=$graficaData->consulta3Columnas($strSQL,$tipo,$nombreSerie);
			break;
			
		case "sla9":
			$strSQL="select round(avg(tiempo_solucion*24),1) promedio ,i.grupo, EXTRACT(YEAR_MONTH FROM fecha_creacion) AS agnomes 
      			from (select round(avg(tiempo_solucion*24),1) promedio2, i2.grupo from incidentes i2, resolutores r2 where i2.estado!='Cerrado' 
                										and i2.estado!='Resuelto' 
                										and i2.fecha_creacion!='0000-00-00 00:00:00'
                										and EXTRACT(YEAR_MONTH FROM i2.fecha_creacion) > 201201
                										and i2.grupo=r2.id_grupo
                										and r2.maxola!=0.00
                										group by i2.grupo
                										order by promedio2 desc limit 5) A
                										, incidentes i, resolutores r where 
               	 	i.grupo = A.grupo
               	and r.maxola!=0.00 	
                and i.estado!='Cerrado' 
                and i.estado!='Resuelto' 
                and i.fecha_creacion!='0000-00-00 00:00:00'
                and EXTRACT(YEAR_MONTH FROM i.fecha_creacion) > 201201
                group by i.grupo,agnomes order by agnomes, promedio desc";
            $nombreSerie='Incidentes Abiertos por Mes TOP 7 Tiempo';
         	$tipo='Fecha';
         	$salida=$graficaData->consulta3Columnas($strSQL,$tipo,$nombreSerie);
			break;
			
		case "sla10":
			$strSQL="select count(*) as cantidad, 'cumplen sla' ,  r.gerencia 
					 from incidentes i, resolutores r 
						where 
    						EXTRACT(YEAR_MONTH FROM i.fecha_creacion)>=201201 
  						and (i.estado='Cerrado' or i.estado='Resuelto')
  						and i.grupo = r.id_grupo 
  						and i.tiempo_solucion*24 <= r.maxola 
  						and maxola!=0.0
  						group by r.gerencia
						union (
						select -count(*) as cantidad, 'no cumplen sla' , r.gerencia 
						from incidentes i, resolutores r 
						where 
    						EXTRACT(YEAR_MONTH FROM i.fecha_creacion)>=201201 	
  						and (i.estado='Cerrado' or i.estado='Resuelto')
  						and i.grupo = r.id_grupo 
  						and i.tiempo_solucion*24 > r.maxola 
  						and maxola!=0.0
  						group by r.gerencia) order by cantidad desc";		
		 	$nombreSerie='Incidentes Cerrados Complen sla vs No Cumplen SLA';
         	$tipo='Fecha';
         	$salida=$graficaData->consulta3Columnas($strSQL,$tipo,$nombreSerie);
			break;
		case "sla11":
			$strSQL2="select   tiempo_solucion*24, num_incidente
					 from incidentes i, resolutores r 
						where i.grupo=r.id_grupo
							and  date_sub(curdate(),interval 80 day) <= fecha_creacion
  							and i.tiempo_solucion*24 > r.maxola * 3 
  							and i.estado!='Cerrado' 
  							and i.estado!='Resuelto'";
			
			$strSQL="select   tiempo_solucion*24, concat(num_incidente,':',grupo,':',estado)
					 from incidentes i, resolutores r 
						where i.grupo=r.id_grupo
                and i.tiempo_solucion*24 > r.maxola 
                and r.maxola!= 0.00
  							and i.estado!='Cerrado' 
  							and i.estado!='Resuelto'";
			
			
			$nombreSerie='Incidentes No cumplen SLA';
         	$tipo='Fecha';
         	$salida=$graficaData->consulta2Columnas($strSQL,$tipo,$nombreSerie,50);		 
			break;
		case "sla12":
  			$strSQL="select -count(*) as cantidad, 'no cumplen sla' , r.id_grupo 
						from incidentes i, resolutores r 
						where 
    						EXTRACT(YEAR_MONTH FROM i.fecha_creacion)>=$agnoMesActual 	
  						and (i.estado='Cerrado' or i.estado='Resuelto')
  						and i.grupo = r.id_grupo 
  						and i.tiempo_solucion*24 > r.maxola 
  						and maxola!=0.0
              and r.id_grupo like '%EU%'
  						group by r.id_grupo
						union (
            select count(*) as cantidad, 'cumplen sla' ,  r.id_grupo 
            from incidentes i, resolutores r 
            where 
    						EXTRACT(YEAR_MONTH FROM i.fecha_creacion)>=$agnoMesActual 
  						and (i.estado='Cerrado' or i.estado='Resuelto')
  						and i.grupo = r.id_grupo 
  						and i.tiempo_solucion*24 <= r.maxola 
  						and maxola!=0.0
              and r.id_grupo like '%EU%'
              group by r.id_grupo
            
            ) order by cantidad desc";
            $nombreSerie='Incidentes Cerrados';
         	$tipo='grupos';
         	$salida=$graficaData->consulta3Columnas($strSQL,$tipo,$nombreSerie);
  			break;
  		
  			
  		case "Hsla1":
  			$strSQL="select count(*),estado,UNIX_TIMESTAMP(date_format(fecha_creacion,'%Y-%m-%d')) AS agnomes 
       				from incidentes 
       				where EXTRACT(YEAR_MONTH FROM fecha_creacion)>=201201
       				and estado in ( 'Pendiente','Asignado', 'En curso')
       				group by estado,agnomes order by agnomes";

 			$nombreSerie='NN';
            $tipo='Fecha';
            
    		$salida=$graficaData->Hconsulta3Columnas($strSQL,$tipo,$nombreSerie);
    		break;
	
		case "Hsla2":
  			$strSQL="select count(*),'Abiertos Total',UNIX_TIMESTAMP(date_format(fecha_creacion,'%Y-%m-%d')) AS agnomes 
       				from incidentes 
       				where EXTRACT(YEAR_MONTH FROM fecha_creacion)>=201201
       				and estado in ('Asignado','Pendiente', 'En curso')
       				group by agnomes order by agnomes";

 			$nombreSerie='NN';
            $tipo='Fecha';
            
    		$salida=$graficaData->Hconsulta3Columnas($strSQL,$tipo,$nombreSerie);
    		break;	
    	case "Hsla3":
  			$strSQL="select count(*),'Total Incidentes',UNIX_TIMESTAMP(date_format(fecha_creacion,'%Y-%m-%d')) AS agnomes 
       				from incidentes 
       				where EXTRACT(YEAR_MONTH FROM fecha_creacion)>=201201
       				group by agnomes order by agnomes";

 			$nombreSerie='NN';
            $tipo='Fecha';
            
    		$salida=$graficaData->Hconsulta3Columnas($strSQL,$tipo,$nombreSerie);
    		break;	
    	case "Hsla4":
  			$strSQL="select count(*),'Abiertos Total',UNIX_TIMESTAMP(date_format(fecha_creacion,'%Y-%m-%d')) AS agnomes 
       				from incidentes 
       				where EXTRACT(YEAR_MONTH FROM fecha_creacion)>=201201
       				and estado in ('Asignado','Pendiente', 'En curso')
       				group by agnomes order by agnomes";

 			$nombreSerie='NN';
            $tipo='Fecha';
            
    		$salida=$graficaData->Hconsulta3Columnas($strSQL,$tipo,$nombreSerie);
    		break;	
    	case "Msla1":
    		$strSQL="select count(*),estado from incidentes group by estado	";
       		$nombreSerie='General';
         	$tipo='General';
         	$salida=$graficaData->consulta2Columnas($strSQL,$tipo,$nombreSerie);		
  			break;

    	
    	
			
	}
    echo $salida;
    //$graficaData->cierraDB();
       
?>