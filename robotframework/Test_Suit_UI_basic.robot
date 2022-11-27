*** Settings ***
Documentation     Acceptance Criteria for UI testing
...               As a UI user I can:
...               Register through web portal
...               Review my own user information from the main view

Resource          keywords.resource
Suite Teardown    Close All Browsers


*** Variables ***

&{VALID_USER}      login=username   
...             password=userpass  
...             firstname=user_firstname
...             lastname=user_lastname
...             phone=111

${INVALID_PASSWORD}    user_pass
${PATH}    ${CURDIR}/example.csv


*** Test Cases ***



Index page checking
    [Tags]    general
    Open Browser To Index Page
    Page Should Contain Link     Register
    Page Should Contain Link     Log In
    Page Should Contain     index page
    Click Link     Register
    Check register page elements
    Click Link     Log In
    Check login page elements
    
    

User registration
    [Tags]    registration  valid_login
    ${TEST_USER}=    Create test user    &{VALID_USER}
    # Registration
    Open Browser To Register Page
    Register Page Should Be Open
    Input Username    ${TEST_USER}[login]
    Input Password    ${TEST_USER}[password]
    Input Family name    ${TEST_USER}[lastname]
    Input First name    ${TEST_USER}[firstname]
    Input Phone number    ${TEST_USER}[phone]
    Submit Credentials - register 
    Login Page Should Be Open
    # Checking of registration
    Input Username    ${TEST_USER}[login]
    Input Password    ${TEST_USER}[password]
    Submit Credentials - login
    User Information Page Should Be Open 
    Check user information elements    &{TEST_USER}
    
    
    

User login - valid
    [Tags]    login_options    valid_login
    Open Browser To Login Page
    Input Username    ${VALID_USER}[login]
    Input Password    ${VALID_USER}[password]
    Submit Credentials - login 
    User Information Page Should Be Open  
    
User logout
    [Tags]    login_options    valid_login  
    Open Browser To Login Page
    Input Username    ${VALID_USER}[login]
    Input Password    ${VALID_USER}[password]
    Submit Credentials - login 
    User Information Page Should Be Open 
    Click Link     Log Out
    Index Page Should Be Open
    

User login - invalid
    [Tags]    login_options    invalid_login  negative  
    Open Browser To Login Page
    Input Username    ${VALID_USER}[login]
    Input Password    ${INVALID PASSWORD}
    Submit Credentials - login 
    Error Page Should Be Open  
    
    
    
User login - no username
    [Tags]    login_options    invalid_login  negative
    Open Browser To Login Page
    Submit Credentials - login 
    # I have issues with implementation of flashed message catch:
    # https://groups.google.com/g/robotframework-users/c/tknE52B8Vmc
    # alert should be present    Please fill out this field
    # Therefore there is a little workaround: just checking that 
    Check Unsuccessful Login
    
    
    
User login - no password
    [Tags]    login_options    invalid_login  negative
    Open Browser To Login Page
    Input Username    ${VALID_USER}[login]
    Submit Credentials - login 
    # I have issues with implementation of flashed message catch:
    # https://groups.google.com/g/robotframework-users/c/tknE52B8Vmc
    # alert should be present    Please fill out this field
    # Therefore there is a little workaround: just checking that 
    Check Unsuccessful Login
    
    
    
User registration - from incomplete to complete
    [Tags]    registration  negative     active
    ${TEST_USER}=    Create test user    &{VALID_USER}
    # Registration
    Open Browser To Register Page
    Register Page Should Be Open
    Submit Credentials - register 
    Check Unsuccessful Registration
    
    Input Username    ${TEST_USER}[login]
    Submit Credentials - register 
    Check Unsuccessful Registration
    
    Input Password    ${TEST_USER}[password]
    Submit Credentials - register 
    Check Unsuccessful Registration
    
    Input Family name    ${TEST_USER}[lastname]
    Submit Credentials - register 
    Check Unsuccessful Registration
    
    Input First name    ${TEST_USER}[firstname]
    Submit Credentials - register 
    Check Unsuccessful Registration
    
    Input Phone number    ${TEST_USER}[phone]
    Submit Credentials - register 
    Login Page Should Be Open
    # Checking of registration
    Input Username    ${TEST_USER}[login]
    Input Password    ${TEST_USER}[password]
    Submit Credentials - login
    User Information Page Should Be Open 
    Check user information elements    &{TEST_USER}
    
    
    
    
*** Keywords ***
Check register page elements
    Page Should Contain     Username
    Page Should Contain Element     username
    Page Should Contain     Password
    Page Should Contain Element     password
    Page Should Contain     First name
    Page Should Contain Element     firstname
    Page Should Contain     Family Name
    Page Should Contain Element     lastname
    Page Should Contain     Phone number
    Page Should Contain Element     phone
    Page Should Contain Button     Register
    
Check login page elements
    Page Should Contain     Username
    Page Should Contain Element     username
    Page Should Contain     Password
    Page Should Contain Element     password
    Page Should Contain Button     Log In

Check user information elements
    [Arguments]    &{user}
    Table Row Should Contain    content    1    key value
    Table Row Should Contain    content    2    Username ${user}[login]
    Table Row Should Contain    content    3    First name ${user}[firstname]
    Table Row Should Contain    content    4    Last name ${user}[lastname]
    Table Row Should Contain    content    5    Phone number ${user}[phone]  
    Page Should Not Contain    Password
    Page Should Not Contain    ${user}[password]
    
    
Create test user
    [Arguments]    &{user}
    # Data randomization to not run into existing user
    &{TEST_USER}=    Randomize user   &{user}
    # Save user data to file
    ${udata}=     Stringify User    ${TEST_USER}
    Append To File          ${PATH}    ${udata}
    [return]  &{TEST_USER}