#!perl
use strict;
use warnings;

use lib "./lib";

use Tree::Navigator;

$DB::deep = 500;

my $tn = Tree::Navigator->new;

# use Win32::OLE;
# my $excel = Win32::OLE->new('Excel.Application') or die "oops\n";
# $tn->mount(msword => 'Perl::Ref' => {mount_point => {ref => $excel}});


$tn->mount(HKCU => 'Win32::Registry' => {mount_point => {key => 'HKCU'}});

use DBI;
my $dbfile = "D:/devarea/sqlite/jetons.sqlite";
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","");
$tn->mount(Jetons  => 'DBI' => {mount_point => {dbh => $dbh}});

$tn->mount(TN  => 'Perl::Ref' => {mount_point => {ref => $tn}});

$tn->mount(Foo  => 'Perl::Ref' => {mount_point => {ref => {
  foo => 123,
  bar => [123, 456, { x => 1, y => [345345, 3452543]}],
}}});

$tn->mount(Stack  => 'Perl::StackTrace' => {mount_point => {}});

# $tn->mount(temp  => '+Tree::Navigator::Node::Filesys'
#                  => {attributes => {
#                        label => 'Fichiers temporaires',
#                        title => 'Big mess of tmp files',
#                        },
#                      mount_point => {root => 'D:/Temp'},
#                     });
$tn->mount(dami => Filesys 
                => {attributes => {label => 'Privé'},
                    mount_point => {root  => 'D:/dami'}});

$tn->mount("main" => 'Perl::Symdump' => {});

my $app = $tn->to_app;


# use Plack::Middleware::Debug;
# $app = Plack::Middleware::Debug->wrap($app, panels => [qw/Environment Response Timer/]);

# use Plack::Middleware::InteractiveDebugger; 
# $app = Plack::Middleware::InteractiveDebugger->wrap($app);


# Allow this script to be run also directly (without 'plackup'), so that
# it can be launched from Emacs
unless (caller) {
  require Plack::Runner;
  my $runner = Plack::Runner->new;
  $runner->parse_options(@ARGV);
  return $runner->run($app);
}


return $app;




