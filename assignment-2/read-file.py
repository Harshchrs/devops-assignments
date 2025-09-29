# Open the file in read mode
f = open("sample.txt", "r")  

# Read content
content = f.read()  

# Close the file
f.close()  

# Print content
print("File Content:\n")
print(content)
