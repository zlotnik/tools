package HTML_1X2_Events_Parser;
# use parent qw(HTML::Parser);
use HTML::Parser;
our @ISA = qw(HTML::Parser);

sub new();


sub setState_inside_tbody();
sub setState_inside_tr();
sub unsetState_inside_tbody();
sub unsetState_inside_tr();
sub setState_inside_tbody();
sub unsetState_inside_td();
sub setState_inside_td();
sub setState_inside_td_with1_price();
sub unsetState_inside_td_with1_price();
sub append_to_parsingResults($);
sub set_1_price();
sub isInside_tbody();


sub append_to_parsingResults($)
{
	my ($self, $parsingResults) = @_;
	$self->{parsing_results} .= $parsingResults; 

};

sub get_parsingResults()
{
	
	return $self->{parsing_results};
}

sub setState_inside_tbody()
{	
	
}

sub isInside_tbody()
{
	return ($self->{inside_tbody_STATE} != 0);

}

sub new()
{
	
	my ($class) = @_;
	
	
	$self = bless {}, $class;
	
	$self->{htmlParser} = HTML::Parser->new(	api_version => 3,
                        			start_h => [\&start, "tagname, attr"],
                        			end_h   => [\&end,   "tagname"],
                        			marked_sections => 1,
                      			);
	
	$self->{parsing_results} = '';
	$self->{inside_tbody_STATE} = 0;
	$self->{td_number_in_tr_STATE} = 0;
	$self->{inside_td_STATE} = 0;
	$self->{inside_tr_STATE} = 0;
	
	return $self;
}

sub start 
{ 
	
	my ($tagname, $attr, $attrseq, $origtext) = @_;
	if ($tagname eq 'tbody') 
	{
		$self->{inside_tbody_STATE}++;
		# print "found table\n";		
	}

	if ($tagname eq 'a') 
	{
		if($self->{inside_tbody_STATE} and $self->{inside_tr_STATE}
		   and ($self->{td_number_in_tr_STATE} == 1))
		{
		
			my $onclick = ${$attr}{'onclick'};
			$onclick =~ /'event-name'\: '(\w+?)'/;
			my $bookMakerName = $1;
			$self->append_to_parsingResults("${bookMakerName} ");			
		}				
	}

	if ($tagname eq 'td') 
	{
		if($self->{inside_tr_STATE})
		{						
			$self->{td_number_in_tr_STATE}++;
		}

		if(isInside_tbody())
		{
			if($self->{td_number_in_tr_STATE} == 5)
			{				
				# print ${$attr}{'data-odd'};
				my $price_1 = ${$attr}{'data-odd'};
				$self->append_to_parsingResults("${price_1} ")				
			}
			if($self->{td_number_in_tr_STATE} == 6)
			{
				my $price_X = ${$attr}{'data-odd'};
				$self->append_to_parsingResults("${price_X} ")				
			}		
			
			if($self->{td_number_in_tr_STATE} == 7)
			{
				my $price_2 = ${$attr}{'data-odd'};
				$self->append_to_parsingResults("${price_2}\n")				
			}
		}			
		

	}

	if ($tagname eq 'tr') 
	{		
		# print "\n";
		$self->{inside_tr_STATE} = 1;		
	}
}

sub end
{
	my ($tagname, $attr, $attrseq, $origtext) = @_;

	if ($tagname eq 'tr')
	{
		$self->{inside_tr_STATE} = 0;
		$self->{td_number_in_tr_STATE} = 0;
	}
	
	if ($tagname eq 'tbody')
	{
		$self->{inside_tbody_STATE} = $self->{inside_tbody_STATE} - 1;  
	}
}
# package main;

my $html = <<EOHTML;
<tbody>
	<tr data-bid="417" data-originid="1" class=" odd">
		<td class="h-text-left over-s-only">
			<a href="/bookmaker/1039/http://refparrknf.top/L?tag=s_144205m_355c_&amp;site=144205&amp;ad=355" onclick="dataLayer.push({'event-name': '1xBet', 'event': 'bookmaker-click', 'event-sport': 'soccer'}); return true;" target="_blank" class="in-bookmaker-logo-link in-bookmaker-logo-link--primary l417" data-bid="1039">1xBet</a></td>
		<td class="h-text-left under-s-only">
			<a href="/bookmaker/1039/http://refparrknf.top/L?tag=s_144205m_355c_&amp;site=144205&amp;ad=355" onclick="dataLayer.push({'event-name': '1xBet', 'event': 'bookmaker-click', 'event-sport': 'soccer'}); return true;" target="_blank" data-bid="1039"><span class="in-bookmaker-logo l417" title="1xBet"></span></a></td>
		<td class="h-text-left tablet-desktop-only"></td>
		<td class="h-text-right">&nbsp;</td>
		<td class="table-main__detail-odds table-main__detail-odds--first colored" data-odd="1.67" data-created="02,11,2019,23,29"><span><span><span><i class="icon icon__increasing table-main__icon"></i> <span class="table-main__detail-odds--hasarchive" title="Click to see odds movements" onclick="load_odds_archive(this, '3lhd1xv464x0x9h2rr', 417);">1.67</span></span></span></span></td>
		<td class="table-main__detail-odds" data-odd="3.38" data-created="02,11,2019,23,29"><i class="icon icon__decreasing table-main__icon"></i> <span class="table-main__detail-odds--hasarchive" title="Click to see odds movements" onclick="load_odds_archive(this, '3lhd1xv498x0x0', 417);">3.38</span></td>
		<td class="table-main__detail-odds" data-odd="5.15" data-created="02,11,2019,23,29"><i class="icon icon__decreasing table-main__icon"></i> <span class="table-main__detail-odds--hasarchive" title="Click to see odds movements" onclick="load_odds_archive(this, '3lhd1xv464x0x9h2rq', 417);">5.15</span></td>
	</tr>
	<tr data-bid="16" data-originid="1" class=" even">
		<td class="h-text-left over-s-only">
			<a href="/bookmaker/11/http://www.bet365.com/olp/open-account?affiliate=365_021894" onclick="dataLayer.push({'event-name': 'bet365', 'event': 'bookmaker-click', 'event-sport': 'soccer'}); return true;" target="_blank" class="in-bookmaker-logo-link in-bookmaker-logo-link--primary l16" data-bid="11">bet365</a></td>
		<td class="h-text-left under-s-only">
			<a href="/bookmaker/11/http://www.bet365.com/olp/open-account?affiliate=365_021894" onclick="dataLayer.push({'event-name': 'bet365', 'event': 'bookmaker-click', 'event-sport': 'soccer'}); return true;" target="_blank" data-bid="11"><span class="in-bookmaker-logo l16" title="bet365"></span></a></td>
		<td class="h-text-left tablet-desktop-only"></td>
		<td class="h-text-right">&nbsp;</td>
		<td class="table-main__detail-odds table-main__detail-odds--first" data-odd="1.50" data-created="02,11,2019,20,19"><i class="icon icon__decreasing table-main__icon"></i> <span class="table-main__detail-odds--hasarchive" title="Click to see odds movements" onclick="load_odds_archive(this, '3lhd1xv464x0x9h2rr', 16);">1.50</span></td>
		<td class="table-main__detail-odds" data-odd="3.50" data-created="02,11,2019,20,19"><i class="icon icon__increasing table-main__icon"></i> <span class="table-main__detail-odds--hasarchive" title="Click to see odds movements" onclick="load_odds_archive(this, '3lhd1xv498x0x0', 16);">3.50</span></td>
		<td class="table-main__detail-odds" data-odd="6.00" data-created="02,11,2019,20,19"><i class="icon icon__increasing table-main__icon"></i> <span class="table-main__detail-odds--hasarchive" title="Click to see odds movements" onclick="load_odds_archive(this, '3lhd1xv464x0x9h2rq', 16);">6.00</span></td>
	</tr>
</tbody>
<tr>
	<td>Average odds</td>
	<td>Average odds</td>
	<td>1.60</td>
	<td>3</td>
	<td class="table-main__detail-odds" data-odd="5.45">5.44</td>
</tr>
EOHTML


sub parse($)
{
	my ($self, $htmlEvent) = @_;
	
	# $parser->parse_file( $path_htmlEventFile );
	# $parser->parse( $htmlEvent );
	# $self->SUPER::parse($html);
	$self->{htmlParser}->parse($html);
	# $self->SUPER::parse_file('exampleOfOut.html');	
	return 	$self->get_parsingResults()
}


1;
