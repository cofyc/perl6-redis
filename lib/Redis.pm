use v6;

# =begin Pod
# =head1 Redis
# Perl6 binding for Redis.
#
# =end Pod

# Initiate callbacks
my %command_callbacks = ();
%command_callbacks{"PING"} = { $_ eq "PONG" };
for "QUIT SET".split(" ") -> $c {
    %command_callbacks{$c} = { $_ eq "OK" }
}

class Redis;

has Str $.host = '127.0.0.1';
has Int $.port = 6379;
has Str $.sock; # if sock is defined, use sock
has Bool $.debug = False;
has Real $.timeout = 0.0; # 0 means unlimited
has $.conn is rw;
has %!command_callbacks = %command_callbacks;

method new(Str $server?, Bool :$debug?, Real :$timeout?) {
    my %config = {}
    if $server.defined {
        if $server ~~ m/^([\d+]+ %\.) [':' (\d+)]?$/ {
            %config<host> = $0.Str;
            if $1 {
                %config<port> = $1.Str.Int;
            }
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
    if $.sock.defined {
        die "Sorry, connecting via unix sock is currently unsupported!";
    } else {
        $.conn = IO::Socket::INET.new(host => $.host, port => $.port, input-line-separator => "\r\n");
    }
}

method !pack_command(*@args) {
    my $cmd = '*' ~ @args.elems ~ "\r\n";
    for @args -> $arg {
        $cmd ~= '$';
        $cmd ~= $arg.chars;
        $cmd ~= "\r\n";
        $cmd ~= $arg;
        $cmd ~= "\r\n";
    }
    return $cmd;
}


method !send_command(*@args) {
    $.conn.send(self!pack_command(|@args));
}

method !read_response {
    my $first-line = $.conn.get();
    my ($flag, $response) = $first-line.substr(0, 1), $first-line.substr(1);
    if $flag !eq any('+', '-', ':', '$', '*') {
        die "Unknown nresponse from redis!\n";
    }
    if $flag eq '+' {
        # single line reply
    } elsif $flag eq '-' {
        # on error
        die $response;
    } elsif $flag eq ':' {
        # int value
        $response = $response.Int;
    } elsif $flag eq '$' {
        # bulk response
        my $length = $response.Int;
        if $length eq -1 {
            return False;
        }
        $response = $.conn.recv($length);
    } elsif $flag eq '*' {
        # multi-bulk response
        die "unsupported";
    }
    return $response;
}

method !parse_response($response, $command) {
    if %!command_callbacks.exists($command) {
        return %!command_callbacks{$command}($response);
    }
    return $response;
}

# Ping the server.
method ping {
    self!send_command("PING");
    return self!parse_response(self!read_response(), "PING");
}

# Ask the server to close the connection. The connection is closed as soon as all pending replies have been written to the client.
method quit {
    self!send_command("QUIT");
    return self!parse_response(self!read_response(), "QUIT");
}

method set(Str $name, $value) {
    self!send_command("SET", $name, $value);
    return self!parse_response(self!read_response(), "SET");
}

method get(Str $name) {
    self!send_command("GET", $name);
    return self!parse_response(self!read_response(), "GET");
}

method mget {
}

method incr {
}

method decr {
}

method exists {
}

method del {
}

method type {
}
# vim: ft=perl6
