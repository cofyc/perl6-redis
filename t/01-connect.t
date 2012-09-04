use v6;

BEGIN { @*INC.push('t/') };
use Redis;
use Test;
use Test::SpawnRedisServer;

plan 1;

{
    my $r = Redis.new('192.168.0.1');
    my $failed = 0;
    try {
        $r.connect;
        CATCH {
            default { $failed = 1 }
        }
    }
    ok $failed, 'trying to connect wrong server throws exception';
}

{
    my $r = Redis.new();
    $r.connect;
}

# vim: ft=perl6
