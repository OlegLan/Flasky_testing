# Import section: requests?
import random
import string

# Minimal functions
def randomize_string(given_str):
    randomized_str = given_str + '_' + ''.join(random.choice(string.ascii_uppercase) for _ in range(5))
    return randomized_str
        
        
def randomize_number(given_number):
    randomized_number = given_number + '-' + ''.join(random.choice(string.digits) for _ in range(5))
    return randomized_number


