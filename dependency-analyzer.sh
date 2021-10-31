############################################## README #####################################################################################################
# Ensure that the script is executable run a  chmod +x THIS_FILE
# when executing the script input the file that you want analyzed as the first argument, for example:
# ./dependency-analyzer.sh Postgres_UnderstandFileDependency.raw.ta
# you will be presented with options, select any of them. All options accept a path as input, the path must start with and include src, so for example:
# src/backend/snowball/libstemmer/stem_ISO_8859_1_danish.c
############################################################################################################################################################

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

print_selections
read selection

while [ $selection -ne 5 ]
do

case $selection in
        1)
        echo "Input path"
        read inputPath
        printf "\n ---------------file dependencies of path--------------\n"
        grep -i "cLinks postgresql-13.4/$inputPath" $1 | sort | awk '$2!=$3 {print $0}'
        printf " ----------------------------------------------\n"
        ;;
        2)
        echo "Input path"
        read inputPath
        printf "\n ---------------file dependends on path--------------\n"
        grep -i "cLinks postgresql-13.4/.* postgresql-13.4/$inputPath" $1 | sort | awk '$2!=$3 {print $0}'
        printf " ----------------------------------------------\n"
        ;;
        3)
        echo "Input path"
        read inputPath
        printf "\n ---------------path dependends on directories--------------\n"
        grep -i "cLinks postgresql-13.4/$inputPath" $1 | sed -E -e 's/\/[a-zA-Z0-9\_\-]+\.(c|h|cpp)//g' | awk '!seen[$0]++' | sort | awk '$2!=$3 {print $0}'
        printf " ----------------------------------------------\n"
        ;;
        4)
        echo "Input path"
        read inputPath
        printf "\n ---------------directories that depend on path--------------\n"
        grep -i "cLinks postgresql-13.4/.* postgresql-13.4/$inputPath" $1 | sed -E -e 's/\/[a-zA-Z0-9\_\-]+\.(c|h|cpp)//g' | awk '!seen[$0]++' | sort | awk '$2!=$3 {print $0}'
        printf " ----------------------------------------------\n"
        ;;
        5)
        echo "exiting..."
        ;;
        *)
        echo "error reading input, type a number form 1 to 5 only"
        ;;
esac

print_selections
read selection

done
