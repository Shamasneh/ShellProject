#!/bin/bash

isValid() {
	string=$1
	i=1
	stack=""
	count=0
	noc=0
	valid=1
	prev_char=""
	vpass=0
	prev_char_is_arithmatic=0
	noc=`echo $string | wc -c`
	noc=`expr $noc - 1`
	while [ $i -le $noc ] #cut the exprision into characters
	do
	char=`echo $string | cut -c$i` #get the character
	char_is_arithmatic=0
	case $char 
	in 
		[a-zA-Z])
			valid=0
			break 
			;;
		'(')
			stack=$stack$char
			count=`expr $count + 1`;;
	
		')') 

			if [ "$count" -eq 0 ]
			then
				valid=0
				break; 
			fi
			if [ "$count" -gt 1 ]
			then 
			count=`expr $count - 1`
			stack=`echo $stack | cut -c1-$count`
			else 
			stack=""
			count=0
			fi
			;;

		'+');&
		'-');&
		'*');&
		'/');&
		'%')
			char_is_arithmatic=1
			;;
	esac
	if [ "$i" -eq 1 -a "$char_is_arithmatic" -eq 1 ]
	then
		valid=0
	fi

	if [ "$char_is_arithmatic" -eq 1 -a "$prev_char_is_arithmatic" -eq 1 ]
	then
		valid=0
	fi

	if [ "\\$char" = "\)" -a "\\$prev_char" = "\(" ]
	then
		valid=0
		
	fi
	prev_char=$char
	prev_char_is_arithmatic=$char_is_arithmatic
	i=`expr $i + 1`		
	done
	if [ "$valid" -eq 1 -a "$count" -eq 0 ]
		then
			echo 1
		else
			echo 0
		fi

		
}


####################################################################
#Read equations from file,and save them into array lines.
####################################################################
echo "enter file name to read from it "
#read fname
fname="exp.txt"
if [ -z "$fname" ]
then
	exit
fi
exec < $fname

i=0
while read line 
do
	array[$i]="$line"
	i=$(($i+1))
done
numOFequations=$i

####################################################################
#   Print the content of the array 
####################################################################
for((n=0;n<numOFequations;n++))
do
	
	echo -n "${array[$n]}        :"
	r=$(isValid ${array[$n]})
	
	if [ "$r" -eq 1  ]
	then 
		echo "Valid"
	else
		echo "Invalid"
	fi
done
