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

    my $page = t::TestPages->new;
    $page->dispatch('foo');
    is($page->output, $block->expected, $block->name);
};

__END__

=== simple
--- input
$self->tmpl->param(abc => 'foo');
--- expected
Content-Length: 10
Content-Type: text/html; charset=euc-jp

#abc: foo

=== another view
--- input
use t::View::Text;
$self->tmpl->param('text' => "boofy boofy\n");
t::View::Text->new($self)->process;
--- expected
Content-Length: 12
Content-Type: text/plain

boofy boofy

=== $self->view('t::View::Text')
--- input
$self->tmpl->param('text' => "boofy boofy\n");
$self->view('t::View::Text')->process;
--- expected
Content-Length: 12
Content-Type: text/plain

boofy boofy

=== $self->view('Template')
--- input
$self->tmpl->param(abc => "CGI->Vars");
$self->view('Template')->process;
--- expected
Content-Length: 16
Content-Type: text/html; charset=euc-jp

#abc: CGI->Vars

=== die if invalid view class
--- input
eval {
    $self->view('InvalidView')->process;
};
my $errmsg = $@;
$errmsg =~ s/ in .+//mg;
chomp($errmsg);
$self->tmpl->param(abc => $errmsg);
--- expected
Content-Length: 34
Content-Type: text/html; charset=euc-jp

#abc: Can't locate InvalidView.pm

=== set content-type
--- input
$self->res->content_type('application/xhtml+xml; charset=utf-8');
$self->tmpl->param(abc => 'foo');
--- expected
Content-Length: 10
Content-Type: application/xhtml+xml; charset=utf-8

#abc: foo

=== use fillin_form
--- input
$self->r->param(hoge => 'fuga');
$self->tmpl->param(abc => '<input type="text" name="hoge" />');
$self->load_fillin_form;
--- expected chomp
Content-Length: 52
Content-Type: text/html; charset=euc-jp

#abc: <input value="fuga" name="hoge" type="text" />

