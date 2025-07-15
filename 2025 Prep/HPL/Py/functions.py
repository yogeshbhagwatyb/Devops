# Step 1: Define the function called check_age that accepts two inputs: name and age
def check_age(name, age):
    # If the age is exactly 18, return a message
    if age == 18:
        return f"{name}, you are an adult."
    else:
        # If age is not 18, return a different message
        return f"{name}, you are not 18 yet."

# Step 2: Ask the user to enter their name (input is always a string)
name_input = input("Enter your name: ")

# Step 3: Ask the user to enter their age (input is a string, so we convert it to integer)
age_input = input("Enter your age: ")
age_input = int(age_input)  # Convert string to integer

# Step 4: Call the function and pass the user's inputs as arguments
# name_input is passed as "name", age_input is passed as "age"
print(check_age(name_input, age_input))
