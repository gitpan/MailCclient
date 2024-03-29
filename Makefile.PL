use ExtUtils::MakeMaker;

$CCLIENT_DIR = "/usr/src/redhat/BUILD/imap-4.1.BETA/c-client";
#
# We want to turn Cclient.o (ours) plus the object files in the
# $CCLIENT_DIR/c-client.a archive into a shared object. Simply
# including both in the MakeMaker OBJECT list works fine for Linux
# but under Digital UNIX, the combination of its ar and "ld -shared"
# can't cope with simply "ar cr tmp.a Cclient.o .../c-client.a".
# To get around that look at the contents of the c-client.a archive
# and extract all .o files from it into the current directory. Then
# we set OBJECT to be our Cclient.o plus all of those. Blech.
#

print "Examining archive file $CCLIENT_DIR/c-client.a...\n";
chomp(@contents = `ar t $CCLIENT_DIR/c-client.a`);
@objects = grep(/\.o$/, @contents);
print "Extracting object files from archive: ", join(", ", @objects), "\n";
system("ar", "x", "$CCLIENT_DIR/c-client.a", @objects);
my $err = $? >> 8;
if ($err) {
    print "Extraction failed: ar returned exit code $err\n",
	  "Please extract them manually into the current directory\n",
	  "edit Makefile.PL to remove this section of code and then rerun\n",
	  "    perl Makefile.PL\n";
    exit 1;
}
print "Extraction was apparently successful\n";

WriteMakefile(
    NAME		=> "Mail::Cclient",
    VERSION_FROM	=> "Cclient.pm",
    INC			=> "-I$CCLIENT_DIR",
    LIBS		=> ["-lpam"],
    OBJECT		=> "Cclient.o @objects"
);

