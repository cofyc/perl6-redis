use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;

my @new_tasks =
    \() => {
        'host' => '127.0.0.1',
        'port' => 6379,
    }
    , \('192.168.0.1') => {
        'host' => '192.168.0.1',
        'port' => 6379,
    }
    , \('192.168.0.1:6379') => {
        'host' => '192.168.0.1',
        'port' => 6379,
    }
    , \('/path/to/redis.sock') => {
        'sock' => '/path/to/redis.sock',
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
