#!/bin/bash
set -e

# Aguarde 60 segundos para o SQL Server iniciar, garantindo que
# chamar SQLCMD não retorna um código de erro, o que garantirá que o sqlcmd esteja acessível
# e que os bancos de dados do sistema e do usuário retornem "0", o que significa que todos os bancos de dados estão em um estado "online"
# https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-databases-transact-sql?view=sql-server-2017

if [ "$1" = '/opt/mssql/bin/sqlservr' ]; then
  # Se esta for a primeira execução do contêiner, inicialize o banco de dados do aplicativo
  if [ ! -f /tmp/app-initialized ]; then
    # Inicialize o banco de dados do aplicativo de forma assíncrona em um processo em segundo plano. Isso permite que a) o processo do SQL Server seja o processo principal no contêiner, o que permite o desligamento normal e outras vantagens, eb) que iniciemos o processo do SQL Server apenas uma vez, em vez de iniciar, parar e iniciá-lo novamente.
    function initialize_app_database() {
      # Aguarde um pouco para o SQL Server iniciar. O processo do SQL Server não fornece uma maneira inteligente de verificar se está ativo ou não, e precisa estar ativo antes de podermos importar o banco de dados do aplicativo
      sleep 15s
      # Execute o script de configuração para criar o banco de dados e o esquema no banco de dados
      /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d master -i $SCRIPT_STARTUP
      # Observe que o contêiner foi inicializado para que as partidas futuras não limpem as alterações nos dados
      touch /tmp/app-initialized
    }
    initialize_app_database &
  fi
fi

# ## Verifica instancia ##
# DBSTATUS=1
# ERRCODE=1
# i=0

# echo "###### Start check instance"
# while [[ $DBSTATUS -ne 0 ]] && [[ $i -lt 60 ]]; do
#   let i=$i+1
#   DBSTATUS=$(/opt/mssql-tools/bin/sqlcmd -h -1 -t 1 -S localhost -U SA -P "$SA_PASSWORD" -Q "SET NOCOUNT ON; Select SUM(state) from sys.databases")
#   ERRCODE=$?
#   sleep 2s
# done

# if [[ $DBSTATUS -ne 0 ]] || [[ $ERRCODE -ne 0 ]]; then
#   echo "O SQL Server levou mais de 60 segundos para inicializar ou um ou mais bancos de dados não estão no estado ONLINE"
#   exit 1
# else
#   echo "###########################################################################"
#   echo "###########################################################################"
#   echo ">>>>>>>>>>>>>>> SQL SERVER INSTALADO COM SUCESSO!!!!! <<<<<<<<<<<<<<<<<<<<<"
#   echo "###########################################################################"
#   echo "###########################################################################"
# fi

exec "$@"