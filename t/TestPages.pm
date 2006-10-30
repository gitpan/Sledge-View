package t::TestPages;
use strict;
use warnings;
use Data::Dumper;

BEGIN {
    eval qq{
        use base qw(Sledge::TestPages);
        use YAML;
        use Sledge::View::Template;
        use Sledge::Plugin::View;
    };
    die $@ if $@;
}

sub create_view { Sledge::View::Template->new(shift) }

my $x;
$x = $t::TestPages::TMPL_PATH = 't/';
$x = $t::TestPages::COOKIE_NAME = 'sid';
$ENV{HTTP_COOKIE}    = "sid=SIDSIDSIDSID";
$ENV{REQUEST_METHOD} = 'GET';
$ENV{QUERY_STRING}   = 'foo=bar';

1;
