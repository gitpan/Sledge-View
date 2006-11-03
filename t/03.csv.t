use strict;
use warnings;
use Test::Base;

BEGIN {
    eval q[use t::TestPages];
    plan skip_all => "Test::Base, t::TestPages required for testing base: $@" if $@;
};
plan tests => 1*blocks;

run {
    my $block = shift;

    no warnings 'once';
    local *t::TestPages::dispatch_foo = sub {
        my $self = shift;
        eval $block->input;
        die $@ if $@;
    };
    eval q{package t::TestPages; use Sledge::Plugin::Stash};
    die $@ if $@;

    my $page = t::TestPages->new;
    $page->dispatch('foo');
    is($page->output, $block->expected, $block->name);
};

__END__

=== simple
--- input
$self->stash->{rows} = [[qw/a b/], [qw/c d/]];
$self->view('CSV')->process;
--- expected
Content-Length: 8
Content-Type: text/comma-separated-values
Content-Disposition: attachment; filename="output.csv"

a,b
c,d

=== with header footer
--- input
$self->stash->{header} = [qw/title name/];
$self->stash->{rows} = [[qw/a b/], [qw/c d/]];
$self->stash->{footer} = [qw/END END/];
$self->view('CSV')->process;
--- expected
Content-Length: 27
Content-Type: text/comma-separated-values
Content-Disposition: attachment; filename="output.csv"

title,name
a,b
c,d
END,END

=== hash and key
--- input
$self->stash->{keys} = [qw/author waf/];
$self->stash->{rows} = [
    { waf => 'Sledge', author => 'miyagawa' },
    { waf => 'boofy', author => 'bk' },
];
$self->view('CSV')->process;
--- expected
Content-Length: 25
Content-Type: text/comma-separated-values
Content-Disposition: attachment; filename="output.csv"

miyagawa,Sledge
bk,boofy

=== object and key
--- input
{
    package t::Mock;
    sub new {my $proto = shift; bless {@_}, $proto }
    sub meth { shift->{foo} }
    sub osu  { shift->{bar} }
}
$self->stash->{keys} = [qw/meth osu/];
$self->stash->{rows} = [
    t::Mock->new(foo => 'bar', 'bar' => 'baz'),
    t::Mock->new(foo => 'gee', 'bar' => 'gaa')
];
$self->view('CSV')->process;
--- expected
Content-Length: 16
Content-Type: text/comma-separated-values
Content-Disposition: attachment; filename="output.csv"

bar,baz
gee,gaa
