import random
import string
import csv
import logging
logging.basicConfig(level=logging.DEBUG)

# Minimal functions
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
