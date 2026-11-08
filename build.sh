#!/bin/sh
# Builds titania.jar from src/titania.a68 and the files it includes.
#
# Environment:
#   JAVA        the java launcher of JDK 25 or later (default: java)
#   A68J_HOME   directory with a68j-backend.jar and a68j-runtime.jar
#               (default: ../a68j/backend)
set -e

cd "$(dirname "$0")"
JAVA=${JAVA:-java}
A68J_HOME=${A68J_HOME:-../a68j/backend}

"$JAVA" -jar "$A68J_HOME/a68j-backend.jar" src/titania.a68 -d titania.jar
