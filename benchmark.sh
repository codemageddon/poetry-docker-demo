#!/bin/bash

SCENARIOS=("01-simple" "02-simple-slim" "03-multistage" "04-no-root" "05-final" "06-final-slim-build")
RESULT_FILE="results.txt"


cleanup() {
    echo "Cleaning up docker environment"
    docker image prune -af 2>&1 1>/dev/null
    docker system prune -af --volumes 2>&1 1>/dev/null
}

measure() {
    cmd=$1
    TIMEFORMAT='%R';
    result="$(time ($cmd 2>&1 1>/dev/null) 2>&1 1>/dev/null )"
    echo ${result}
}

get_cmd() {
    scenario=$1
    echo "docker build -q -t ${scenario} -f ${scenario}.Dockerfile ."
}

run_scenario() {
    scenario=$1
    echo "Benchmarking scenario: $scenario"
    
    cleanup
    local cmd="$(get_cmd $scenario)"
    local cold=$(measure "${cmd}")
    local warm=$(measure "${cmd}")
    echo "$cold"
}

for scenario in ${SCENARIOS[@]}; do
    echo "Benchmarking scenario: $scenario"
    run_scenario $scenario
done