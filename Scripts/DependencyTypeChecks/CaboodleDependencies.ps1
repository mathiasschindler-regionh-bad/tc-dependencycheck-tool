param (
    [string] $DMCName,
    [string] $ColumnName
)

Write-Host "**Caboodle Dependencies**"
Write-Host "Follow the steps:"
Write-Host "  1. Open the VDI"
Write-Host "  2. Open SQL Server Management Studio"
Write-Host "  3. Connect to the DEV Server"
Write-Host "  4. Run the query on the staging database to check for dependencies in *procedure data lineage*:`n"
Write-Host "     SELECT ProcedureDataDependencies_AllLocales.SourceTableName, 
                    ProcedureDataDependencies_AllLocales.SourceColumnName, 
                    ProcedureDataDependencies_AllLocales.TableEtlName, 
                    ProcedureDataDependencies_AllLocales.ProcedureName, 
                    ProcedureDataDependencies_AllLocales.ColumnName 
                FROM config.ProcedureDataDependencies_AllLocales 
                WHERE ProcedureDataDependencies_AllLocales.SourceTableName = '$DMCName'
                --AND ProcedureDataDependencies_AllLocales.SourceColumnName = '$ColumnName'
                
                UNION
                    
                SELECT ProcedureDataSources_AllLocales.SourceTableName, 
                    ProcedureDataSources_AllLocales.SourceColumnName, 
                    ProcedureDataSources_AllLocales.TableEtlName, 
                    ProcedureDataSources_AllLocales.ProcedureName, 
                    ProcedureDataSources_AllLocales.ColumnName 
                FROM config.ProcedureDataSources_AllLocales 
                WHERE ProcedureDataSources_AllLocales.SourceTableName = '$DMCName'
                --AND ProcedureDataSources_AllLocales.SourceColumnName = '$ColumnName'"

Write-Host "`nDependency-free criteria: If no text is printed"
Write-Host "(Press 'Enter' to proceed)"
Read-Host

Write-Host "  5. Run the query on the staging database to check for dependencies in *package data lineage*:`n"
Write-Host "     SELECT PackageDataSources_AllLocales.SourceTableName, 
                    PackageDataSources_AllLocales.SourceColumnName, 
                    PackageDataSources_AllLocales.TableEtlName, 
                    PackageDataSources_AllLocales.ColumnName 
                FROM Config.PackageDataSources_AllLocales 
                WHERE PackageDataSources_AllLocales.SourceTableName = '$DMCName'
                --AND PackageDataSources_AllLocales.SourceColumnName = '$ColumnName'

                UNION

                SELECT PackageDataDependencies_AllLocales.SourceTableName, 
                    PackageDataDependencies_AllLocales.SourceColumnName, 
                    PackageDataDependencies_AllLocales.TableEtlName, 
                    PackageDataDependencies_AllLocales.ColumnName 
                FROM Config.PackageDataDependencies_AllLocales 
                WHERE PackageDataDependencies_AllLocales.SourceTableName = '$DMCName'
                --AND PackageDataDependencies_AllLocales.SourceColumnName = '$ColumnName'"

Write-Host "`nDependency-free criteria: If no text is printed"
Write-Host "(Press 'Enter' to proceed)"
Read-Host