*** Settings ***
Documentation       Teste completo de Cadastro, Login e Logout com verificação de redirecionamento
Library             Browser

Suite Setup         Abrir Navegador
Suite Teardown      Fechar Navegador


*** Variables ***
${URL_BASE}         http://127.0.0.1:5000
${URL_LOGIN}        ${URL_BASE}/
${URL_REGISTER}     ${URL_BASE}/cadastro
${URL_TURMA}        ${URL_BASE}/turma
${URL_LOGOUT}       ${URL_BASE}/sair

${NOME}             Gabriel
${SOBRENOME}        Teste
${EMAIL}            finalmenteostestesfuncionam@gmail.com
${SENHA}            123456


*** Keywords ***
Abrir Navegador
    New Browser    chromium    headless=False
    New Context
    New Page       ${URL_BASE}

Fechar Navegador
    Close Browser

Fazer Cadastro
    Go To          ${URL_REGISTER}
    Wait For Elements State    input[name="email"]    visible
    Fill Text      input[name="nome"]                 ${NOME}
    Fill Text      input[name="sobrenome"]            ${SOBRENOME}
    Fill Text      input[name="email"]                ${EMAIL}
    Fill Text      input[name="senha"]                ${SENHA}
    Fill Text      input[name="confirmacao_senha"]    ${SENHA}
    Click          input[name="btnSubmit"]

Fazer Login
    Go To          ${URL_LOGIN}
    Wait For Elements State    input[name="email"]    visible
    Fill Text      input[name="email"]                ${EMAIL}
    Fill Text      input[name="senha"]                ${SENHA}
    Click          input[name="btnSubmit"]

Fazer Logout
    Go To          ${URL_LOGOUT}

*** Test Cases ***
Cadastro com redirecionamento correto
    Fazer Cadastro
    ${url_atual}=    Get Url
    Should Be Equal As Strings    ${url_atual}    ${URL_TURMA}

Login com redirecionamento correto
    Fazer Login
    ${url_atual}=    Get Url
    Should Be Equal As Strings    ${url_atual}    ${URL_TURMA}

Logout com redirecionamento correto
    Fazer Login
    Fazer Logout
    ${url_atual}=    Get Url
    Should Be Equal As Strings    ${url_atual}    ${URL_LOGIN}