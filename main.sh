#!/bin/bash 

 
# Define file name 

file_name="records.csv" 

# Function to validate user input 

function validate_input() { 

    if [[ "$1" =~ [^a-zA-Z0-9]+ ]]; then 

        echo "Invalid input. Please enter only letters and numbers." 

        return 1 

    fi 

    return 0 

} 


# Function to get album name from user 

function rec_name() { 

    while true; do 

        read -p "Please enter the album name: " name 

        if validate_input "$name"; then 

            break 

        fi 

    done 

} 

 
# Function to get album amount from user 

function rec_amount() { 

    while true; do 

        read -p "Please enter the album amount: " amount 

        if [[ "$amount" =~ [^0-9]+ ]]; then 

            echo "Invalid input. Please enter numbers only." 

        else 

            return "$amount" 

            break 

        fi 

    done 

} 

 

# Function to check if album exists in file 

function rec_search() { 

    if grep -q "^$name," "$file_name"; then 

        return 0 

    else 

        return 1 

    fi 

} 

 

# Function to list records and get user selection 

function rec_list() { 

    if grep -q "$name" "$file_name"; then 

        echo "Please choose a record:" 

        grep "$name" "$file_name" | cat -n 

        read -p "Enter the record number: " record_number 

        #validation of rows numbers 

        if [[ "$record_number" =~ ^[0-9]+$ ]]; then 

            record=$(grep "$name" "$file_name" | sed -n "${record_number}p") 

            name=$(echo "$record" | cut -d, -f1) 

            amount=$(echo "$record" | cut -d, -f2) 

            return 0 

        else 

            echo "Invalid input. Please enter numbers only." 

            return 1 

        fi 

    else 

        echo "Sorry, no matches were found." 

        return 1 

    fi 

} 

 

# Function to add a new record 

function rec_add() { 

    rec_name 

    if rec_search; then 

        rec_list 

        current_amount=$amount 

        rec_amount 

        new_amount=$(expr $(echo "$current_amount" | tr -dc '0-9') + $(echo "$amount" | tr -dc '0-9')) 

        sed -i "s/^$name,$current_amount$/$name,$new_amount/" "$file_name" 

        echo "You've added the album: $name amount: $amount successfully" 

    else 

        rec_amount 

        echo "$name,$amount" >> "$file_name" 

        echo "You've added the album: $name amount: $amount successfully" 

    fi 

} 
