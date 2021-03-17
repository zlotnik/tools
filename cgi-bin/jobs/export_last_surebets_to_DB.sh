#!/bin/sh
#
#
source /var/www/cgi-bin/environment.sh
php $JOBS_DIRECTORY/export_last_surebets_to_DB.php
