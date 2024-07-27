import re

n = int(input())
for _ in range(n):
    number = input()
    if re.match(r"^(?!.*(\d)(-?\1){3})[456]\d{3}(-?\d{4}){3}$", number):
        print("Valid")
    else:
        print("Invalid")
