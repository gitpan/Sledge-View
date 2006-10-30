package Sledge::View::Template;
use strict;
use warnings;
use base qw/Sledge::View/;

sub process {
    my $self = shift;

    unless ($self->{page}->response->content_type) {
        $self->{page}->response->content_type($self->{page}->charset->content_type);
    }
    $self->{page}->response->body($self->render);
}

sub render {
    my $self = shift;

    # template output, then fillin forms
    my $output = $self->{page}->tmpl->output;

    my $send = $self->{page}->fillin_form
        ? $self->{page}->fillin_form->fillin( $output, $self->{page} )
        : $output;
    my ($content) = $self->{page}->charset->output_filter($send);

    for my $filter ( @{ $self->{page}->{filters} } ) {
        $content = $filter->( $self->{page}, $content );
    }
    return $content;
}

1;

__END__

=head1 NAME

Sledge::View::Template - Sledge::Pages::Base compatible view.

=head1 SYNOPSIS

    package Your::Pages;
    use Sledge::Plugin::View;

    sub create_view { Sledge::View::Template->new( shift ) }

    sub dispatch_foo {
        # ...
    }

    # or

    sub dispatch_foo {
        my $self = shift;

        # snip...

        Sledge::View::Template->new( $self )->process;
    }

=head1 DESCRIPTION

Sledge::Pages::Base compatible view class.

This module acts with Sledge::Template::*.

=head1 METHODS

=head2 new
    
    Sledge::View::Template->new($page);

generate new instance.The argument is instance of Sledge::Pages::Base.

=head2 process

Set the contents and headers to $self->response.

=head2 render

rendering the html.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

Tokuhiro Matsuno  C<< <tokuhiro __at__ mobilefactory.jp> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Tokuhiro Matsuno C<< <tokuhiro __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

