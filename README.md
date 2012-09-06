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

Build & Test & Install
======================
    
First, please get 'ufo' from <http://github.com/masak/ufo> , then run:

    $ ufo
    $ make
    $ make test     # need Redis server installed
    $ make install

Install with Panda
==================

    $ panda install Redis
    or if you don't have Redis server installed
    $ panda install --notests Redis 

Unit Tests
==========

    Tested agaist Redis version 2.4.16 and 2.5.12.
    
References
==========

1. http://redis.io/topics/protocol
2. http://search.cpan.org/~melo/Redis-1.951/
