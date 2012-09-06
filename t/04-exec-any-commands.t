use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new(decode_response => True);
$r.connect;

plan 1;

is_deeply $r.exec_command("CONFIG GET", "timeout"), ["timeout", "1"];
