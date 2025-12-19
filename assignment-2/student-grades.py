students = {}  # empty dictionary

while True:
    print("\nOptions: add / update / print / exit")
    choice = input("Enter option: ").lower()
    
    if choice == "add":
        name = input("Enter student name: ")
        grade = input("Enter grade: ")
        students[name] = grade
        print("Added", name, "with grade", grade)
    
    elif choice == "update":
        name = input("Enter student name to update: ")
        if name in students:
            grade = input("Enter new grade: ")
            students[name] = grade
            print("Updated", name, "to grade", grade)
        else:
            print(name, "not found")
    
    elif choice == "print":
        print("\nStudent Grades:")
        for name in students:  # loop through keys (student names)
            print(name + ": " + students[name])  # access value using key
    
    elif choice == "exit":
        print("Exiting program...")
        break
    
    else:
        print("Invalid option, try again")
