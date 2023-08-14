#!/bin/bash

APP_PID=
stopRunningProcess() {
    # Based on https://linuxconfig.org/how-to-propagate-a-signal-to-child-processes-from-a-bash-script
    if test ! "${APP_PID}" = '' && ps -p ${APP_PID} > /dev/null ; then
       > /proc/1/fd/1 echo "Stopping ${COMMAND_PATH} which is running with process ID ${APP_PID}"

       kill -TERM ${APP_PID}
       > /proc/1/fd/1 echo "Waiting for ${COMMAND_PATH} to process SIGTERM signal"

        wait ${APP_PID}
        > /proc/1/fd/1 echo "All processes have stopped running"
    else
        > /proc/1/fd/1 echo "${COMMAND_PATH} was not started when the signal was sent or it has already been stopped"
    fi
}

trap stopRunningProcess EXIT TERM

source ${VIRTUAL_ENV}/bin/activate

BASEURLPATH=
if [ -z "$SERVER_SERVLET_CONTEXT_PATH" ]
then 
   echo "Context path not set"
else  
   BASEURLPATH=" --server.baseUrlPath=$SERVER_SERVLET_CONTEXT_PATH"
fi
echo "BASEURLPATH: $BASEURLPATH"

streamlit run ${HOME}/app/streamlit_app.py --server.port=8081 --logger.level=debug --browser.gatherUsageStats=False $BASEURLPATH & APP_ID=${!}

wait ${APP_ID}