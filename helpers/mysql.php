<?php
class Mysql_Driver
{
    /**
     * Connection holds MySQLi resource
     */
    private $connection;

    /**
     * Create new connection to database
     */ 
    public function connect()
    {
		//connection parameters

		// Using MAMP Settings
        $host = 'localhost:8889';
        $user = 'root';
        $password = 'root';
		$database = 'ict_open_house'; 
		
		/*
		// Using XAMPP Settings
		$host = 'localhost';
        $user = 'root';
        $password = '';
		$database = 'ict_open_house'; 
		*/

        $this->connection = mysqli_connect($host, $user, $password, $database);
		if (mysqli_connect_errno($this->connection))
  		{
 		    //echo "Failed to connect to MySQL: " . mysqli_connect_error();
			trigger_error("Failed to connect to MySQL: " . mysqli_connect_error());
  		} 
    }

    public function close()
	{
        mysqli_close($this->connection);     
	}

    public function query($qry, ...$params)
	{
		$result = "";

		$stmt = mysqli_stmt_init($this->connection);

		if (!mysqli_stmt_prepare($stmt, $qry)) {
			trigger_error("Failed to prepare Stmt Query");
			
		} else {
			$stringTypes = "";
			$type = "";

			foreach($params as $param) {
				if (is_string($param)) {
					$type = "s";
				} else if (is_int($param)) {
					$type = "i";
				} else if (is_double($param)) {
					$type = "d";
				}

				$stringTypes .= $type;
			}
			if (sizeof($params)) {
				mysqli_stmt_bind_param($stmt, $stringTypes , ...$params);
			}

			if (!mysqli_stmt_execute($stmt)) {
				trigger_error("Query Failed SQL: $qry - Stmt Error: " . htmlspecialchars($stmt->error));
			}

			if (mysqli_stmt_affected_rows($stmt) > 0) {
				$result = true;
			} else {
				$result = mysqli_stmt_get_result($stmt);
			}
			return $result;
		}
		xdebug_enable();
	}
	
	public function num_rows($result)
	{
		return mysqli_num_rows($result);
	}
	
	public function fetch_array($result)
	{
		return mysqli_fetch_array($result);
	}
	
}
?>
