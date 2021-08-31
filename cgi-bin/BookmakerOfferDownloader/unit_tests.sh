source /var/www/cgi-bin/environment.sh
perl $@ $BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY/tests/BetExplorerDownloader/BetExplorerDownloader_test.pl

if [ $? == 0 ]
then
perl $@ $BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY/tests/BetexplorerParser/BetexplorerParser_test.pl
else
exit
fi

if [ $? == 0 ]
then
perl $@ $BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY/tests/HTML_EventsTableParser/HTML_EventsTableParser_test.pl
else
exit
fi

if [ $? == 0 ]
then
perl $@ $BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY/tests/SportEvent/SportEvent_test.pl
else
exit
fi

if [ $? == 0 ]
then
perl $@ $BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY/tests/BookmakerXmlDataParser/BookmakerXmlDataParser_test.pl
else
exit
fi



