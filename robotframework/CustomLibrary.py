import random
import string
import logging
import requests
import json 

logging.basicConfig(level=logging.DEBUG)
API_ALL_USERS = '/api/users'  # Get, Post
API_USER_TOKEN = '/api/auth/token'  # Get, Post
API_USER_DATA = '/api/users/{username}' # Get, Put
bare_url = 'localhost:8080'


# Functions for UI
def randomize_string(given_str):
    randomized_str = given_str + '_' + ''.join(random.choice(string.ascii_uppercase) for _ in range(5))
    return randomized_str
        
        
def randomize_number(given_number):
    randomized_number = given_number + '-' + ''.join(random.choice(string.digits) for _ in range(5))
    return randomized_number


def stringify_user(user_dict):
    user_str = ''
    for key in user_dict.keys():
        user_str += str(user_dict[key]) + ','
    user_str = user_str[:-1] + '\n'
    return user_str

# Functions for API
def get_request_status(request):
    return request.json()['status']

def get_request_payload(request):
    return request.json()['payload']

def get_request_token(request):
    return request.json()['token']

def get_all_users(url):
    response = requests.get('http://' + url + API_ALL_USERS)
    logging.info('Request status for get_all_users: ' + get_request_status(response))
    return get_request_payload(response)

def get_access_token(url, client_id, client_secret):
    response = requests.get('http://' + url + API_USER_TOKEN, auth=(client_id, client_secret)   )
    logging.info('Request status for get_access_token: ' + str(response.content))
    if response.json()['status'] != 'SUCCESS':
        if (response.json()['message'] == 'Invalid Authentication'):
            return 'Incorrect password!'
    elif (get_request_status(response) == 'FAILURE'):
        raise Exception("Another error in authentification request")
    return get_request_token(response)
    
def get_user_info(url, client_id, client_secret):
    t = get_access_token(url, client_id, client_secret)
    if (t == 'Incorrect password!'):
        return t
    header = {'token': t}
    response = requests.get('http://' + url + '/api/users/{}'.format(client_id), headers=header)
    logging.info('Request status for get_access_token: ' + get_request_status(response))
    
    return get_request_payload(response)

# TBC:
def post_new_user(url, client_data):
    client_data_fixed=json.loads(json.dumps(client_data))
    logging.info('Sent client data: ' + str(client_data_fixed))
    response = requests.post('http://' + url + '/api/users', json=client_data_fixed)
    logging.info('Responce from the server: ' + str(response.content))
    if response.json()['message'] == 'User exists':
        return "Given user is already exists!"
    clients = get_all_users('localhost:8080')
    if (client_data_fixed['username'] in clients):
        return 'SUCCESS'
    else:
        return "FAILURE: user wasn't added"
    
def put_user_info(url, client_id, client_secret, client_data):
    client_data_fixed=json.loads(json.dumps(client_data))
    t = get_access_token(url, client_id, client_secret)
    if (t == 'Incorrect password!'):
        return t
    header = {'token': t}
    response = requests.put('http://' + url + '/api/users/{}'.format(client_id), headers=header, json=client_data_fixed)
    logging.info('Responce from the server: ' + str(response.content))
    logging.info('Update from server: ' + str(get_user_info(url, client_id, client_secret)))
    return 'SUCCESS'
    
    
    
    
