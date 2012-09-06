use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new("127.0.0.1:63790", decode_response => True);
$r.connect;
$r.flushall;

plan 1;

# TODO 
is_deeply $r.publish("queue", "data"), 0;
