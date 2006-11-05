use strict;
use warnings;
use Test::More;
use Class::Trigger qw/AFTER_INIT/;

BEGIN {
    eval q[use Sledge::Exceptions];
    plan skip_all => "Sledge::Exceptions required for testing base: $@" if $@;
};

sub mk_accessors { 'dummy for testing' }

BEGIN {
    plan tests => 4;
    use_ok( 'Sledge::View' );
    use_ok( 'Sledge::Plugin::View' );
    use_ok( 'Sledge::View::Template' );
    use_ok( 'Sledge::Response' );
}

diag( "Testing Sledge::View $Sledge::View::VERSION" );
