param(
    [Parameter(Mandatory=$true)]
    $AzureSQLServerName, 
    [Parameter(Mandatory=$true)]
    $AzureSQLDatabaseName
)
 
$AzureSQLServerName = $AzureSQLServerName + ".database.windows.net"
$Cred = Get-AutomationPSCredential -Name 'ELEMOSDatabase'

$SQL = New-SqlQuery -CommandTimeout 65355 -Sql "ALTER DATABASE current SET COMPATIBILITY_LEVEL = 140"
$SQLOutput = $(Invoke-SqlServerQuery -ConnectionTimeout 60 -Credential $Cred -Database $AzureSQLDatabaseName -Server $AzureSQLServerName -SqlQuery $SQL) 4>&1
Write-Output $SQLOutput

$SQL = New-SqlQuery -CommandTimeout 65355 -Sql "ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = ON"
$SQLOutput = $(Invoke-SqlServerQuery -ConnectionTimeout 60 -Credential $Cred -Database $AzureSQLDatabaseName -Server $AzureSQLServerName -SqlQuery $SQL) 4>&1
Write-Output $SQLOutput

$SQL = New-SqlQuery -CommandTimeout 65355 -Sql "ALTER DATABASE current SET QUERY_STORE = ON"
$SQLOutput = $(Invoke-SqlServerQuery -ConnectionTimeout 60 -Credential $Cred -Database $AzureSQLDatabaseName -Server $AzureSQLServerName -SqlQuery $SQL) 4>&1
Write-Output $SQLOutput

$SQL = New-SqlQuery -CommandTimeout 65355 -Sql "exec [maintenance].[AzureSQLMaintenance] @Operation='all' ,@LogToTable=1"
$SQLOutput = $(Invoke-SqlServerQuery -ConnectionTimeout 60 -Credential $Cred -Database $AzureSQLDatabaseName -Server $AzureSQLServerName -SqlQuery $SQL) 4>&1
Write-Output $SQLOutput

