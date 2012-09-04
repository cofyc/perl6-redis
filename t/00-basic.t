use v6;

use Redis;
use Test;

my @new_tasks =
    \() => {
        'host' => '127.0.0.1',
        'port' => 6379,
        'debug' => False,
    }
    , \('192.168.0.1') => {
        'host' => '192.168.0.1',
        'port' => 6379,
    }
    , \('192.168.0.1:6379', debug => True) => {
        'host' => '192.168.0.1',
        'port' => 6379,
        'debug' => True,
    }
    , \('/path/to/redis.sock', debug => True) => {
        'sock' => '/path/to/redis.sock',
        'debug' => True,
    }
    ;
        
plan [+] @new_tasks.map({ $_.value.elems });

for @new_tasks -> $p {
    my $r = Redis.new(|$p.key);
    $p.value.map({
        is_deeply $r."{.key}"(), .value;
    });
}

# vim: ft=perl6
