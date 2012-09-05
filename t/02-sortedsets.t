use v6;

BEGIN { @*INC.push('t/') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new();
$r.connect;
$r.flushall;

#plan 1;
