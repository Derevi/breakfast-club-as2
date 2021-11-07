ROOT_FILE_NAME="postgresql-13.4"
postgresDir=$1
outputFileName=$2
currentDir=$(pwd)
outputFile=$(echo "$currentDir/$outputFileName")

cd $postgresDir

while true
do
	refPath=""
	echo "clear output file?[y/n]"
	read save
    case $save in
    n)
    echo "preparing to save request results..."
    ;;
	y)
	echo "clearing file..."
	echo "" > $outputFile
	;;
    *)
    echo "input not recognized"
    ;;
    esac
	read -e -p "enter in the path of the header file, or input the name of a function:  " functionsToAnalyze
    read -e -p "enter the path for the reference you are looking for. or leave empty to print all:  " refPath
	printf " \n\n------------------------------------------- Results for $functionsToAnalyze -------------------------------------------"
    if [[ $functionsToAnalyze == *".h" ]]; then
		IFS=$'\n' read -r -d '' -a functionNames <<< $(cat $functionsToAnalyze | grep -o "extern .*(" | sed -E "s/\(//g" | sed "s/extern //g" | awk '{print $2}' | sed 's/\*//g')
	else
		IFS=$'\n' read -r -d '' -a functionNames <<< $(echo "$functionsToAnalyze")
	fi

	
	for functionName in "${functionNames[@]}"
	do
	    echo "References for function: $functionName:"
		IFS=$'\n' read -r -d '' -a references <<< $(grep -rn "$functionName(" . | grep -v "\/include" | grep -v "\/test" | grep -v "\/contrib" |grep "$refPath")
	    if [ ${#references[@]} -gt 0 ]; then
    	   	echo "References for function: $functionName" >> $outputFile
			for reference in "${references[@]}"
        	do
				echo "the ref is $reference"
		        sourceFile=$(echo "$reference" | sed -E 's/^([^:]+):.*\(.*/\1/g' | cut -c2-)
       			refFunctionName=$(echo "$reference" | sed -E 's/.*\s+(.*)\(.*/\1/g')
       			sourceFilePath=$(echo "$postgresDir$sourceFile")
       			IFS=$'\n' read -r -d '' -a functions <<< $(cat $sourceFilePath |sed 's/@//g'| tr "\n" "@" | sed -E 's/@([a-zA-Z])/\n\1/g' | grep "^[A-Za-z].*(.*@")
       			for functionLine in "${functions[@]}"
       			do
           			IFS=$'@' read -r -d '' -a linesOfFunction <<< $(echo "$functionLine")
           			functionName=$(echo "${linesOfFunction[0]}" | sed -E 's/(.*)\(.*/\1/g')
           			for functionLine in "${linesOfFunction[@]}"
           			do
               			if grep -q $refFunctionName <<< $functionLine
               			then
                       			echo "$reference, called by function: $functionName"
              	        		echo "$reference, called by function: $functionName" >> $outputFile	
    	        		fi
         			done
       			done
			done
		fi
	done
done