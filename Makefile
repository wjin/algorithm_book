all:
	pandoc --toc -s -S -N -o algorithm.pdf `ls contents/*.md`
