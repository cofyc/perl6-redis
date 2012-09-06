use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new("127.0.0.1:63790");
$r.connect;
$r.flushall;

plan 2;

# arbitary binary string 
my Buf $binary = Buf.new(1,2,3,129);
is_deeply $r.set("key", $binary), True;
is_deeply $r.get("key"), $binary;
