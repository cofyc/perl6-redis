use v6;

# =begin Pod
# =head1 Redis
# Perl6 binding for Redis.
#
# =end Pod

class Redis;

has Str $.host = '127.0.0.1';
has Int $.port = 6379;
has Str $.sock; # if sock is defined, use sock
has Bool $.debug = False;
has Real $.timeout = 0.0; # 0 means unlimited
has IO::Socket $.conn;

method new(Str $server?, Bool :$debug?, Real :$timeout?) {
    my %config = {}
    if $server.defined {
        if $server ~~ m/^([\d+]+ %\.) ':' (\d+)$/ {
            %config<host> = $0.Str;
            %config<port> = $1.Int;
        } else {
            %config<sock> = $server;
        }
    }
    if $debug.defined {
        %config<debug> = $debug;
    }
    if $timeout.defined {
        %config<timeout> = $timeout;
    }
    return self.bless(*, |%config);
}

method connect {
    my $conn;
    if $.sock.defined {
        say "unsupported";
    } else {
        $conn = IO::Socket::INET.new(host => $.host, port => $.port);
    }
    $.conn = $conn;
}

#method ping {
    #$.conn.send("PING\r\n");
    #print($.conn.get);
#}

# vim: ft=perl6
