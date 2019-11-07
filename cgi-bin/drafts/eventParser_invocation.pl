use HTML_1X2_Events_Parser;


my $eventParser = HTML_1X2_Events_Parser->new();

$eventParser->parse($filePath_WithEventHTML);


# my $eventBookOffers_1X2 = $eventParser->parse_1X2event($filePath_WithEventHTML);

# my $numberOfOffers = $eventBookOffers_1X2->get_NumberOfOffers();

# my $count = 0;
# while($count < $numberOfOffers)
# {
#     my $bookOffer = $eventABookOffer_1X2($count);
    
#     $bookOffer->get_bookmakerName();
#     print $bookOffer->get_1_price()
#     print $bookOffer->get_X_price()
#     print $bookOffer->get_2_price()
#     $count++;
# }



