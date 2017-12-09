#!/usr/bin/env bash

source ~/backup-manager/.env

for i in "${MYSQL_DATABASES[@]}"
do
   FILE_NAME="$i-`date +%Y_%m_%d_%H_%M`.sql.gz"
   TMP_DIR=${ROOT_DIR}/tmp;
   DATABASE=$i;

   mysqldump -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${DATABASE} | gzip > ${TMP_DIR}/${FILE_NAME}

   if [ -e ${TMP_DIR}/${FILE_NAME} ]; then
    aws s3 cp ${TMP_DIR}/${FILE_NAME} s3://${S3_BUCKET}/${S3_ROOT}/${FILE_NAME}
    if [ "$?" -ne "0" ]; then
        echo "Upload to AWS failed"
    fi
    rm ${TMP_DIR}/${FILE_NAME}
fi

echo "Backup file not created"
exit 1
done
exit;