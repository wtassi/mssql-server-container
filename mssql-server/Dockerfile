# Referencia: https://hub.docker.com/_/microsoft-mssql-server
# Verifique a versão disponível e a que deseja utilizar.
FROM mcr.microsoft.com/mssql/server:2022-latest

# ACCEPT_EULA: confirma sua aceitação do Contrato de Licenciamento de Usuário Final.
ENV ACCEPT_EULA=Y

# MSSQL_SA_PASSWORD: é a senha do administrador do sistema de banco de dados (userid = 'sa') usada para se conectar ao SQL Server quando o contêiner estiver em execução. Observação importante: Essa senha precisa incluir pelo menos 8 caracteres de pelo menos três dessas quatro categorias: letras maiúsculas, letras minúsculas, números e símbolos não alfanuméricos.
ENV SA_PASSWORD='Password@1234'

# MSSQL_PID: é a ID do produto (PID) ou edição com a qual o contêiner será executado. Valores aceitáveis:
#   Developer : Isso executará o contêiner usando o Developer Edition (este é o padrão se nenhuma variável de ambiente MSSQL_PID for fornecida)
#   Express: Isso executará o contêiner usando a Express Edition
#   Standard : Isso executará o contêiner usando a Standard Edition
#   Enterprise: isso executará o contêiner usando a Enterprise Edition
#   EnterpriseCore: isso executará o contêiner usando o Enterprise Edition Core
ENV MSSQL_PID='Developer'

# Cria uma pasta de configurações
RUN mkdir -p /usr/config

# Fonte de configuração do pacote
COPY . /usr/config

# Conceder permissões para que nossos scripts sejam executáveis
RUN chmod 777 /usr/config

# Nome do script customizado que será executado
ENV SCRIPT_STARTUP='/usr/config/script-setup.sql'

EXPOSE 1433

ENTRYPOINT [ "/bin/bash", "/usr/config/entrypoint.sh" ]

CMD [ "/opt/mssql/bin/sqlservr" ]