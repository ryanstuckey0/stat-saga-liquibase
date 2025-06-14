#!/bin/bash

HEADER="----------------------------"
FOOTER="=================================================================================="
user_input="a"

run_test () {
    # start H2
    echo "$HEADER Starting H2 $HEADER"
    liquibase init start-h2 --launch-browser=false > h2.log & 
    sleep 2
    echo $FOOTER
    echo
    echo

    # get H2 PID
    h2_pid="$(ps | grep 'liquibase-core.jar init start-h2' | grep -v grep | grep -oE '^[0-9]*')"
    echo "H2 PID: $h2_pid"

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
}

kill_h2() {
    echo "Killing H2..."
    kill $h2_pid
    sleep 2
    echo "H2 has been killed."
}

setup_h2() {
    run_test
    # wait for user to request kill or open in browser
    while [ $user_input !=  "k" ] && [ $user_input != "r" ]
    do
        read -p "Press b to open H2 console in browser, r to restart script with a new H2 instance, or k to kill H2 instance and exit: " user_input
        if [ $user_input == "b" ]; then
            echo "Opening in browser..."
            open $browser_url
        fi
    done
    kill_h2
}

script_flow() {
    while [ $user_input != "k" ]
    do
        user_input="a"
        setup_h2
        if [ $user_input == "r" ]; then
            echo "Restarting script..."
        fi
    done
}

script_flow
echo "Exiting script"
