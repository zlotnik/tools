#!/usr/bin/perl

use strict;
use warnings;

#cat /var/log/httpd/access_log |grep -v 'Chrome/88.0.4324.93' |grep surebethar |grep -v 213.76.45.110|grep -v Google |grep -v 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0| grep -v 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'
#fix it
#
#



showTraffic();

sub showTraffic()
{

        open (my $fh, '<', '/var/log/httpd/access_log' ) or die $!;


        while( <$fh> )
        {
                if ( should_I_show_this_line($_) )
                {  
                        print $_;
                }
                
        }

}


sub should_I_show_this_line()
{
        my $tuf_chrome = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36';
        my $tuf_edge =  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36 Edg/93.0.961.38";
        my $m31 = '';   

        if( $_ =~ /surebetharvester/ )
        {
                return 1;
        }
        

}




