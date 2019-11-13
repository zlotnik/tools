package HTML_1X2_Events_Parser;

use HTML::Parser;
our @ISA = qw(HTML::Parser);

sub new();

sub append_to_parsingResults($);
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
			
			if($self->{td_number_in_tr_STATE} == 6)
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

sub parse($)
{
	my ($self, $htmlEvent) = @_;
	
	$self->{htmlParser}->parse($htmlEvent);	
	return 	$self->get_parsingResults()
}


1;
