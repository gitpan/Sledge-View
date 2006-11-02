package Sledge::Plugin::View;
use strict;
use warnings;
use Sledge::Exceptions;
use Sledge::Response;
use UNIVERSAL::require;

sub import {
    my $pkg = caller(0);

    # add BEFORE_OUTPUT trigger
    no strict 'refs'; ## no critic
    *{"$pkg\::output_content"} = sub {
        my $self = shift;

        unless ($self->response->body) {
            # process the default view.
            $self->create_view->process;
        }

        $self->r->content_type($self->response->content_type);
        $self->set_content_length(length $self->response->body);
        $self->send_http_header;

        $self->r->print($self->response->body);

        $self->invoke_hook('AFTER_OUTPUT');

        $self->finished(1);
    };

    # generate contents with default view
    *{"$pkg\::make_content"} = sub {
        my $self = shift;
        return $self->create_view->render;
    };

    $pkg->mk_accessors(qw/response/);
    {
        no warnings 'once';
        *{"$pkg\::res"} = *{"$pkg\::response"}; # shortcut
    }

    $pkg->add_trigger(
        AFTER_INIT => sub {
            my $self = shift;
            $self->response(Sledge::Response->new($self));
        }
    );

    *{"$pkg\::view"} = sub {
        my ($self, $class) = @_;

        my $sclass = "Sledge::View::$class";
        if ($sclass->use) {
            $class = $sclass;
        }
        else {
            $class->use or die $@;
        }

        return $class->new($self);
    };
}

1;
__END__

=head1 NAME

Sledge::Plugin::View - use Sledge::View!(EXPERIMENTAL!!!)

=head1 SYNOPSIS

    package Your::Pages;
    use Sledge::Plugin::View;
    use Sledge::View::Template;

    # set default view class.
    sub create_view { Sledge::View::Template->new(shift) }

    sub dispatch_index {
        # use default view.
    }

    sub dispatch_qrcode {
        my $self = shift;
        $self->view('QRCode')->process('http://www.google.com/');
    }

=head1 DESCRIPTION

 ** THIS VERSION IS VERY EXPERIMENTAL. AT YOUR OWN RISK. **

use the Sledge::View!!

=head1 METHODS

=head2 response

=head2 res

accessor for the instance of Sledge::Response.

=head2 view

    $self->view('Template')->process; # Sledge::View::Template
    $self->view('Proj::View::QRCode')->process('http://example.com/'); # custom view

get a new instance of Sledge::View::*.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

Tokuhiro Matsuno  C<< <tokuhiro __at__ mobilefactory.jp> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Tokuhiro Matsuno C<< <tokuhiro __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

