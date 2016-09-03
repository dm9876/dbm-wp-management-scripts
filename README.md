# dbm-wp-management-scripts
backup & restore for wordpress database and files, transfer between staging and production (automatically making appropriate substitutions in the files and databases)

## assumptions / environment / prerequisites ##
- production url of the form
http://www.*
- production wordpress installed directly in the web root
~/public_html/
- staging url of the form
http://staging.*
- staging wordpress installed in /staging subdirectory of the web root ~/public_html/staging
- other unrelated subdirectories in the webroot may exist but must be specified
- the directory hosting these management scripts should be above the webroot (ie not publicly accessible) ~/dbm-wp-management-scripts
- backups are stored in folder at the same level ~/dbm-wp-backups

### Other tools ###
- php Search-Replace-DB tool
- dropbox uploader

### TODO maybe ###
- add gpg encryption of backup files
- consider robots.txt
- consider .htaccess for staging to require a password

## scripts ##

### dbm-wp-management-scripts.config ###
- defines variables for various credentials
- modify and rename dbm-wp-management-scripts.config.example 
- TODO consider to also remove more hard-coded paths as possible and define them here.

### backup_staging.sh ###

### backup_production.sh ###

### restore_staging.sh ###

### restore_production.sh ###

### restore_staging_to_production.sh ###

### restore_production_to_staging.sh ###





