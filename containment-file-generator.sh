# the first argument is the raw.ta file
# the second argument is the source file where subsystem and containments are specified
# the third argument is the destination containment file
# ABOUT: this generator is directory level only. Source files have been excluded. This simplifies the architecture.

subsystemTag="SUBSYSTEM"
rawTaFile=$1
subsystemSpec=$2
outputFile=$3


#process raw text file and puts each subsystem and their components on to one line, each line is an element of subsystemArray
IFS=$'\n' read -r -d '' -a subsystemArray <<< $(cat $subsystemSpec | tr "\n" " " | sed "s/$subsystemTag/\n$subsystemTag/g" | sed '/^[[:space:]]*$/d')

#process raw text file and collect all the subsystem names in to an array subsystems
IFS=$'\n' read -r -d '' -a subsystems <<< $(cat $subsystemSpec | tr "\n" " " | sed "s/$subsystemTag/\n$subsystemTag/g" | sed '/^[[:space:]]*$/d' | sed -E "s/$subsystemTag:([[:alnum:]]+)=.*$/\1/")

#prints instances of a subsystem formatted for the containment file, the first argument is the name of the subsystem
print_subsystem_instance () {
	echo "\$INSTANCE $1.ss cSubSystem"
}

#prints dependencies formatted for the containment file, the first argument is the containing element, the second argument is its dependency
print_subsystem_contain () {
	if printf '%s\n' "${subsystems[@]}" | grep -q "$2"; then
    		echo "contain $1.ss $2.ss"
	else
		cat $rawTaFile | grep "\$INSTANCE" | sed 's/$INSTANCE//g' | sed 's/cFile//g' | sort | grep "$2" | sed "s/^/contain $1.ss /" | sed -E -e 's/\/[a-zA-Z0-9\_\-]+\.(c|h|cpp)//g' | awk '!seen[$0]++' | sort | awk '$2!=$3 {print $0}' 
	fi
}

#iterates through the subsystemArray, and process and appends it to the second argument
print_subsystems () {
for subsystem in "${subsystemArray[@]}"
do
	IFS=' ' read -r -a array <<< $(sed "s/$subsystemTag://g" <<< $subsystem | sed 's/=//g' | sed 's/^[[:space:]]//')
	for containment in "${array[@]}"
	do
		if [[ "$containment" == "${array[0]}" ]];
		then
			print_subsystem_instance $containment
		else
			print_subsystem_contain ${array[0]} $containment
		fi
	done
done
}

echo "FACT TUPLE :" > $outputFile
print_subsystems | grep "^\$INSTANCE" >> $outputFile
print_subsystems | grep "^contain" | grep ".ss$" >> $outputFile
print_subsystems | grep "^contain" | grep -v ".ss$" >> $outputFile
inclusions=$(grep "src\/" $subsystemSpec | tr "\n" " " | sed 's/ /\|/g' | rev | cut -c3- | rev)
## Writes clinks to containment file
grep "cLinks" $rawTaFile | awk  -v pattern="$inclusions" '$2~pattern' | awk  -v pattern="$inclusions" '$3~pattern' | sort | grep "cLinks" | sed -E -e 's/\/[a-zA-Z0-9\_\-]+\.(c|h|cpp)//g' | awk '!seen[$0]++' | sort | awk '$2!=$3 {print $0}' >> $outputFile
