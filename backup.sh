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
echo "### * ### * ###"
cd $backUpdir
echo "Backup is started at $startTime for $HOSTNAME"
echo "### * ### * ###"
dirname=$startTime'_'$HOSTNAME
echo "Start archiving suorce directiorie $backUpdir"
tar -zcvPf $backUpdir/$dirname.tar.gz $sourceDir/

echo "### * ### * ###"
echo "Start encription source file"
openssl enc -aes-256-cbc -in $backUpdir/$dirname.tar.gz -out $backUpdir/$dirname.tar.gz.enc -aes-256-cbc -a -pass file:/root/myfile
echo "### * ### * ###"
echo "If encription success, remove archive" 
if [ -f $dirname.tar.gz.enc ]
then
	rm $dirname.tar.gz
fi

echo "### * ### * ###"
echo "Check dirs $backUpdir $cloudStorage"
echo "Backup files to S3 storage."
rsync -avz --delete $backUpdir/$dirname.tar.gz.enc $cloudStorage

echo "### * ### * ###"
echo "Check coping files to S3 storage and remove source."
if [ -f $cloudStorage/$dirname.tar.gz.enc ]
then
	rm $backUpdir/$dirname.tar.gz.enc
else
	echo "### * ### * ###"
	echo "File $backUpdir/$dirname.tar.gz.enc dose not exist"
fi

endTime=$(date +%Y-%m-%d_%H-%M-%S)
echo "### * ### * ###"
echo "Backup is finished at $endTime for $HOSTNAME"
