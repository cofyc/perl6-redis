use v6;

BEGIN { @*INC.push('t/') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new(decode_response => True);
$r.connect;
$r.flushall;

plan 1;

# TODO 
is_deeply $r.publish("queue", "data"), 0;
