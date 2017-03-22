#!/bin/bash


usage() {
cat << EOF

Usage: run.sh --name NAME

--port PORT
--data DATA_PATH
--mem MB
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

docker run -d -i --privileged --env-file=$NAME.env -p ${PORT}:${PORT} -v ${DATA}:/data --name=$NAME $IMAGE

docker logs -f $NAME
