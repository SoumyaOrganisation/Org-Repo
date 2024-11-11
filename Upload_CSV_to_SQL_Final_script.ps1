$csvFilePath="C:\Users\Soumya\Downloads\logs_2024-10-22.csv"
$serverName = "4.240.50.82"
$databaseName = "web_logs"
$tableName = "log_table"
$username = "adminuser"
$password = "Admin@123456"


# Create a SQL connection
[void][system.reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\MySql.Data.dll")
$Connection = New-Object -TypeName MySql.Data.MySqlClient.MySqlConnection
$connection.ConnectionString = "Server=$serverName;Database=$databaseName;User Id=$username;Password=$password;"
$connection.Open()


# Read CSV file
$csvData = Import-Csv -Path $csvFilePath

# Insert data into MySQL
foreach ($row in $csvData) {
    $query = "INSERT INTO $tableName (Date,Unique_Session_ID,mail_ID,Login_Status,Failure_Reason,Services_Opted,Active_Session_Time,Server_Status,Additional1,Additional2,Additional3,Additional4,Additional5,Additional6,Additional7,Additional8,Additional9,Additional10,Additional11,Additional12,Additional13,Additional14,Additional15) VALUES ('$($row.Date)','$($row.Unique_Session_ID)','$($row.mail_ID)','$($row.Login_Status)','$($row.Failure_Reason)','$($row.Services_Opted)','$($row.Active_Session_Time)','$($row.Server_Status)','$($row.Additional1)','$($row.Additional2)','$($row.Additional3)','$($row.Additional4)','$($row.Additional5)','$($row.Additional6)','$($row.Additional7)','$($row.Additional8)','$($row.Additional9)','$($row.Additional10)','$($row.Additional11)','$($row.Additional12)','$($row.Additional13)','$($row.Additional14)','$($row.Additional15)')"
    $command = $connection.CreateCommand()
    $command.CommandText = $query

    # Add parameters
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@date", $row.Date)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Unique_Session_ID", $row.Unique_Session_ID)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@mail_ID", $row.mail_ID)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Login_Status", $row.Login_Status)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Failure_Reason", $row.Failure_Reason)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Services_Opted", $row.Services_Opted)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Active_Session_Time", $row.Active_Session_Time)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Server_Status", $row.Server_Status)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional1", $row.Additional1)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional2", $row.Additional2)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional3", $row.Additional3)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional4", $row.Additional4)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional5", $row.Additional5)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional6", $row.Additional6)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional7", $row.Additional7)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional8", $row.Additional8)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional9", $row.Additional9)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional10", $row.Additional10)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional11", $row.Additional11)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional12", $row.Additional12)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional13", $row.Additional13)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional14", $row.Additional14)))
    $command.Parameters.Add((New-Object MySql.Data.MySqlClient.MySqlParameter("@Additional15", $row.Additional15)))

    $command.ExecuteNonQuery()
}

# Close MySQL connection
$connection.Close()
