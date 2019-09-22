#!/bin/sh
#set -ex
TARGET=$1
CLEAN_DIR=/var/www/html
echo "# du -sm ${CLEAN_DIR}/*"${TARGET}"*" && du -sm ${CLEAN_DIR}/*"${TARGET}"*
echo -e "\n# rm -rf ${CLEAN_DIR}/*${TARGET}*" && rm -rf ${CLEAN_DIR}/*"${TARGET}"* && echo "${CLEAN_DIR}/*${TARGET}* has been cleaned up."
echo -e "\n# du -sm *" && du -sm ${CLEAN_DIR}/* || echo 'None file.'
