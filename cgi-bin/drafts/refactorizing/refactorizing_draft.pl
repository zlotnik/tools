
# 1.  sport events selector
# 2.  xml with sport events
# 3.  xml with bookmaker offer
# 4.  profitability xml

my $eventSelectorPath = "polish_firstLeague_selector.xml";
my $sportEventSelector = SportEventSelector->new($eventSelectorPath);

$sportEventSelector->saveToXML("polish_firstLeague_eventList.xml")

SportEventsList->new()

