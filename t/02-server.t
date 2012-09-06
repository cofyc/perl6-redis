use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new();
$r.connect;

plan 3;

is_deeply $r.flushall(), True;

is_deeply $r.flushdb(), True;

ok $r.info.WHAT === Hash;
