# the first argument is the source file where subsystem and dependencies are specified (see the example file for format)
# the second argument is the destination containment file, it will hold both the instances and dependencies


subsystemTag="SUBSYSTEM"

#process raw text file and puts each subsystem and their components on to one line, each line is an element of subsystemArray
IFS=$'\n' read -r -d '' -a subsystemArray <<< $(cat $1 | tr "\n" " " | sed "s/$subsystemTag/\n$subsystemTag/g" | sed '/^[[:space:]]*$/d')

#process raw text file and collect all the subsystem names in to an arrau subsystems
IFS=$'\n' read -r -d '' -a subsystems <<< $(cat $1 | tr "\n" " " | sed "s/$subsystemTag/\n$subsystemTag/g" | sed '/^[[:space:]]*$/d' | sed -E "s/$subsystemTag:([[:alnum:]]+)=.*$/\1/")

print_selections () {
echo "Please make a selection by typing in the number"

# takes a path as input and get all files it depends on, the output is sorted
echo "[1] Get file dependencies"

# takes a path as input and gets all files that depend on this path, the output is sorted
echo "[2] Get files that depend on path"

# Takes a path as input and gets all directories that it depends on, it is sorted and all duplicates are removed
echo "[3] Get directory dependencies"

# Takes a path as input and gets all directories that depend on that path, it is sorted and all duplicates are removed
echo "[4] Get directories that depend on path"

echo "[5] Exit"
}

#prints instances of a subsystem formatted for the containment file, the first argument is the name of the subsystem
print_subsystem_instance () {
        echo "\$INSTANCE $1.ss cSubSystem"
}

#prints dependencies formatted for the containment file, the first argument is the containing element, the second argument is its dependency
print_subsystem_contain () {
        if printf '%s\n' "${subsystems[@]}" | grep -q "$2"; then
                echo "contain $1.ss $2.ss"
        else
                echo "contain $1.ss $2"
        fi
}

#iterates through the subsystemArray, and process and appends it to the second argument
print_subsystems () {
for i in "${subsystemArray[@]}"
do
        IFS=' ' read -r -a array <<< $(sed "s/$subsystemTag://g" <<< $i | sed 's/=//g' | sed 's/^[[:space:]]//')
        for j in "${array[@]}"
        do
                if [[ "$j" == "${array[0]}" ]];
                then
                        print_subsystem_instance $j
                else
                        print_subsystem_contain ${array[0]} $j
                        # you can also extend the functionality here
                        # ${array[0]} ... is the name of the subsystem
                        # $j is its particular dependency for this iteration
                fi
        done
done
}


#prints all instances of subsystems
print_subsystems | grep "^\$INSTANCE" > $2

#prints subsystem to subsystem dependencies
print_subsystems | grep "^contain" | grep ".ss$" >> $2

#prints subsystem to directory or file dependency
print_subsystems | grep "^contain" | grep -v ".ss$" >> $2
