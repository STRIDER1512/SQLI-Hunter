#!/bin/sh

# This script will find all the vulnerabilities in the DBMS using SQLMAP and save them in a file called result.txt

if ! [ -d "sqlmap" ]; then
    echo "Installing Dependencies..."
    echo "Please wait..."
    echo "Installing Python and Git"
    sudo apt-get update > /dev/null
    sudo apt-get install -y python3 git > /dev/null
    git clone https://github.com/sqlmapproject/sqlmap.git >/dev/null 2>&1
    echo "Dependencies Installed Successfully!"
fi

if [ -d "sqlmap" ]; then
    cd sqlmap
    git pull > /dev/null
else
    echo "SQLMAP directory not found."
    exit 1
fi

if [ -z "$1" ]; then
    echo "Enter the URL to find the vulnerabilities:"
    read url
else
    url=$1
fi

case $url in
    http://|https://)
        ;;
    *)
        echo "Please provide a valid URL"
        exit 1
        ;;
esac

echo "Running SQLMAP on $url , please wait..."
python3 sqlmap.py -u "$url" --batch --dbs --random-agent --level=5 --risk=3 --threads=1 --delay=5 --timeout=60 --dbms="MySQL" --tamper="space2comment,between" > result.txt
mv result.txt ..

echo "Vulnerability scan complete. Results saved in result.txt"
