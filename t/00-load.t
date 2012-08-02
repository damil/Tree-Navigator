#!perl -T

use Test::More tests => 4;

BEGIN {
    use_ok( 'Tree::Navigator' ) || print "Bail out!\n";
    use_ok( 'Tree::Navigator::Server' ) || print "Bail out!\n";
    use_ok( 'Tree::Navigator::Node' ) || print "Bail out!\n";
    use_ok( 'Tree::Navigator::Node::Filesys' ) || print "Bail out!\n";
}

diag( "Testing Tree::Navigator $Tree::Navigator::VERSION, Perl $], $^X" );
