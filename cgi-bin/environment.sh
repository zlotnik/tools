#!/bin/sh

export GIT_ROOT_DIRECTORY=`git rev-parse --show-toplevel`
export BACKEND_ROOT_DIRECTORY=$GIT_ROOT_DIRECTORY/cgi-bin
export PROFITABILITY_MODULE_DIRECTORY=$BACKEND_ROOT_DIRECTORY/ProfitabilityCalculator
export BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY=$BACKEND_ROOT_DIRECTORY/BookmakerOfferDownloader
export JOBS_DIRECTORY=$BACKEND_ROOT_DIRECTORY/jobs
export MOCKED_WWW=$BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY/input/mockedWWW

#Setting PERL5LIB
export PERL5LIB=$PERL5LIB:$PROFITABILITY_MODULE_DIRECTORY
export PERL5LIB=$PERL5LIB:$BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY
export PERL5LIB=$PERL5LIB:$BACKEND_ROOT_DIRECTORY/modules/perl5
export PERL5LIB=$PERL5LIB:$BACKEND_ROOT_DIRECTORY/modules/lib/perl5
export PERL5LIB=$PERL5LIB:$BOOKMAKER_OFFER_DOWNLOADER_MODULE_DIRECTORY/tests/unit_tests/BetexplorerParser

export PS1='[\u@\h \W]\e[0;32;1m\$\e[m'
