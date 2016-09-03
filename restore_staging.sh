#restore_staging.sh
#Dean Murray, 2016-09-03

#script to restore wordpress staging site, uses the archives created by backup_staging.sh
#run this script interactively and identify the date of files to restore

source ./dbm-wp-management-scripts.config

ls $BACKUP_DIR/*staging*

printf "Enter the date of the staging backup to restore using the format YYYYMMDD:"
read STR

#check that both file and db archives exist for the chosen date
if [ ! -f "$BACKUP_DIR/$STR-staging-files.tar.gz" ]; then
  echo "The file '$BACKUP_DIR/$STR-staging-files.tar.gz' does not exist"
  exit
fi

if [ ! -f "$BACKUP_DIR/$STR-staging-db.sql.gz" ]; then
  echo "The file '$BACKUP_DIR/$STR-staging-db.sql.gz' does not exist"
  exit
fi



#clear destination directory and restore archive there
cd $WEBROOT_DIR/staging/
rm -rf
tar xvzfp $BACKUP_DIR/$STR-staging-files.tar.gz -C $WEBROOT_DIR/staging/

#restore database
cd $BACKUP_DIR
gzip -d -c ./$STR-staging-db.sql.gz > $STR-staging-db.sql
mysql --user=$S_DBUSER --password=$S_DBPASS --host=$DBHOST $S_DBNAME < $STR-staging-db.sql
rm ./$STR-staging-db.sql
