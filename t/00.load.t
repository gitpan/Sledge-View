use strict;
use warnings;
use Test::More tests => 4;
use Class::Trigger qw/AFTER_INIT/;

sub mk_accessors { 'dummy for testing' }

BEGIN {
    use_ok( 'Sledge::View' );
    use_ok( 'Sledge::Plugin::View' );
    use_ok( 'Sledge::View::Template' );
    use_ok( 'Sledge::Response' );
}

diag( "Testing Sledge::View $Sledge::View::VERSION" );
