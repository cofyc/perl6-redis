use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new(decode_response => True);
$r.connect;
$r.flushall;

plan 5;

$r.set("key", 1);
is_deeply $r.eval("return redis.call('get', 'key')", 0), "1";

is_deeply $r.script_flush(), True;

dies_ok { $r.script_kill() };

my $sha = $r.script_load("return redis.call('get', 'key')");
is_deeply $r.script_exists($sha, "unknown"), [1, 0];

is_deeply $r.evalsha($sha, 0), "1";
