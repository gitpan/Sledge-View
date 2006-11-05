package Sledge::View;
use strict;
use warnings;
our $VERSION = 0.05;
use Sledge::Exceptions;

sub new {
    my ($class, $page) = @_;

    return bless {page => $page}, $class;
}

sub process {
    Sledge::Exception::AbstractMethod->throw
}

sub render {
    Sledge::Exception::AbstractMethod->throw
}

1;
__END__

=head1 NAME

Sledge::View - abstract base class for Sledge's view(EXPERIMENTAL!!)

=head1 SYNOPSIS

    package Sledge::View::Hoge;
    use base qw/Sledge::View/;

    sub process {
        # set the response
    }

    sub render {
        # rendering the content
    }

=head1 DESCRIPTION

The abstract base class of the Sledge's View class.

=head1 METHODS

=head2 new
    
    Sledge::View::Foo->new($page);

generate new instance.The argument is instance of Sledge::Pages::Base.

=head2 process

set the contents and headers to $self->response.

=head2 render

generate the contents from $self->stash.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

Tokuhiro Matsuno  C<< <tokuhiro __at__ mobilefactory.jp> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Tokuhiro Matsuno C<< <tokuhiro __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

