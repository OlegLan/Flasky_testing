*** Settings ***
Documentation     Acceptance Criteria for API testing
...               As an API Consumer I can:
...               
...               Register new users
...               Review users registered in system + 
...               If authenticated I can get personal information of users +
...               If authenticated I can update personal information of users +

Resource          keywords.resource
Suite Teardown    Close All Browsers


*** Variables ***

&{VALID_USER}      username=username   
...             password=userpass  
...             firstname=user_firstname
...             lastname=user_lastname
...             phone=111
&{new_data1}      firstname=user_firstname_new1
...             lastname=user_lastname_new1
...             phone=111_new1
&{new_data2}      firstname=user_firstname_new2
...             lastname=user_lastname_new2
...             phone=111_new2
&{restored_data}      firstname=user_firstname
...             lastname=user_lastname
...             phone=111_new2

${INVALID_PASSWORD}    user_pass
${INVALID_USERNAME}    user_name_inv
${SERVER}         localhost:8080
${USER_ADDED_RESPONCE}    SUCCESS
${USER_EXISTED_RESPONCE}    Given user is already exists!
${AUTH_FAILURE}    Incorrect password!
${USER_FAILURE}    Invalid User

*** Test Cases ***



[TST-API-01] Get the list of all users
    [Tags]    general
    Save Users From DB
    
[TST-API-02] Get personal information of user with correct password
    [Tags]    user_data  
    ${testuser_info}=    Get User Info    ${SERVER}    ${VALID_USER}[username]    ${VALID_USER}[password]
    Should Not Be Equal    ${testuser_info}    ${AUTH_FAILURE}
    Log To Console    \n ${testuser_info}
    
    
[TST-API-03] Update personal information of user with correct password
    [Tags]    user_data    
    ${response}=    Put User Info    ${SERVER}    ${VALID_USER}[username]    ${VALID_USER}[password]    ${restored_data}
    # Get the old information
    ${testuser_info1}=    Get User Info    ${SERVER}    ${VALID_USER}[username]    ${VALID_USER}[password]
    # Change information
    ${response}=    Put User Info    ${SERVER}    ${VALID_USER}[username]    ${VALID_USER}[password]    ${new_data2}
    Should Not Be Equal    ${response}    ${AUTH_FAILURE}
    # Get the new information
    ${testuser_info2}=    Get User Info    ${SERVER}    ${VALID_USER}[username]    ${VALID_USER}[password]
    Should Not Be Equal  ${testuser_info1}  ${testuser_info2}
    
    
    
[TST-API-04] Add new user via API - success
    [Tags]    user_creation    
    &{test_user}=    Create test user    &{VALID_USER}
    ${response}=    Post New User        ${SERVER}    ${test_user}
    Should Be Equal    ${response}    ${USER_ADDED_RESPONCE}
    

[TST-API-05] Add new user via API - unsuccess, user already exists
    [Tags]    user_creation    negative
    ${response}=    Post New User        ${SERVER}    ${VALID_USER}
    Should Be Equal    ${response}    ${USER_EXISTED_RESPONCE}
    
    
[TST-API-06] Try to get personal information of user with wrong password
    [Tags]    user_data  negative
    ${testuser_info}=    Get User Info    ${SERVER}    ${VALID_USER}[username]    ${INVALID_PASSWORD}
    Should Be Equal    ${testuser_info}    ${AUTH_FAILURE}
    Log To Console    \n ${testuser_info}
    
    
[TST-API-07] Try to update personal information of user with wrong password
    [Tags]    user_data  negative
      # Get the old information
    ${testuser_info1}=    Get User Info    ${SERVER}    ${VALID_USER}[username]    ${VALID_USER}[password]
    # Try to change information
    ${response}=    Put User Info    ${SERVER}    ${VALID_USER}[username]    ${INVALID_PASSWORD}    ${new_data2}
    Should Be Equal    ${response}    ${AUTH_FAILURE}
    # Get the new information - should not change
    ${testuser_info2}=    Get User Info    ${SERVER}    ${VALID_USER}[username]    ${VALID_USER}[password]
    Should Be Equal  ${testuser_info1}  ${testuser_info2}
    
    
[TST-API-08] User not found
    [Tags]    user_data  negative    active
    ${response}=    Get User Info    ${SERVER}    ${INVALID_USERNAME}    ${VALID_USER}[password]
    Should Be Equal    ${response}    ${USER_FAILURE}
    ${response}=    Put User Info    ${SERVER}    ${INVALID_USERNAME}    ${VALID_USER}[password]    ${new_data2}
    Should Be Equal    ${response}    ${USER_FAILURE}