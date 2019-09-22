#!/bin/sh
#set -ex
SAVE_DIR=/var/www/html
SRC_URL="$1"
SAVE_NAME="$2"
if [[ -z ${SRC_URL} ]]; then
  echo "Error: Can not found URL!"
  echo "Usage: $0 <URL> [save-name.xxx]"
  exit 1
fi
if [[ -z ${SAVE_NAME} ]]; then
  LOG_DIR="$(date '+%Y%m%d-%H%M%S')"
  SAVE_PATH="-P ${SAVE_DIR}"
else
  LOG_DIR="${SAVE_NAME}.log"
  SAVE_PATH="-O ${SAVE_DIR}/${SAVE_NAME}"
fi
LOG_PATH="${SAVE_DIR}/${LOG_DIR}"
if [[ ! -d ${LOG_PATH} ]]; then
  mkdir -p ${LOG_PATH}
fi
if [[ ! -f ${LOG_PATH}/nohup.out ]]; then
  touch ${LOG_PATH}/nohup.out
  chmod 644 ${LOG_PATH}/nohup.out
fi
if [[ ! -x ${LOG_PATH}/index.sh ]]; then
  cat << EOF > ${LOG_PATH}/index.sh
#!/bin/sh
echo -e "Content-Type:text/html;\n"
echo -e '<html>\n<meta http-equiv="refresh" content="5">\n'
echo "Download file from URL: ${SRC_URL}<br><br>"
if [[ \$(wc -l nohup.out | awk '{print\$1}') -gt 40 ]]; then
  head -20 nohup.out | awk '{print"<code>"\$0"</code><br>"}' | sed 's/  /\\&nbsp/g'
  echo '<br>'
  tail -20 nohup.out | awk '{print"<code>"\$0"</code><br>"}' | sed 's/  /\\&nbsp/g'
else
  cat nohup.out | awk '{print"<code>"\$0"</code><br>"}' | sed 's/  /\\&nbsp/g'
fi
echo '</html>'
EOF
  chmod +x ${LOG_PATH}/index.sh
fi
nohup wget -c ${SAVE_PATH} --header="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) \AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36 " \
--header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3" \
--header="Accept-Encoding: gzip, deflate " --header="Accept-Language: zh-CN,zh;q=0.9,en-US;q=0.8,en;q=0.7" "${SRC_URL}" > ${LOG_PATH}/nohup.out 2>&1 &
echo -e "wget ${SRC_URL} started, \nlog could be found in ${LOG_DIR}/nohup.out"

