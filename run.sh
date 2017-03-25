#!/bin/bash


usage() {
cat << EOF

Usage: run.sh --name NAME

--port PORT
--data DATA_PATH
--mem MB
<<<<<<< HEAD
--docker-login LOGIN
--docker-password PASSWORD
--docker-email EMAIL
--docker-pull [true|false]
EOF
}


IMAGE=egis/docker-build-slave

while [[ $# -gt 1 ]]
do
	key="$1"
	case $key in
	    -n|--name)
	    NAME="$2"
	    shift # past argument
	    ;;
	    --data)
	    DATA="$2"
	    shift # past argument
	    ;;
	    -p|--port)
	    PORT="$2"
	    shift # past argument
	    ;;
	    --mem)
	    MEM="$2"
	    shift # past argument
	    ;;
            --docker-login)
            LOGIN="$2"
            shift # past argument
            ;;
            --docker-password)
            PASSWORD="$2"
            shift # past argument
            ;;
            --docker-email)
            EMAIL="$2"
            shift # past argument
            ;;
            --docker-pull)
            DOCKER_PULL=true
            shift # past argument
            ;;
	    *)
	    usage
	    exit 0
	    ;;
	esac
	shift
done

DATA=${DATA:-/opt/Data}/$NAME
PORT=${PORT:-80}
MEM=${MEM:-512}
LOGIN=${LOGIN:-null}
PASSWORD=${PASSWORD:-null}
EMAIL=${EMAIL:-null}
DOCKER_PULL=${DOCKER_PULL:-false}

echo Name: $NAME

if [ "$NAME" == "" ]; then
	usage
	exit 0
fi

cat << EOT > $NAME.env
MEM=${MEM}
PORT=${PORT}
VIRTUAL_HOST=$NAME.papertrail-dev.com
DATA=${DATA}
EOT

docker stop $NAME ; docker rm $NAME

docker run -d -i --privileged --env-file=$NAME.env \
		-e "LOGIN=$LOGIN" \
		-e"PASSWORD=$PASSWORD" \
		-e"EMAIL=$EMAIL" \
		-e"DOCKER_PULL=$DOCKER_PULL" \
		-p ${PORT}:${PORT} \
		-v ${DATA}:/data \
		--name=$NAME $IMAGE

docker logs -f $NAME
