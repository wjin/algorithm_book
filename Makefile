all:
	cd contents && pandoc --toc -s -S -N -o algorithm.pdf `ls *.md`
	mv contents/algorithm.pdf .
	echo 'Done!'
