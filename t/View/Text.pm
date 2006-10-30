package t::View::Text;
use strict;
use warnings;
use base qw/Sledge::View/;

sub process {
    my $self = shift;

    $self->{page}->res->content_type('text/plain');
    $self->{page}->res->body($self->render);
}

sub render {
    my $self = shift;
    return $self->{page}->tmpl->param('text');
}

1;
