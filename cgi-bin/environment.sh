#!/bin/sh

export GIT_ROOT_DIRECTORY=`git rev-parse --show-toplevel`
export BACKEND_ROOT_DIRECTORY=$GIT_ROOT_DIRECTORY/cgi-bin
export PERL5LIB=$PERL5LIB:$BACKEND_ROOT_DIRECTORY/BookmakerOfferDownloader
export PERL5LIB=$PERL5LIB:$BACKEND_ROOT_DIRECTORY/modules/perl5
export PERL5LIB=$PERL5LIB:$BACKEND_ROOT_DIRECTORY/modules/lib/perl5

