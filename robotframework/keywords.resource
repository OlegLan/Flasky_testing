*** Settings ***
Library           SeleniumLibrary
Library           CustomLibrary.py
Library           OperatingSystem

*** Variables ***
${SERVER}         localhost:8080
${BROWSER}        Chrome
${DELAY}          0
${LOGIN URL}      http://${SERVER}/login
${REGISTER URL}      http://${SERVER}/register
${USER URL}    http://${SERVER}/user
${ERROR URL}      http://${SERVER}/error
${INDEX URL}      http://${SERVER}/
${DB_USERS}         ${CURDIR}/db_users.txt
${PATH}    ${CURDIR}/Users.csv

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
    ${user.username}=    Randomize String    ${user}[username]
    ${user.password}=    Randomize String    ${user}[password]
    ${user.firstname}=    Randomize String    ${user}[firstname]
    ${user.lastname}=    Randomize String    ${user}[lastname]
    ${user.phone}=    Randomize Number    ${user}[phone]
    [return]  &{user}
    
Create test user
    [Arguments]    &{user}
    # Data randomization to not run into existing user
    &{TEST_USER}=    Randomize user   &{user}
    # Save user data to file
    ${udata}=     Stringify User    ${TEST_USER}
    Append To File          ${PATH}    ${udata}
    [return]  &{TEST_USER}
    
Save Users From DB
    Create file    ${DB_USERS}
    @{USERS}=   Get All Users   ${SERVER} 
    FOR    ${element}    IN    @{USERS}
        Append To File          ${DB_USERS}    ${element}
        Append To File          ${DB_USERS}    \n
    END
    Log To Console    \nData saved in ${DB_USERS}
    


