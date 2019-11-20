#!/bin/sh

export GIT_ROOT_DIRECTORY=`git rev-parse --show-toplevel`
export PERL5LIB=$GIT_ROOT_DIRECTORY/cgi-bin/BookmakerOfferDownloader
export PERL5LIB=$PERL5LIB:$GIT_ROOT_DIRECTORY/cgi-bin/modules/perl5

perl $1 runLegacyTests.pl

