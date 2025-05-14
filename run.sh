#!/bin/bash

# Stop any existing Tomcat instance
pkill -f tomcat || true

# Make sure the script directory exists
mkdir -p target/classes

# Compile Java files
echo "Compiling Java files..."
find src/main/java -name "*.java" | xargs javac -d target/classes -cp "src/main/webapp/WEB-INF/lib/*:target/classes:$(find /usr/share -name "servlet-api.jar" 2>/dev/null | head -1)"

# Copy webapp files
echo "Copying web files..."
mkdir -p target/MBC_HOSPITAL
cp -r src/main/webapp/* target/MBC_HOSPITAL/

# Start Tomcat
echo "Starting Tomcat..."
export CLASSPATH="target/classes:src/main/webapp/WEB-INF/lib/*:$(find /usr/share -name "catalina.jar" 2>/dev/null | head -1):$(find /usr/share -name "servlet-api.jar" 2>/dev/null | head -1)"

# Use either catalina.sh or try to run a standalone Tomcat
if [ -f "$(which catalina.sh 2>/dev/null)" ]; then
    catalina.sh run
else
    # Try to find installed Tomcat
    TOMCAT_HOME=$(find /usr -name "catalina.sh" 2>/dev/null | head -1 | xargs dirname | xargs dirname)
    if [ ! -z "$TOMCAT_HOME" ]; then
        echo "Found Tomcat at $TOMCAT_HOME"
        $TOMCAT_HOME/bin/catalina.sh run
    else
        echo "Could not find Tomcat. Please make sure Tomcat is installed or configure the script properly."
        exit 1
    fi
fi 