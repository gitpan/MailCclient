use Mail::Cclient qw(set_callback);

set_callback
	log => sub {
	    my ($str, $type) = @_;
	    print "$type: $str\n";
	},
	dlog => sub { print "debug: $_[0]\n" },
	list => sub {
	    shift;
	    print "list: @_\n";
	};

if (@ARGV != 1) {
    print STDERR "Usage: list.t mailstream\n";
    exit 2;
}
$c = Mail::Cclient->new($ARGV[0]) or die "Mail::Cclient->new failed\n";
$c->list("", "%");
