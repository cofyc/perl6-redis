use v6;

BEGIN { @*INC.push('t/') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new();
$r.connect;

is $r.ping, True;
is $r.set("key", "value"), True;
is $r.get("key"), "value";
is $r.quit, True;
