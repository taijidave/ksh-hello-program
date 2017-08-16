#!/bin/ksh

#	"hello-program",	daVe	3/5/98

############
# 'screen header' function...
############
header()  {
clear			# clear screen, 'home' the cursor
cat <<++		# print the following text, until '++'

 ============>  HELLO!!!!  <=============	       ...by daVe...     3/5/98

    -> this is an old-fashioned 'hello'-program.
       simply press the number of the file or directory 
       you'd like to see. 
++
echo -n "    -> Enjoy!!				Today is:  "
date
echo
}



############
# 'mydir' function...
############
mydir()  {

while :
do

header
echo
echo "Here is a list of the directories at your current level..."
pwd
echo

if [ -f /tmp/hello_dave1_$$ ]
then rm /tmp/hello_dave1_$$
fi

ls -F | grep / > /tmp/hello_dave1_$$



# get the number of entries in the directory, & add 1 for loop
# purposes...
reps2=`wc -l /tmp/hello_dave1_$$ | awk '{print$1}'`
((reps2=$reps2 + 1))

i=1				# initialize loop-var


# print-out selection-choice, & selection-number
while [ $i -lt $reps2 ]
do
awk 'NR == '$i' {print "	"'$i'"	"$1}' /tmp/hello_dave1_$$

((i=$i + 1))
done 


# check if they'd like to cd...
echo
echo "	.	If you'd like to go 	UP a directory..."
echo


###################################
# get the user-selection

echo ""
echo "Please press a directory-# to change-to, "
echo -n "'return' for all-files, or 'q' to quit: "
read selection			# get user's entry for choice

if [ $selection ]
then
   if [ $selection == '.' ]
   then cd ..
   rm /tmp/hello_dave1_$$	# kill the tmp-file
   #mydir
   elif [ $selection == "q" ]; 	# check for exit-request
       then  
       echo ''
       rm /tmp/hello_dave1_$$	# kill the tmp-file
       exit 0 			# immed. exit
   else

# ...continue 'if'-statement...
# pull-out the filename they're referring to
filename=`awk 'NR == '$selection' {print $1}' /tmp/hello_dave1_$$`

# cd to new directory
echo ""
cd $filename
rm /tmp/hello_dave1_$$		# kill the tmp-file
#mydir


fi			 	# the original 'else', containing the
				# bulk of this script

fi 				# if they just hit 'return' when 
				# prompted for the first 'select'

if [ -f /tmp/hello_dave1_$$ ]
then rm /tmp/hello_dave1_$$
fi

return

done

}




#######################################
# main program...
#######################################

while :			# indefinite loop, until 'exit 0'
do

header
echo -n "Your current level is:  "
pwd
echo

# kill any previous existing tmp-file w/ the same name as i'm about to
# use...
if [ -f /tmp/hello_dave$$ ]
then rm /tmp/hello_dave$$
fi

# create a tmp-file containing the contents of the directory
ls -1 > /tmp/hello_dave$$

# get the number of entries in the directory, & add 1 for loop
# purposes...
reps=`wc -l /tmp/hello_dave$$ | awk '{print$1}'`
((reps=$reps + 1))

i=1				# initialize loop-var


# print-out selection-choice, & selection-number
while [ $i -lt $reps ]
do
awk 'NR == '$i' {print "	"'$i'"	"$1}' /tmp/hello_dave$$

((i=$i + 1))
done 

# check if they'd like to cd...
echo
echo "	.	If you'd like to go 	UP a directory..."
echo "	+	If you'd like a 	LIST of current directories..."
echo


###################################
# get the user-selection

echo ""
echo -n "Please enter your selection, $LOGNAME [or 'q' to quit]: "
read selection			# get user's entry for choice

if [ $selection ]
then
   if [ $selection == '.' ]
   then cd ..
       rm /tmp/hello_dave$$	# kill the tmp-file
       rm /tmp/hello_dave1_$$	# kill the tmp-file
   mydir
   elif [ $selection == "q" ]; 	# check for exit-request
       then  
       echo ''
       rm /tmp/hello_dave$$	# kill the tmp-file
       exit 0 			# immed. exit
   elif [ $selection == "+" ]; 	# check for directory-request
       then  
       echo ''
       rm /tmp/hello_dave$$	# kill the tmp-file
       mydir

   else

# ...continue 'if'-statement...
# pull-out the filename they're referring to
filename=`awk 'NR == '$selection' {print $1}' /tmp/hello_dave$$`

# print-out the filename
header
echo ""
if [ $filename ]
then
if [ -f $filename ]
then
   echo 'Here is the contents of the file "'$filename'":'
   echo
	more $filename
elif [ -d $filename ]
then
   echo 'Here is the contents of the directory "'$filename'":'
   echo
   cd $filename
   rm /tmp/hello_dave$$
   ls -1
fi
else
echo "Please choose a valid selection..."
echo
fi

# finish; ask for more...
echo ""
echo ""
echo "Press 'Return' to continue, or 'q' to quit. \c"	
read hold

if [ $hold ]
then
  if [ $hold == "q" ]; 		# check for exit-request
    then  
    echo ''
    if [ /tmp/hello_dave$$ ]
	 then
	 rm /tmp/hello_dave$$	# kill the tmp-file
    exit 0 						# immed. exit
	 fi
  fi 
fi

fi				# the original 'else', containing the
				# bulk of this script

fi				# if they just hit 'return' when 
				# prompted for the first 'select'

done				# finish'd loop, begin again @ the top


