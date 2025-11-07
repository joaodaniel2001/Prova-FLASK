*** Settings ***
Documentation       Teste para verificar o sistema de Cadastro e Login
Library             SeleniumLibrary
Library             OperatingSystem

*** Variables ***
${URL_BASE}         http://127.0.0.1:5000
${URL_LOGIN}        ${URL_BASE}/
${URL_REGISTER}     ${URL_BASE}/cadastro
${URL_TURMA}        ${URL_BASE}/turma
${URL_LOGOUT}       ${URL_BASE}/logout 
${BROWSER}          chrome
${VALID_EMAIL}      joaodanielaraujo1@gmail.com
${VALID_NAME}       João
${VALID_SURNAME}    Daniel
${VALID_PASSWORD}   123
${SUCESS_MESSAGE}   Lista de Turmas 
${LOGOUT_SUCCESS_TEXT}    Login 
    
*** Keywords ***
Efetuar Login
    [Arguments]         ${email}    ${senha}
    Open Browser        ${URL_LOGIN}    ${BROWSER}
    Maximize Browser Window
    Input Text          id=email    ${email}
    Input Text          id=senha    ${senha}
    Click Button        id=btnSubmit
    Wait Until Page Contains    ${SUCESS_MESSAGE}    timeout=5s
    Location Should Be  ${URL_TURMA}

*** Test Cases ***
Realizar o cadastro com credenciais válidas
    [Tags]              UI    Cadastro    Sucesso

    # 1 - Abrindo o navegador na página de cadastro
    Open Browser        ${URL_REGISTER}    ${BROWSER}
    Maximize Browser Window
    
    # 2 - Preencher os campos usando os ID do HTML
    Input Text          id=nome    ${VALID_NAME}
    Input Text          id=sobrenome    ${VALID_SURNAME}
    Input Text          id=email    ${VALID_EMAIL}
    Input Text          id=senha    ${VALID_PASSWORD}
    Input Text          id=confirmacao_senha    ${VALID_PASSWORD}

    # 3 - Clicar no botão de Enviar (id=btnSubmit)
    Click Button        id=btnSubmit
    
    # 4 - Verifica o resultado (Sucesso)
    Wait Until Page Contains    ${SUCESS_MESSAGE}    timeout=5s

    # Verificando se a URL mudou para a página de turma
    Location Should Be    ${URL_TURMA}

    # 5 - Finalizando o teste
    Close Browser

Realizar um Login com credenciais válidas
    [Tags]              UI    Login    Sucesso

    # Usando a palavra-chave para o login
    Efetuar Login       ${VALID_EMAIL}    ${VALID_PASSWORD}

    # 5 - Finalizando o teste
    Close Browser

Realizar Logout com Sucesso
    [Tags]              UI    Logout    Sucesso
    
    # Pré-requisito: Fazer Login primeiro
    Efetuar Login       ${VALID_EMAIL}    ${VALID_PASSWORD}
    
    # 1 - Clicar no botão Sair/Logout
    # O HTML mostra: <a href="{{ url_for('logout') }}" class="btn btn-danger">Sair</a>
    # Localizamos o link pelo seu texto
    Click Link          Sair 
    
    # 2 - Verificar se a página retornou ao estado de não-logado
    Wait Until Page Contains    ${LOGOUT_SUCCESS_TEXT}    timeout=5s
    
    # 3 - Finalizando o teste
    Close Browser