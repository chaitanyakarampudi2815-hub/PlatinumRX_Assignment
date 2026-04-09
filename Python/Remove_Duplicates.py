original_String = input()
unique_String = ""

for char in original_String:
    if char not in unique_String:
        unique_String += char

print(unique_String)
