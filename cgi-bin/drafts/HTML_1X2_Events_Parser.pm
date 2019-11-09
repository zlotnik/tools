package HTML_1X2_Events_Parser;
use base qw(HTML::Parser);

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

sub set_1_price();

sub setState_inside_tbody()
{	
	
}

my $tr_counter_debug = 0; 

sub new()
{
	print "Functional module BookmakerOfferDownloader\n";
	my ($class) = @_;
	my $self;
		
	$self = bless {}, $class;

	#set default()
	$self->{inside_tbody_STATE} = 0;
	$self->{td_number_in_tr_STATE} = 0;
	$self->{inside_td_STATE} = 0;
	$self->{inside_tr_STATE} = 0;
	
	return $self;
}

sub start 
{ 
	if($tr_counter_debug == 2)
	{
		print '';
	}

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
			print $1." ";
		}				
	}

	if ($tagname eq 'td') 
	{
		if($self->{inside_tr_STATE})
		{						
			$self->{td_number_in_tr_STATE}++;
		}
				
		if($self->{td_number_in_tr_STATE} == 5)
		{
			print ${$attr}{'data-odd'}; 
		}
		if($self->{td_number_in_tr_STATE} == 6)
		{
			print ' '.${$attr}{'data-odd'};
		}		
		
		if($self->{td_number_in_tr_STATE} == 6)
		{
			print ' '.${$attr}{'data-odd'};
		}

		# print "found td\n";		
	}

	if ($tagname eq 'tr') 
	{
		$tr_counter_debug++;
		print "\n";
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
EOHTML


my $parser = HTML::Parser->new( api_version => 3,
                        start_h => [\&start, "tagname, attr"],
                        end_h   => [\&end,   "tagname"],
                        marked_sections => 1,
                      );
sub parse()
{
	$parser->parse( $html );
}


1;
