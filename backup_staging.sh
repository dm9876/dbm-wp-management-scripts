#backup_staging.sh
#Dean Murray, 2016-09-03

#script to backup wordpress staging site, creates one archive for the files
#and another for the database, both datestamped
#overwrites any previous backups for the same date
#typically run ad-hoc, when you are ready to push staging to production
#typically followed by running restore_staging_to_production.sh

source ./dbm-wp-management-scripts.config

#check if backups folder exists and if not then create it
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir $BACKUP_DIR
fi

#todays date in YYYYMMDD format
DATE=`date +%Y%m%d`

#make a compressed archive of the website files with a datestamped file name
cd $WEBROOT_DIR/staging
tar cvzf $BACKUP_DIR/backup.tar.gz ./
cd $BACKUP_DIR
mv -f backup.tar.gz $DATE-staging-files.tar.gz

#dump the database for the website and compress it to a file with datestamped name
mysqldump --opt -u $S_DBUSER -p$S_DBPASS --host $DBHOST $S_DBNAME > backup.sql
gzip backup.sql
mv -f backup.sql.gz $DATE-staging-db.sql.gz
