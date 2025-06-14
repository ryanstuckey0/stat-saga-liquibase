#!/bin/bash

HEADER="----------------------------"
FOOTER="=================================================================================="

# start H2
echo "$HEADER Starting H2 $HEADER"
liquibase init start-h2 --launch-browser=false > h2.log & 
sleep 2
echo $FOOTER
echo
echo

# get H2 PID
liquibase_pid="$(ps | grep 'liquibase-core.jar init start-h2' | grep -v grep | grep -oE '^[0-9]*')"
echo "H2 PID: $liquibase_pid"

# get H2 browser URL
browser_url=$(cat h2.log | grep -E "Dev Web URL:" | grep -oE "http://localhost:8080/frame.jsp\?jsessionid=[0-9a-z]*")
echo "H2 browser URL: $browser_url"
rm h2.log

# run init updates
echo "$HEADER Liquibase init changes running $HEADER"
cd init
liquibase update
echo $FOOTER
echo
echo

# run regular Liquibase updates
echo "$HEADER Liquibase init changes running $HEADER"
cd ..
liquibase update
echo $FOOTER
echo
echo

echo "Liquibase updates complete. Check output for status."

# wait for user to request kill or open in browser
user_input="a"
while [ $user_input !=  "k" ]
do
    read -p "Press k to kill H2 or b to open in browser: " user_input
    if [ $user_input == "b" ]; then
        echo "Opening in browser..."
        open $browser_url
    fi
done

echo "Killing H2..."
kill $liquibase_pid
sleep 2

echo "H2 has been shutdown. Exiting script"
