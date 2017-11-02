use strict;
    use WWW::Mechanize::PhantomJS;
    
    my $mech = WWW::Mechanize::PhantomJS->new( );
    # $mech->get('http://google.com');
    $mech->get('http://www.betexplorer.com/soccer/germany/bundesliga/mainz-schalke/GEcPMEM6/');
    
	$mech->eval_in_page('alert("Hello PhantomJS")');
    
	
	
	sleep 2;
	my $png= $mech->content_as_png();
    print $mech->text();
    #print $_->get_attribute('href'), "\n\t-> ", $_->get_attribute('innerHTML'), "\n"
     # for $mech->selector('a.download');
    
    