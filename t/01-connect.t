use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;
use Test::SpawnRedisServer;

plan 2;

{
    my $r = Redis.new('127.0.0.1:0');
    dies_ok { $r.connect }
}

{
    my $r = Redis.new();
    ok $r.connect;
}

# vim: ft=perl6
