#!/bin/bash
set -e
trap 'echo "there is an error in $LINENO, command is : $BASH_COMMAND"' ERR
echo "Hello.."
echo "before error"
embavc
echo "after error"
