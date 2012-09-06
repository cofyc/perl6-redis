use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;

plan 1;

{
    my $r = Redis.new('127.0.0.1:0');
    dies_ok { $r.connect }
}

# vim: ft=perl6
