use v6;

BEGIN { @*INC.push('t', 'lib') };
use Redis;
use Test;

my $r = Redis.new("127.0.0.1:63790", decode_response => True);
$r.connect;

plan 5;

dies_ok { $r.auth("WRONG PASSWORD"); }
is_deeply $r.echo("Hello World!"), "Hello World!";
is_deeply $r.ping, True;
is_deeply $r.select(2), True;
is_deeply $r.quit, True;

# vim: ft=perl6
