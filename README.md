# Redis - Perl6 binding for Redis

Port of Redis from Perl 5.

Synopsis
========

    # create a Redis object
    my $redis = Redis.new("192.168.1.12:6379");
    # connect to server
    $redis.connect();
    # execute commands...
    $redis.set("key", "value");
    say $redis.get("key");

References
==========

1. http://redis.io/topics/protocol
2. http://search.cpan.org/~melo/Redis-1.951/
