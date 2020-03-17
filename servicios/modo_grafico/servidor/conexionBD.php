<?php

abstract class cElementosConexionDB
{
	// Creamos una Clase Abstracta para que sea utilizadas por clase de conexion a DB
	// y no sea instanciada por un objeto	
	protected $dbhost;
	protected $dbusuario;
	protected $dbpasword;
	protected $db;
	public $conexion;
	//public $resSql;
		
	//metodo abstracto para que se tenga que construir para cada clase a la cual se erede esta clase Abstracta
	//cada base de datos debe definir su conexion a la base datos
	
	abstract function conectaDB();
	abstract function cierraDB();
}




class conexionDBmysql extends cElementosConexionDB
{
	function __construct($host,$usuario,$clave,$base)
	{
		$this->dbhost=$host;
		$this->dbusuario=$usuario;
		$this->dbpasword=$clave;
		$this->db=$base;
		$this->conectaDB();
		
		return true;
	}
	
	function conectaDB()
	{
		$this->conexion=mysql_connect($this->dbhost , $this->dbusuario, $this->dbpasword);
		if ($this->conexion)
		{
			mysql_select_db($this->db, $this->conexion)  or die ("Verifique la Base de Datos");
		}	
		else
		{
			die('No pudo conectarse: ' . mysql_error());
		}

		
	}
	
	
	
	function cierraDB()
	{
		mysql_close($this->conexion);
	}
	
}
?>