#!/bin/bash

rm -f ~/modele-support/prod_runs/r01/lock

pushd ~/local/modele/decks

DEBUG_COMMAND="gdb --args" ../exec/runE r01 -d -cold-restart

popd
