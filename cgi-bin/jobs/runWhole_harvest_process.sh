#!/bin/sh

source /var/www/cgi-bin/environment.sh && cd /var/www/cgi-bin/ && /var/www/cgi-bin/runForAll_inputFiles.pl --delay=20..90 && cd jobs/ && ./uploadLastSurebets_to_server.sh
