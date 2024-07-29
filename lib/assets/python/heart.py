import sys
import numpy as np

#pass input from Rubby and process it with python.

user_input = int(sys.argv[1])
# Generate a random integer from 1 to 6
random_number = np.random.randint(1, user_input)
print("%s" %(random_number))
