#!/bin/bash

pushd ~/local/modele/decks

DEBUG_COMMAND="gdb --args" ../exec/runE r01 -d -cold-restart

popd
