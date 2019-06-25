#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Usage: ./run.sh outputFolderName"
        exit 1
fi

homePath="/e/JMeter/client_jmeter"
output=$1

/e/apache-jmeter-5.1.1/apache-jmeter-5.1.1/bin/jmeter.sh -n -t /e/JMeter/scsc_jmeter/scsc/Recording_Group.jmx -j $homePath/output/$output/1/run.log -l $homePath/output/$output/1/result.jtl -e -o $homePath/output/$output/1/html &
/e/apache-jmeter-5.1.1/apache-jmeter-5.1.1/bin/jmeter.sh -n -t /e/JMeter/scsc_jmeter/scsc/Recording_Group2.jmx -j $homePath/output/$output/2/run.log -l $homePath/output/$output/2/result.jtl -e -o $homePath/output/$output/2/html &

sleep 10s

cp /e/JMeter/scsc_jmeter/scsc/script/cal.sh $homePath/output/$output/1/
cp /e/JMeter/scsc_jmeter/scsc/script/cal.sh $homePath/output/$output/2/

