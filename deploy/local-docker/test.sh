#!/bin/bash

HEADER="----------------------------"
FOOTER="=================================================================================="
user_input="a"

run_test () {
    export MYSQL_ROOT_USERNAME="$(op read op://statsaga-test/pgho2plq5p3sytjd7qvoel5lzq/username)"
    export MYSQL_ROOT_PASSWORD="$(op read op://statsaga-test/pgho2plq5p3sytjd7qvoel5lzq/password)"

    export MYSQL_LIQUIBASE_USERNAME="$(op read op://statsaga-test/7qfr2772onbsjilp7c2pzeogea/username)"
    export MYSQL_LIQUIBASE_PASSWORD="$(op read op://statsaga-test/7qfr2772onbsjilp7c2pzeogea/password)"

    export LIQUIBASE_COMMAND_USERNAME=$MYSQL_ROOT_USERNAME
    export LIQUIBASE_COMMAND_PASSWORD=$MYSQL_ROOT_PASSWORD

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

    export LIQUIBASE_COMMAND_USERNAME=$MYSQL_LIQUIBASE_USERNAME
    export LIQUIBASE_COMMAND_PASSWORD=$MYSQL_LIQUIBASE_PASSWORD

    # run regular Liquibase updates
    echo "$HEADER liquibase update: existing changes running $HEADER"
    cd ..
    liquibase update
    echo $FOOTER
    echo
    echo

    unset LIQUIBASE_COMMAND_USERNAME
    unset LIQUIBASE_COMMAND_PASSWORD

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
