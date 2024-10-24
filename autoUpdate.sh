#!/bin/bash
#set -e
#set -x

BRANCHS=(
	run
	build
	script
	)

git remote -v|grep upstream|grep 'github.com/AlexandreRouma' >/dev/null
if [ "${PIPESTATUS[0]}" -ne 0 ]
then
	echo list remote failed
	exit 1
fi

git remote -v|grep upstream|grep 'github.com/AlexandreRouma' >/dev/null
if [ "${PIPESTATUS[1]}" -ne 0 ]
then
	echo add upstream
	git remote add upstream https://github.com/AlexandreRouma/SDRPlusPlus.git
fi

git remote -v|grep upstream|grep 'github.com/AlexandreRouma' >/dev/null
if [ "${PIPESTATUS[2]}" -ne 0 ]
then
	echo upstream is not as need
	exit 1
fi


echo fetch origin
git fetch -p origin
echo fetch upstream
git fetch -p upstream
echo
echo
echo
echo




echo ============================
echo rebase local branch on upstream
echo ----------------------------
echo -n "rebase on upstream now? "'(yes/No, default No)  '
read I;
case "$I" in
	y*|Y*)
		for B in base ${BRANCHS[@]} script
		do
			echo ----------------------------
			echo rebase ${B} ...
			rm -fr zbuild.sh sdrpp-dev.desktop autoUpdate.sh
			#rm -fr root/res/bandplans/republic-of-korea.json
			git branch | grep -q ${B}
			if [ "${PIPESTATUS[1]}" -ne 0 ]
			then
				git checkout -b ${B} origin/${B}
			fi
			git checkout -f ${B}
			while [ 1 ]
			do
				git rebase upstream/master
				if [ $? -eq 0 ]
				then
					break
				fi
				echo -n "Press Enter after Resolve all conflicts manually"
				read I;
			done
		done
		;;
	n*|N*|*)
		exit 0
		;;
esac
echo ----------------------------

echo
echo
echo




echo ============================
echo merge to master
echo ----------------------------
echo checkout master
git checkout -f master
echo ----------------------------
echo reset
git reset HEAD~4
rm -fr zbuild.sh sdrpp-dev.desktop autoUpdate.sh
#rm -fr root/res/bandplans/republic-of-korea.json
git checkout -f .
echo ----------------------------
echo rebase upstream
while [ 1 ]
do
	git rebase upstream/master
	if [ $? -eq 0 ]
	then
		break
	fi
	echo -n "Press Enter after Resolve all conflicts manually"
	read I;
done
echo ----------------------------
for B in ${BRANCHS[@]}
do
	echo master rebase ${B}
	git rebase ${B}
	echo ----------------------------
done

echo
echo
echo




echo ============================
echo push local branch to Origin
echo ----------------------------
echo -n "push now? "'(yes/No, default No)  '
read I;
case "$I" in
	y*|Y*)
		for B in base ${BRANCHS[@]} script master
		do
			echo ----------------------------
			#git checkout -f ${B}
			echo push ${B} ...
			git push -f origin ${B}:${B}
		done
		;;
	n*|N*|*)
		exit 0
		;;
esac
echo ----------------------------

echo
echo
echo



echo ============================
echo 'prune & gc'
echo ----------------------------
git prune
#git gc
echo ----------------------------

echo
echo
echo





