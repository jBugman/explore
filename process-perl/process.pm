package Process;

use strict;
use warnings;
use utf8;

use File::Spec::Functions 'catfile';
use JSON::Parse 'json_file_to_perl';
use Scalar::Util 'looks_like_number';
use Text::CSV_XS;

sub process {
    my %frequencies;
    my ($field, $folder) = @_;
    while (my $file = glob catfile ($folder, "*.json")) {
        my $data = json_file_to_perl($file);
        if (not exists $$data{$field}) {
            print STDERR "Field is missing\n";
            return 1;
        }
        my $value = $$data{$field};
        if (ref $value or looks_like_number($value)) {
            print STDERR "Field is (probably) not a string\n";
            return 1;
        }
        if (not $value eq "") {
            $frequencies{$value}++;
        }
    }
    my $csv = Text::CSV_XS->new ({ binary => 1, eol => $/ });
    open my $fh, ">:utf8", "output.csv" or die "Can not open output file: $!";
    foreach my $k (reverse sort { $frequencies{$a} <=> $frequencies{$b} } keys %frequencies) {
        $csv->print ($fh, [$k, $frequencies{$k}]) or $csv->error_diag;
    }
    close $fh or die "output.csv: $!";
    return 0;
}

1;
