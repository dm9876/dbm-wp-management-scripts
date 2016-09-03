#backup_production.sh
#Dean Murray, 2016-09-03

#script to backup wordpress production site, creates one archive for the files
#and another for the database, both datestamped
#overwrites any previous backups for the same date
#typically run as a daily cron job

source ./dbm-wp-management-scripts.config

#check if backups folder exists and if not then create it
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir $BACKUP_DIR
fi

#todays date in YYYYMMDD format
DATE=`date +%Y%m%d`

#make a compressed archive of the website files with a datestamped file name
#excludes unrelated subdirectories of the webroot
#TODO extract the defenition of excluded folders to the config file
cd $WEBROOT_DIR
tar --exclude='./aspire' --exclude='./staging' -cvzf $BACKUP_DIR/backup.tar.gz ./
cd $BACKUP_DIR
mv -f backup.tar.gz $DATE-production-files.tar.gz

#dump the database for the website and compress it to a file with datestamped name
mysqldump --opt -u $P_DBUSER -p$P_DBPASS --host $DBHOST $P_DBNAME > backup.sql
gzip backup.sql
mv -f backup.sql.gz $DATE-production-db.sql.gz

#based on this script being run daily, remove both files which are from X days ago
OLDDATE=$(date -d "-$DAYS_TO_KEEP days" +%Y%m%d)
rm $BACKUP_DIR/$OLDDATE-production-files.tar.gz
rm $BACKUP_DIR/$OLDDATE-production-db.sql.gz

#requires dropbox_uploader to be installed and configured
#https://github.com/andreafabrizi/Dropbox-Uploader
#if it is the first of day of the month then upload the two backup files
if [ $(date +%d) = "01" ]; then
    ~/dropbox_uploader/dropbox_uploader.sh -f ~/.dropbox_uploader upload $BACKUP_DIR/$DATE-production-* /
fi
