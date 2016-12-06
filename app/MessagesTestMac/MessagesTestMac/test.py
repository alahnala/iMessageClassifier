import sys

def main():
    filename = sys.argv[1]
    try:
        input_file = open(filename, "r")
    except IOError:
        print_error("Could not open " + filename)
        exit(2)
    lines = input_file.read()
    print lines[:10]

if __name__ == '__main__':
    main()
