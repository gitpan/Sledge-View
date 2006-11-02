package Sledge::Response;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;
use HTTP::Headers;

__PACKAGE__->mk_accessors(qw/body headers/);
sub content_encoding { shift->headers->content_encoding(@_) }
sub content_length   { shift->headers->content_length(@_) }
sub content_type     { shift->headers->content_type(@_) }
sub header           { shift->headers->header(@_) }

sub new { bless { headers => HTTP::Headers->new }, shift }

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

yeah, this module is copy of Catalyst::Response.

=head1 METHODS

=head2 new

create new instance.

=head2 header

Shortcut for $res->headers->header.

=head2 body
    
HTTP Response body.

=head2 content_type

HTTP Response content_type.

=head2 content_encoding

Shortcut for $res->headers->content_encoding.

=head2 content_length

Shortcut for $res->headers->content_length.

=head2 content_type

Shortcut for $res->headers->content_type.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

Tokuhiro Matsuno  C<< <tokuhiro __at__ mobilefactory.jp> >>

=head1 SEE ALSO

L<Catalyst::Response>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Tokuhiro Matsuno C<< <tokuhiro __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

