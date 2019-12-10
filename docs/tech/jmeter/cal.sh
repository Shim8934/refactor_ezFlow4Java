#!/bin/bash

grep "Thread start" run.log > start.log
grep "Thread finish" run.log > finish.log

start_time=`head -1 start.log | awk '{print $1, $2}'`
finish_time=`tail -1 finish.log | awk '{print $1, $2}'`

sed -i 's/-\(..\)$/-0\1/g;s/-\(.\)$/-00\1/g' finish.log
sort -k 9 finish.log > finish.log.sorted
cat start.log | awk '{print $1, $2}' > start.log.time
cat finish.log.sorted | awk '{print $1, $2}' > finish.log.time
sed -i 's/^/date -d "/g;s/$/" +%s.%3N/g' start.log.time
sed -i 's/^/date -d "/g;s/$/" +%s.%3N/g' finish.log.time
sh start.log.time > start.log.csv
sh finish.log.time > finish.log.csv
paste finish.log.csv start.log.csv > times.log

total=0
result=0
count=0

while read F S
do
        count=`echo "$count + 1" | bc`
        result=`echo "$F - $S" | bc`
	echo $result
        total=`echo "$total + $result" | bc`
done < times.log > response.log

avg=`echo "scale=3;$total / $count" | bc`

paste times.log response.log > result.log.csv
sed -i 's/\s/,/g' result.log.csv

echo "start_time: $start_time" >> result.log.csv
echo "finish_time: $finish_time" >> result.log.csv
echo "thread: $count" >> result.log.csv
echo "avg: $avg second" >> result.log.csv

rm -f start.* finish.* response.* times.*

