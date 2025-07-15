1. What are Python’s data types?
Python has several built-in data types. They tell Python what kind of data you're working with (numbers, text, lists, etc.).
a. Numeric Types
    Used to store numbers:
    int: Whole numbers (e.g. 10, -5)
    float: Decimal numbers (e.g. 3.14, -0.01)
    complex: Numbers with real and imaginary parts (e.g. 3 + 4j)

b. Sequence Types
    a. List
    These data types are used to store multiple items in a specific order. You can access them using index numbers, starting from 0

    A list is a mutable (changeable), ordered collection of elements.
    You can add, remove, or modify items after the list is created

    my_list = [10, 20, 30, "apple", True]

    Key Features:
    Ordered (indexable)
    Can hold mixed data types (int, str, etc.)
    Mutable (you can change values)
    Use square brackets: []

    # Access
    print(my_list[0])  # 10

    # Modify
    my_list[1] = 99

    # Add
    my_list.append("banana")

    # Remove
    my_list.remove(30)

    b. A tuple is an immutable (unchangeable), ordered collection of elements.
    Once created, you cannot change or add items.
    Use round brackets: ()
    my_tuple = (10, 20, 30, "apple", True)

    Ordered (indexable)
    Can hold mixed data types
    Immutable (good for fixed data)
    Faster than lists for iteration

    c. range
    A range creates a sequence of numbers.
    It's commonly used with loops like for

    Example
    # range from 0 to 4
    r = range(5)  # 0, 1, 2, 3, 4

    # Convert to list to view it
    print(list(r))  # [0, 1, 2, 3, 4]

    # range with start and step
    print(list(range(1, 10, 2)))  # [1, 3, 5, 7, 9]

c. Text Type
    str (String)
    A str is a sequence of characters, used to store text.
    It is immutable, meaning once created, it cannot be changed

    name = "Alice"
    message = "Hello, " + name
    print(message)  # Output: Hello, Alice

d. Set
    d. set type
    We can store a collection of items, like a list, but:
    The items are not in order
    Duplicates are not allowed

    e. frozenset
    Same as set, but you can’t change it once it’s created
    Yes, in a set, items can be of any data type — strings, integers, floats, even a mix of them. Example:
    my_set = {1, "apple", 3.14}

e. mapping
    a. Mapping Type — dict
    A dict (dictionary) is a collection of key-value pairs.
    Each key has a value attached to it.    

    Example
    person = {
        "name": "Bob",
        "age": 25
    }

    print(person["name"])  # Output: Bob

f. Boolean Type — bool
    The bool type is used to store True or False values.
    Used when we want to answer questions like:
    Yes or No?
    On or Off?
    Is it correct?    


g. Binary Types — bytes, bytearray
    These are used to store binary data like images, files, or raw data from networks.
    byte
    A bytes object stores binary data
    It is immutable (you can't change it)
    b = bytes([65, 66, 67])
    print(b)  # Output: b'ABC'

    bytearray
    A bytearray is like bytes but mutable (you can change it)
    ba = bytearray([68, 69, 70])
    ba[0] = 88
    print(ba)  # Output: bytearray(b'XEF')


------------------------------------------------------------------------------------------------------------

2. What is a dictionary in Python?
A dictionary in Python is a built-in data type that stores data in the form of key-value pairs.
Example
person = {
    "name": "Alice",
    "age": 30,
    "city": "Pune"
}

print(person["name"])  # Output: Alice

------------------------------------------------------------------------------------------------------------

3. Function
A function in Python is like a reusable block of code.
You write it once, and then you can call it as many times as you want, with different inputs.

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

------------------------------------------------------------------------------------------------------------

4. What are *args and kwargs?

They are used in function definitions to allow flexible number of inputs.

**args
It allows you to send multiple values into a function.
These values are stored as a tuple.
Useful when you don't know how many values you will get.

What is **kwargs?
It allows you to send multiple keyword arguments (key = value).
These are stored in a dictionary.

------------------------------------------------------------------------------------------------------------

5. What is the difference between is and ==?

== checks value equality (are the contents the same?)
is checks identity (are they the same object in memory?)

a = [1, 2]
b = [1, 2]
print(a == b)  # True
print(a is b)  # False

------------------------------------------------------------------------------------------------------------

6. What is a Python module and package?

a. module
A single .py file that contains Python code — like functions, classes, or variables — that you can reuse in other files.

Suppose you have a file named math_utils.py:
# math_utils.py
def add(a, b):
    return a + b

def multiply(a, b):
    return a * b


Now in another file, you can import this module and use it:
# main.py
import math_utils

print(math_utils.add(2, 3))       # Output: 5
print(math_utils.multiply(2, 3))  # Output: 6

------------------------------------------------------------------------------------------------------------

7. Python Loops
Loops are used to repeat a block of code multiple times, which avoids writing repetitive code manually.
Python mainly has:
a. for Loop
b. while Loop
c. break, continue, pass - Loop Control Statements

1. for Loop - Used to Iterate Over a Sequence (List, String, etc.)
Theory:
Runs code for each item in a sequence
Useful when you know how many times to loop

    Syntax: 
    for variable in sequence:

    Example:
    fruits = ["apple", "banana", "mango"]
    for pen in fruits:
    print(pen)

    Output
    apple
    banana
    mango

Explanation:
You created a list fruits = ["apple", "banana", "mango"]
The for loop iterates over each item in the list
The variable pen takes the value of each fruit one by one and prints it

*********************
1.1 range() Function - Generates a Sequence of Numbers

range() is a built-in Python function that generates a sequence of numbers.
It is often used with loops (like for loop) when you want to repeat something a specific number of times.

Syntax
range(stop)
range(start, stop)
range(start, stop, step)

    Example 1: range(5)
    for i in range(5):
        print(i)

    What Happens:
    range(5) generates numbers: 0, 1, 2, 3, 4
    The loop assigns each number to i one by one and prints it

    Outputs
    0
    1
    2
    3
    4

    Example 2: range(2, 6)
    for i in range(2, 6):
        print(i)

    What Happens:
    range(2, 6) generates numbers: 2, 3, 4, 5
    Starts from 2, ends before 6

    Output
    2
    3
    4
    5

    Example 3: range(1, 10, 2)
    for i in range(1, 10, 2):
        print(i)

    What Happens:
    range(1, 10, 2) generates numbers:
    Starts from 1
    Ends before 10
    Steps/increments by 2 each time
    Generated numbers: 1, 3, 5, 7, 9

    Output
    1
    3
    5
    7
    9

*********************

2. What is while Loop?
A while loop repeatedly runs a block of code as long as the given condition is True.
Once the condition becomes False, the loop stops.

Syntax
while condition

1. Example 1: Simple Count
count = 1

while count <= 5:
    print(count)
    count += 1   # same as count = count + 1

Output
1
2
3
4
5

Step-by-Step Explanation:
Initial Setup:
count = 1
Loop Begins

First Iteration:
Check condition: count <= 5 → 1 <= 5 → True
So, print 1
Update: count += 1 → count = 2

Second Iteration:
Check condition: count <= 5 → 2 <= 5 → True
So, print 2
Update: count = 3

Third Iteration:
Check condition: count <= 5 → 3 <= 5 → True
So, print 3
Update: count = 4

Fourth Iteration:
Check condition: count <= 5 → 4 <= 5 → True
So, print 4
Update: count = 5

Fifth Iteration:
Check condition: count <= 5 → 5 <= 5 → True
So, print 5
Update: count = 6

Condition Fails:
Check condition: count <= 5 → 6 <= 5 → False
Loop stops

Why count += 1 is Important?
It increases the value of count each time
If you forget this line, the loop will run forever (infinite loop)

2. Example 2: Simple Count
count = 1

while count <= 5:
    print(count)
    count += 2   # same as count = count + 2

Initial:
count = 1   

First Iteration:
Condition: count <= 5 → 1 <= 5 → True
Print: 1
Update: count += 2 → count = 3

Second Iteration:
Condition: count <= 5 → 3 <= 5 → True
Print: 3
Update: count += 2 → count = 5

Third Iteration:
Condition: count <= 5 → 5 <= 5 → True
Print: 5
Update: count += 2 → count = 7

Condition Fails:
Condition: count <= 5 → 7 <= 5 → False
Loop stops

✅ Final Output:
1
3
5

3. Example 3: Simple Count
count = 3

while count <= 5:
    print(count)
    count += 1   # same as count = count + 1

Initial Value:
count = 3

✅ Final Output:
3
4
5

*********************

