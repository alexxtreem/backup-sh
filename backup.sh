#!/usr/bin/env bash
#Back script for files
#
#Set variables
startTime=$(date +%Y-%m-%d_%H-%M-%S)
#Path to S3 folder
cloudStorage=/mnt/s3selectel
#Add backup dir, and dir where we are would place our backup files
sourceDir=$(echo $1 | sed 's/\/\+$//')
backUpdir=$(echo $2 | sed 's/\/\+$//')
#
cd $backUpdir
echo "Backup is started at $startTime for $HOSTNAME"
dirname=$startTime'_'$HOSTNAME
tar -zcvPf $backUpdir/$dirname.tar.gz $sourceDir/
openssl enc -aes-256-cbc -in $backUpdir/$dirname.tar.gz -out $backUpdir/$dirname.tar.gz.enc -aes-256-cbc -a -pass file:/root/myfile
if [ -f $dirname.tar.gz.enc ]
then
	rm $dirname.tar.gz
fi
#Change location to cloud storage
cd $cloudStorage
pwd
rsync -avz --delete $backUpdir/$dirname.tar.gz.enc $coudStorage/

endTime=$(date +%Y-%m-%d_%H-%M-%S)
echo "Backup is finished at $endTime for $HOSTNAME"
