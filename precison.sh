#!/bin/zsh
start="$(date +'%s.%N')"
for i in {1..500}
do
	$@
done
end="$(date +'%s.%N')"
runtime=$( echo "$end - $start" | bc -l )
((runtime /= 500))
echo "$runtime"
