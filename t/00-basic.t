use v6;

use Redis;
use Test;

my @new_tasks = \() => {
        'host' => '127.0.0.1',
        'port' => 6379,
        'debug' => False,
        'timeout' => 0.0,
    },
    \('192.168.0.1:6379', debug => True, timeout => 3) => {
        'host' => '192.168.0.1',
        'port' => 6379,
        'debug' => True,
        'timeout' => 3,
    },
    \('/path/to/redis.sock', debug => True, timeout => 3) => {
        'sock' => '/path/to/redis.sock',
        'debug' => True,
        'timeout' => 3,
    };
        
plan [+] @new_tasks.map({ $_.value.elems });

for @new_tasks -> $p {
    my $r = Redis.new(|$p.key);
    $p.value.map({
        is_deeply $r."{.key}"(), .value;
    });
}

# vim: ft=perl6
