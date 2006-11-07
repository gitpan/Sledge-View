use strict;
use warnings;
use Test::Base;

BEGIN {
    eval q[use t::TestPages];
    plan skip_all => "t::TestPages required for testing base: $@" if $@;
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
$self->stash->{template} = \( "yes yes" );
$self->view('TT')->process;
--- expected chomp
Content-Length: 7
Content-Type: text/html; charset=utf-8

yes yes

=== get the value from Sledge
--- input
$self->stash->{foo} = 'bar> baz';
$self->stash->{template} = \( "foo: [% foo %]" );
$self->view('TT')->process;
--- expected chomp
Content-Length: 16
Content-Type: text/html; charset=utf-8

foo: bar&gt; baz

