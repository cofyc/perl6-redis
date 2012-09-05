use v6;

BEGIN { @*INC.push('t/') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new();
$r.connect;
$r.flushall;

plan 2;

# arbitary binary string 
my Buf $binary = Buf.new(1,2,3,129);
is_deeply $r.set("key", $binary), True;
is_deeply $r.get("key"), $binary;
