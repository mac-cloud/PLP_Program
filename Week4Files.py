def modify_file_content(content):
    return content.title()

def main():
    filename = input(" Enter the filename to read from: ")

    try:
        with open(filename, "r") as file:
            content = file.read()

        # Modify the content
        modified_content = modify_file_content(content)

        #Write to new file
        with open("modified_output.txt", "w") as output_file:
            output_file.write(modified_content)

        print("File processed successfully. Modified content saved to 'modified_output.txt'.")

    except FileNotFoundError:
        print("Error: The file was not found. Please check the filename and try again.")
    except IOError:
        print("Error: The file could not be read or written.")

if __name__ == "__main__":
    main()
