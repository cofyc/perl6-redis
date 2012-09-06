use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new("127.0.0.1:63790", decode_response => True);
$r.connect;
$r.flushall;

plan 1;

# bug: multi-bytes chars and \r\n in data
my $str = "中文 string contains newlines\r\n";
$r.set("key", $str);
is_deeply $r.get("key"), $str;
