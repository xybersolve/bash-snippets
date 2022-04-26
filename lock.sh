
# ------------------------------------------------------------
# using process
declare -r APP_NAME=$(basename "${SOURCE[0]}")
#declare -r PROC_PID=$(ps -C bash -o pid=,cmd= | grep ${APP_NAME});
declare -r PROC_PID="$(pgrep ${APP_NAME})";
if [[ "${PROC_PID}" != "$$" ]]; do
  echo Already locked
  exit 6
fi

# ------------------------------------------------------------
# using lock file
declare -r LOCKFILE=/var/tmp/myApp
mkdir -p /var/tmp/myApp
if ( set -o noclobber; echo "$$" > "${LOCKFILE}") 2> /dev/null; then
        trap 'rm -f "${LOCKFILE}"; exit $?' INT TERM EXIT
        # code here


        # clean up
        rm -f "${LOCKFILE}"
        trap - INT TERM EXIT
else
        echo "Lock Exists: ${LOCKFILE} owned by $(cat ${LOCKFILE})"
fi
