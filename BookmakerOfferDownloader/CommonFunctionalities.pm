package CommonFunctionalities;

use base 'Exporter';
use WojtekToolbox;

our @EXPORT = qw( obtain_phantomJsBinaryName );



sub obtain_phantomJsBinaryName();


sub obtain_phantomJsBinaryName()
{

	if(is_it_Linux())
	{	
		return 'phantomjs.elf'
	}
	if(is_it_Windows())
	{
		return 'phantomjs.exe'	
	}

	die "unsupported operation system $OSTYPE";

};
1;
