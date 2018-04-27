#!/bin/bash

set -e

./ioq3ded.x86_64 +set dedicated 1 +set fs_game cpma +set vm_game 2 +exec server.cfg +exec cpma.cfg +exec levels.cfg
