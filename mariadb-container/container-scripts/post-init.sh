# custom SQL schema during startup

if [ -v STARTUP_SQL ]; then
  for FILE in ${STARTUP_SQL}; do
    log_info "Loading startup SQL for ${CONTAINER_SCRIPTS_PATH}/${FILE} ..."
    echo "=> Importing SQL file ${FILE}"
    if [ "MYSQL_DATABASE" ]; then
      mysql $mysql_flags $MYSQL_DATABASE < "${CONTAINER_SCRIPTS_PATH}/${FILE}"
    else
      mysql $mysql_flags < "${CONTAINER_SCRIPTS_PATH}/${FILE}"
    fi  
  done
fi  

