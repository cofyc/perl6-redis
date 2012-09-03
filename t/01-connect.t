use v6;

use Redis;
use Test;

plan 1;

{
    my $r = Redis.new;
    my $failed = 0;
    try {
        $r.connect;
        CATCH {
            default { $failed = 1 }
        }
    }
    ok $failed, 'trying to connect wrong server throws exception';
}

# vim: ft=perl6
