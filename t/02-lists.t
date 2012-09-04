use v6;

BEGIN { @*INC.push('t/') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new();
$r.connect;

plan 16;

# TODO blpop & brpop & brpoplpush

# lindex & lpush & llen & linsert & lrange & lpushx
$r.del("mylist");
is_deeply $r.lpush("mylist", "World", "Hello"), 2;
is_deeply $r.lindex("mylist", 1), "World";
is_deeply $r.lindex("mylist", 2), Nil;
is_deeply $r.llen("mylist"), 2;
dies_ok { $r.linsert("mylist", "OK", "World", ", "); }
is_deeply $r.linsert("mylist", "BEFORE", "World", ", "), 3;
is_deeply $r.lrange("mylist", 0, 2), ["Hello", ", ", "World"];

# lpushx & lpop & rpop
is_deeply $r.lpushx("mylist", 1), 4;
is_deeply $r.lpop("mylist"), "1";
is_deeply $r.rpop("mylist"), "World";

# lrem & lset & ltrim
$r.del("mylist");
$r.lpush("mylist", 1, 2, 3, 4);
is_deeply $r.lset("mylist", 0, 1), True;
is_deeply $r.lrem("mylist", 0, 1), 2;
is_deeply $r.ltrim("mylist", 0, 1), True;

# rpoplpush & rpush & rpushx
is_deeply $r.rpoplpush("mylist", "newlist"), "2";
is_deeply $r.rpush("mylist", 2), 2;
is_deeply $r.rpushx("mylist", 2), 3;

# vim: ft=perl6
