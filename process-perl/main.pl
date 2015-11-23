#!/usr/bin/env perl -w
use strict;
use warnings;
use utf8;

use Process;

if (@ARGV != 2) {
    print "Args are: <field name> <folder>\n";
    exit;
}
Process::process($ARGV[0], $ARGV[1]);

# # Benchmark
# for (my $i = 0; $i <= 100; $i++) {
#     Process::process("Name", "../test_data/");
# }
