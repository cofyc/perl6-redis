use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new("127.0.0.1:63790", decode_response => True);
$r.connect;
$r.flushall;

plan 5;

# multi->...->exec
is_deeply $r.multi(), True;
$r.set("key", "value");
$r.set("key2", "value2");
is_deeply $r.exec(), ["OK", "OK"];

# multi->...->discard
is_deeply $r.multi(), True;
$r.set("key2", "value3");
is_deeply $r.discard(), True;
is_deeply $r.get("key2"), "value2";
