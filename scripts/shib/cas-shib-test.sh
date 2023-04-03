#!/bin/zsh

echo "Shutting down running shib containers ..."
docker stop shib
echo "Done"

if [ "$#" -lt 1 -o "$#" -gt 2 ]
then
    echo "Usage 1: $0 PRESET_NETWORK_ENV (office, living_room, bedroom, etc.)" >&2
    echo "Usage 2: $0 CUSTOM_NETWORK_ENV IP_ADDRESS (custom 192.168.1.5)" >&2
    exit 0
fi

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
    then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
                && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

if [ "$1" = "cos" ]
then
    SERVER_HOST="192.168.1.3"
    echo "Using COS office IP: ${SERVER_HOST}"
elif [ "$1" = "home_1" ]
then
    SERVER_HOST="10.0.0.9"
    echo "Using home office IP: ${SERVER_HOST}"
elif [ "$1" = "home_2" ]
then
    SERVER_HOST="192.168.1.6"
    echo "Using other IP: ${SERVER_HOST}"
elif [ "$1" = "custom" ]
then
    if valid_ip $2
    then
        SERVER_HOST=$2
    else
        echo "Invalid IP Address: ${2}"
        exit 0
    fi
else
    echo "Unknown Network Environment: ${1}" >&2
    exit 0
fi

DIR="./shibboleth-test"
cd $DIR
echo "CD into ${DIR}"

echo "Starting shibboleth ..."
docker run -d --name shib --rm -it -v $PWD/conf:/etc/shibboleth -v $PWD/httpd/conf.d:/etc/httpd/conf.d --add-host=cas:$SERVER_HOST --expose 443 -p 443:443 quay.io/centerforopenscience/shibboleth-sp
echo "Done"
cd ..
echo "Showing logs ..."
docker logs --follow shib
