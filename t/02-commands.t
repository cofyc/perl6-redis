use v6;

BEGIN { @*INC.push('t/') };
use Redis;
use Test;
use Test::SpawnRedisServer;

my $r = Redis.new();
$r.connect;

###### Commands/Strings #######

# append
$r.del("key");
is_deeply $r.append("key", "Hello"), 5;
is_deeply $r.append("key", " World"), 11;

# bitcount
$r.set("key", "foobar");
is_deeply $r.bitcount("key"), 26;
is_deeply $r.bitcount("key", 0, 0), 4;
is_deeply $r.bitcount("key", 1, 1), 6;

# bitop
$r.set("key1", "foobar");
$r.set("key2", "abcdefg");
is_deeply $r.bitop("AND", "dest", "key1", "key2"), 7;

# incr & decr & decrby & incrby
$r.set("key2", 100);
is_deeply $r.incr("key2"), 101;
is_deeply $r.decr("key2"), 100;
is_deeply $r.decrby("key2", 2), 98;
is_deeply $r.incrby("key2", 3), 101;

# getbit
is_deeply $r.getbit("key2", 2), 1;

# getrange
$r.set("mykey", "This is a string");
is_deeply $r.getrange("mykey", 0, 3), "This";

# getset
$r.del("mycounter");
is_deeply $r.incr("mycounter"), 1;
is_deeply $r.getset("mycounter", 0), "1";
is_deeply $r.get("mycounter"), "0";

# incrbyfloat
$r.set("mykey", 10.50);
is_deeply $r.incrbyfloat("mykey", 0.1), 10.6;
$r.set("mykey", 5.0e3);
is_deeply $r.incrbyfloat("mykey", 2.0e2), 5200;

# set & get
is_deeply $r.set("key", "value"), True;
is_deeply $r.get("key"), "value";
is_deeply $r.get("does_not_exists"), Nil;
is_deeply $r.set("key2", 100), True;
is_deeply $r.get("key2"), "100";

# mget
$r.del("key", "key2");
is_deeply $r.mset("key", "value", key2 => "value2"), True;
is_deeply $r.mget("key", "key2"), ["value", "value2"];
is_deeply $r.msetnx("key", "value", key2 => "value2"), 0;

# psetex
is_deeply $r.psetex("key", 100, "value"), True;
is_deeply $r.get("key"), "value";
sleep(0.1);
is_deeply $r.get("key"), Nil;

# setbit
$r.del("mykey");
is_deeply $r.setbit("mykey", 7, 1), 0;
is_deeply $r.setbit("mykey", 7, 0), 1;

# setex
is_deeply $r.setex("key", 1, "value"), True;

# setnx
is_deeply $r.setnx("key", "value"), False;

# setrange
is_deeply $r.setrange("key", 2, "123"), 5;
is_deeply $r.get("key"), "va123";

# strlen
is_deeply $r.strlen("key"), 5;

###### ! Commands/Strings #######

###### Commands/Keys ######

# del
is_deeply $r.del("key", "key2", "does_not_exists"), 2;

# dump & restore
$r.set("key", "value");
my $serialized = $r.dump("key");
$r.del("newkey");
is_deeply $r.restore("newkey", 100, $serialized), True;
is_deeply $r.get("newkey"), "value";

# exists
$r.set("key", "value");
is_deeply $r.exists("key"), True;
is_deeply $r.exists("does_not_exists"), False;

# expire & persist & pexpire & expireat & pexpireat & pttl & ttl
is_deeply $r.expire("key", 100), True;
ok $r.ttl("key") <= 100;
ok $r.persist("key");
is_deeply $r.ttl("key"), -1;
is_deeply $r.pexpire("key", 100000), True;
is_deeply $r.expireat("key", 100), True;
is_deeply $r.ttl("key"), -1;
is_deeply $r.pexpireat("key", 1), False;
is_deeply $r.pttl("key"), -1;

# keys
$r.set("pattern1", 1);
$r.set("pattern2", 2);
is_deeply $r.keys("pattern*"), ["pattern1", "pattern2"];

# migrate TODO

# move TODO

# object
$r.set("key", "value");
is_deeply $r.object("refcount", "key"), 1;

# randomkey
is_deeply $r.randomkey().WHAT.gist, "Str()";

# rename
is_deeply $r.rename("key", "newkey"), True;

# renamenx
{
    my $failed = 1;
    try {
        $r.renamenx("does_not_exists", "newkey");
        CATCH {
            default { $failed = 1 }
        }
    }
    ok $failed;
}

# sort TODO
#say $r.sort("key", :desc);


# type
$r.set("key", "value");
is_deeply $r.type("key"), "string";
is_deeply $r.type("does_not_exists"), "none";

###### ! Commands/Keys ######

###### Commands/Hashes ######

# hset & hget & hmset & hmget & hsetnx
$r.hdel("hash", "field1");
is_deeply $r.hset("hash", "field1", 1), True;
is_deeply $r.hsetnx("hash", "field1", 1), False;
is_deeply $r.hget("hash", "field1"), "1";
is_deeply $r.hmset("hash", "key", "value", key2 => "value2"), True;
is_deeply $r.hmget("hash", "key", "key2"), ["value", "value2"];

# hdel & hexists
is_deeply $r.hdel("hash", "field1", "key"), 2;
is_deeply $r.hexists("hash", "field1"), False;

# hgetall
$r.hset("hash", "count", 1);
is_deeply $r.hgetall("hash"), {key2 => "value2", count => "1"};

# hincrby & hincrbyfloat
is_deeply $r.hincrby("hash", "count", 10), 11;
is_deeply $r.hincrbyfloat("hash", "count", 10.1), 21.1;

# hkeys & hlen & hvals
is_deeply $r.hkeys("hash"), ["key2", "count"];
is_deeply $r.hlen("hash"), 2;
is_deeply $r.hvals("hash"), ["value2", "21.1"];

###### ! Commands/Hashes ######


###### Commands/Connection #######

is_deeply $r.ping, True;
is_deeply $r.quit, True;

###### ! Commands/Connection #######
