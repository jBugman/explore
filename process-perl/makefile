# sudo cpan App::cpanminus
deps:
	cpanm --local-lib=lib JSON::Parse
	cpanm --local-lib=lib Text::CSV_XS

run:
	PERL5LIB=lib/lib/perl5 perl -CS main.pl Name ../test_data/

test:
	PERL5LIB=lib/lib/perl5 perl test.t
