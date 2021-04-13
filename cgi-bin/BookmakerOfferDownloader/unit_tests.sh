source /var/www/cgi-bin/environment.sh
perl $@ $BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY/tests/unit_tests/BetExplorerDownloader/BetExplorerDownloader_test.pl

if [ $? == 0 ]
then
perl $@ $BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY/tests/unit_tests/BetexplorerParser/BetexplorerParser_test.pl
fi

if [ $? == 0 ]
then
perl $@ $BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY/tests/unit_tests/HTML_EventsTableParser/HTML_EventsTableParser_test.pl
fi



