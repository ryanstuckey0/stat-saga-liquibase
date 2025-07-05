#!/bin/bash

HEADER="----------------------------"
FOOTER="=================================================================================="
user_input="a"

run_test () {
    # start H2
    echo "$HEADER Starting MySQL in Docker $HEADER"
    docker compose up -d
    sleep 10
    echo $FOOTER
    echo
    echo

    # run init updates
    echo "$HEADER liquibase update: init changes running $HEADER"
    cd init
    liquibase update
    echo $FOOTER
    echo
    echo

    # run regular Liquibase updates
    echo "$HEADER liquibase update: existing changes running $HEADER"
    cd ..
    liquibase update
    echo $FOOTER
    echo
    echo

    echo "Liquibase updates complete. Check output for status."
}

kill_h2() {
    echo "Killing MySQL..."
    docker compose stop
    docker container rm local-docker-db-1
    docker volume rm local-docker_mysql_vol
    echo "MySQL has been stopped"
}

setup_h2() {
    run_test
    # wait for user to request kill or open in browser
    while [ $user_input !=  "k" ] && [ $user_input != "r" ]
    do
        read -p "Press r to restart script with a new MySQL instance or k to kill H2 instance and exit: " user_input
        if [ $user_input == "u" ]; then
            echo "Running Liquibase update"
            liquibase update
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
