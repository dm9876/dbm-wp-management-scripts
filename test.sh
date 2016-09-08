source ./dbm-wp-management-scripts.config

#for db search and replace
STAGING_URL=http://staging.berowrabaptist.org.au
PRODUCTION_URL=http://www.berowrabaptist.org.au

###################


####################

#modify db references from staging to production

#Replace: staging url
#With: production url

$PHP_BIN ~/Search-Replace-DB-master/srdb.cli.php -h $DBHOST -u $S_DBUSER -n $S_DBNAME -p $S_DBPASS -s "$STAGING_URL" -r "$PRODUCTION_URL" --dry-run

#only do this part once, multiple search and replace with this criteria will break the db
#Replace: /staging/
#With: /

$PHP_BIN ~/Search-Replace-DB-master/srdb.cli.php -h $DBHOST -u $S_DBUSER -n $S_DBNAME -p $S_DBPASS -s "/staging/" -r "/" --dry-run
