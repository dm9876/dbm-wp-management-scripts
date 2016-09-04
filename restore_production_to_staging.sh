#restore_production_to_staging.sh
#Dean Murray, 2016-09-04

#script to restore wordpress production backup to staging site
#uses the archives created by backup_production.sh
#run this script interactively and identify the date of files to restore

source ./dbm-wp-management-scripts.config

ls $BACKUP_DIR/*production*

printf "Enter the date of the production backup to restore to staging site using the format YYYYMMDD:"
read STR

#check that both file and db archives exist for the chosen date
if [ ! -f "$BACKUP_DIR/$STR-production-files.tar.gz" ]; then
  echo "The file '$BACKUP_DIR/$STR-production-files.tar.gz' does not exist"
  exit
fi

if [ ! -f "$BACKUP_DIR/$STR-production-db.sql.gz" ]; then
  echo "The file '$BACKUP_DIR/$STR-production-db.sql.gz' does not exist"
  exit
fi

#clear destination directory and restore archive there
cd $WEBROOT_DIR/staging/
rm -rf
tar xvzfp $BACKUP_DIR/$STR-production-files.tar.gz -C $WEBROOT_DIR/staging/

#restore database
cd $BACKUP_DIR
gzip -d -c ./$STR-production-db.sql.gz > $STR-production-db.sql
mysql --user=$S_DBUSER --password=$S_DBPASS --host=$DBHOST $S_DBNAME < $STR-production-db.sql
rm ./$STR-production-db.sql

#modify the database credentials in the wp-config.php file
cd $WEBROOT_DIR/staging/
sed -i "/DB_NAME/c\define('DB_NAME', '$S_DBNAME');" ./wp-config.php
sed -i "/DB_USER/c\define('DB_USER', '$S_DBUSER');" ./wp-config.php
sed -i "/DB_PASSWORD/c\define('DB_PASSWORD', '$S_DBPASS');" ./wp-config.php
sed -i "/DB_HOST/c\define('DB_HOST', '$DBHOST');" ./wp-config.php

#TODO search and replace references in the database
$PHP_BIN ~/Search-Replace-DB-master/srdb.cli.php -h $DBHOST -u $S_DBUSER -n $S_DBNAME -p $S_DBPASS -s "findMe" -r "replaceMe" --dry-run
