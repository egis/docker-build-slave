#!/usr/bin/env bash

shutdown() {
  echo "Shutdown ..."
  service docker stop
  service mysql stop
  service postgresql stop
}

#Catch signal when 'docker stop' command is issued
trap 'shutdown' 1
trap 'shutdown' 2
trap 'shutdown' 3
trap 'shutdown' 15


service docker start
service mysql start
service postgresql start

# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done

