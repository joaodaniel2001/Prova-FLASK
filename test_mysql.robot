*** Settings ***
Library    DatabaseLibrary
Library    OperatingSystem

*** Variables ***
${DBDRIVER}     sqlite3
${DBFILE}       C:/Users/kawa_aguiar/Documents/GitHub/Prova-FLASK/instance/saep.db
${TABELA}       user

*** Test Cases ***
Conectar E Consultar Banco
    [Documentation]    Testa se a tabela 'user' existe e possui registros

    Should Exist    ${DBFILE}

    Connect To Database    ${DBDRIVER}    database=${DBFILE}

    ${tabelas}=    Query    SELECT name FROM sqlite_master WHERE type='table';
    Log    Tabelas encontradas: ${tabelas}

    Table Should Exist    ${TABELA}    ${tabelas}

    ${resultado}=    Query    SELECT COUNT(*) FROM ${TABELA};
    Log    Total de registros em ${TABELA}: ${resultado[0][0]}

    Disconnect From Database


*** Keywords ***
Table Should Exist
    [Arguments]    ${tabela}    ${lista}
    ${nomes}=    Evaluate    [t[0] for t in ${lista}]
    Should Contain    ${nomes}    ${tabela}
