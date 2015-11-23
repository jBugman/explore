use strict;
use warnings;

use Test::Simple tests => 1;

use Process;

ok( Process::process("Name", "../test_data/") == 0, "Works" );
