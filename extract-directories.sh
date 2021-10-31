# The first argument is the '.ta' file that you want to pull all the directories from. The output is sorted, and duplicates are removed

grep -v 'cLinks' $1 | grep -v 'FACT TUPLE' | sed -E -e 's/\/[a-zA-Z0-9\_\-]+\.(c|h|cpp) cFile//g' | sed -E -e 's/\$INSTANCE postgresql-13.4\///g' | awk '!seen[$0]++' | sort
