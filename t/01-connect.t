use v6;

BEGIN { @*INC.push('t/') };
use Redis;
use Test;
use Test::SpawnRedisServer;

plan 2;

{
    my $r = Redis.new('192.168.0.1');
    dies_ok { $r.connect }
}

{
    my $r = Redis.new();
    ok $r.connect;
}

# vim: ft=perl6
