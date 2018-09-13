#!/bin/bash
# wait_for_db_complete.sh
set -e

host=${1}
shift
cmd="$@"

until nc -nz ${host} 3306 ; do
  >&2 echo "[ *** Notice *** ]: ${host} is unavailable - sleeping"
  sleep 3
done

>&2 echo "[ *** Notice *** ]: ${host} is up - executing command"
exec ${cmd}