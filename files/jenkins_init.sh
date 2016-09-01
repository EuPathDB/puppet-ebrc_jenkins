## Start Per Instance Settings
INSTANCE=$1
source "/etc/jenkins/${INSTANCE}.conf"
## End Per Instance Settings

# condense whitespace
JAVA_OPTS="$(echo $JAVA_OPTS_WS)"
JENKINS_OPTS="--httpPort=${HTTP_PORT} --httpListenAddress=${LISTEN_ADDR} --ajp13Port=${AJP_PORT} --ajp13ListenAddress=${LISTEN_ADDR}"
# see "java -jar jenkins.war --help" for full options

export JENKINS_HOME

JENKINS_WAR="${JENKINS_HOME}/jenkins.war"
JENKINS_LOG="/var/log/jenkins/${INSTANCE_NAME}.log"
export JAVA_HOME="/usr/java/latest"
JAVA="${JAVA_HOME}/bin/java"

BASE_START_CMD="${JAVA} ${JAVA_OPTS} -jar ${JENKINS_WAR} ${JENKINS_OPTS}"
START_CMD="nohup ${BASE_START_CMD} >> ${JENKINS_LOG} 2>&1 &"

echo -n starting jenkins...

/bin/bash -c "$START_CMD"
