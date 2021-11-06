subsystemTag="SUBSYSTEM"
rawTaFile=$1
subsystemSpec=$2
outputFile=$3

#process raw text file and puts each subsystem and their components on to one line, each line is an element of subsystemArray
IFS=$'\n' read -r -d '' -a subsystems <<< $(cat $subsystemSpec | tr "\n" " " | sed "s/$subsystemTag/\n$subsystemTag/g" | grep "$subsystemTag" | sed '/^[[:space:]]*$/d')

#process raw text file and gets all directures of dirSubsystems
IFS=$'\n' read -r -d '' -a dirSubsystemChildDirs <<< $(cat $subsystemSpec | tr "\n" " " | sed "s/$subsystemTag/\n$subsystemTag/g" | sed "s/$subsystemTag/\n$subsystemTag/g" | grep "$subsystemTag" | sed "s/$subsystemTag:[a-zA-Z0-9]*= //g" | sed '/^[[:space:]]*$/d')

#process raw text file and collect all the subsystem names in to an arrau subsystems
IFS=$'\n' read -r -d '' -a subsystemNames <<< $(cat $subsystemSpec | tr "\n" " " | sed "s/$subsystemTag/\n$subsystemTag/g" | sed "s/$subsystemTag/\n$subsystemTag/g" | sed '/^[[:space:]]*$/d' | sed -E "s/($subsystemTag|$subsystemTag):([[:alnum:]]+)=.*$/\2/")

extract_containments () {
	parentDir=$2
	parentDirEsc=$(echo "$2" | sed "s/\//@/g")
	ssName=$1
	rootDirEsc=$(echo "$1" | sed "s/\//@/g")
	IFS=$'\n' read -r -d '' -a childDirs <<< $(grep "\$INSTANCE" $rawTaFile | grep -v "\/contrib" | grep -v "\/test" | sed -E -e 's/\/[a-zA-Z0-9\_\-]+\.(c|h|cpp)//g' | sed 's/$INSTANCE//g' | sed 's/cFile//g' | sort | awk '!seen[$0]++' | grep "$parentDir\/" | sed 's/postgresql-13.4\///g' | sed  's/\//@/g' | sed "s/$parentDirEsc//g" | sed '/^[[:space:]]*$/d' | sed 's/^ @//' |sed -E "s/^([a-zA-Z0-9\_\-]+)@.*/\1/g" | awk '!seen[$1]++')
#	if [[ "${#childDirs[@]}" -eq 0 ]];
#        then
	if printf '%s\n' "${subsystemNames[@]}" | grep -q "$parentDir"; then
         	echo "contain $ssName.ss $parentDir.ss"
       	else
#		echo "$parentDir"
                grep "\$INSTANCE" $rawTaFile | grep -v "\/contrib" | grep -v "\/test" | grep -E "$parentDir\/[a-zA-Z0-9\_\-]+\.(c|h|cpp)"
		grep "\$INSTANCE" $rawTaFile | grep -v "\/contrib" | grep -v "\/test" | grep -E "$parentDir\/[a-zA-Z0-9\_\-]+\.(c|h|cpp)" | sed 's/$INSTANCE//g' | sed 's/cFile//g' | sed "s/^/contain $ssName.ss/g"
        fi
#	fi
	for childDir in "${childDirs[@]}"
	do
		child=$(echo "$childDir" | sed 's/ //g')
		echo "\$INSTANCE $child.ss cSubSystem"
		grep "\$INSTANCE" $rawTaFile | grep -v "\/contrib" | grep -v "\/test" | grep "$parentDir\/$child"
		grep "\$INSTANCE" $rawTaFile | grep -v "\/contrib" | grep -v "\/test" | grep "$parentDir\/$child" | sed 's/$INSTANCE//g' | sed 's/cFile//g' | sed "s/^/contain $child.ss/g"
		echo "contain $ssName.ss $child.ss"
	done
}

render_containment () {
for subsystem in "${subsystems[@]}"
do
        IFS=' ' read -r -a array <<< $(sed "s/$subsystemTag://g" <<< $subsystem | sed 's/=//g' | sed 's/^[[:space:]]//')
	ssName=""
        for containment in "${array[@]}"
        do
                if [[ "$containment" == "${array[0]}" ]];
                then
			echo "\$INSTANCE $containment.ss cSubSystem"
        		ssName=$(echo "$containment")
                else
			extract_containments $ssName $containment
                fi
        done

done
}

echo "FACT TUPLE :" > $outputFile
render_containment >> $outputFile
inclusions=$(grep "src\/" $subsystemSpec | tr "\n" " " | sed 's/ /\|/g' | rev | cut -c3- | rev)
grep "cLinks" $rawTaFile | grep -v "\/contrib" | grep -v "\/test" | awk  -v pattern="$inclusions" '$2~pattern' | awk  -v pattern="$inclusions" '$3~pattern' | sort >> $outputFile

