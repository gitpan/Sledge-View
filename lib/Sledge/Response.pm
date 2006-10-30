package Sledge::Response;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;

__PACKAGE__->mk_accessors(qw/body content_type/);

1;

=head1 NAME

Sledge::Response - response object for Sledge

=head1 SYNOPSIS

    package Your::Pages;

    sub dispatch_foo {
        my $self = shift;
        $self->response->content_type('text/html');
        $self->response->body('hoge');
    }

=head1 DESCRIPTION

HTTP response object for Sledge.

=head1 METHODS

=head2 body
    
HTTP Response body.

=head2 content_type

HTTP Response content_type.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

Tokuhiro Matsuno  C<< <tokuhiro __at__ mobilefactory.jp> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Tokuhiro Matsuno C<< <tokuhiro __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

