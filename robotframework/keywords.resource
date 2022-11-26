*** Settings ***
Library           SeleniumLibrary
Library           CustomLibrary.py

*** Variables ***
${SERVER}         localhost:8080
${BROWSER}        Chrome
${DELAY}          0
${LOGIN URL}      http://${SERVER}/login
${REGISTER URL}      http://${SERVER}/register
${USER URL}    http://${SERVER}/user
${ERROR URL}      http://${SERVER}/error
${INDEX URL}      http://${SERVER}/

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Login Page Should Be Open

Open Browser To Index Page
    Open Browser    ${INDEX URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Index Page Should Be Open

Open Browser To Register Page
    Open Browser    ${REGISTER URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Register Page Should Be Open

Index Page Should Be Open
    Title Should Be    index page - Demo App

Login Page Should Be Open
    Title Should Be    Log In - Demo App
    
    
Register Page Should Be Open
    Title Should Be    Register - Demo App

Go To Login Page
    Go To    ${LOGIN URL}
    Login Page Should Be Open
    
Go To Register Page
    Go To    ${LOGIN URL}
    Register Page Should Be Open

Input Username
    [Arguments]    ${username}
    Input Text    username    ${username}

Input Password
    [Arguments]    ${password}
    Input Text    password    ${password}
    
Input Family name
    [Arguments]    ${lastname}
    Input Text    lastname    ${lastname}
    
Input First name
    [Arguments]    ${firstname}
    Input Text    firstname    ${firstname}
    
Input Phone number
    [Arguments]    ${phone_number}
    Input Text    phone    ${phone_number}

Submit Credentials - register
    Click Button    Register
    
Submit Credentials - login
    Click Button    Log In

User Information Page Should Be Open
    Location Should Be    ${USER URL}
    Title Should Be    User Information - Demo App

Check Unsuccessful Login
    Login Page Should Be Open
    Location Should Be    ${LOGIN URL}

Check Unsuccessful Registration
    Register Page Should Be Open
    Location Should Be    ${REGISTER URL}

Error Page Should Be Open
    Location Should Be    ${ERROR URL}
    Title Should Be    Login Failure - Demo App
    
Error Message Should Be shown
    [Arguments]    ${message}
    Page Should Contain Textfield    ${message}
    
    
Randomize user
    [Arguments]    &{user}
    ${user.login}=    Randomize String    ${user}[login]
    ${user.password}=    Randomize String    ${user}[password]
    ${user.firstname}=    Randomize String    ${user}[firstname]
    ${user.lastname}=    Randomize String    ${user}[lastname]
    ${user.phone}=    Randomize String    ${user}[phone]
    [return]  &{user}




-