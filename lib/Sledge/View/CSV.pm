package Sledge::View::CSV;
use strict;
use warnings;
use base qw/Sledge::View/;
use Carp;
use Text::CSV_XS;
use Scalar::Util qw/blessed/;

sub process {
    my $self = shift;

    my $filename = $self->{page}->stash->{file} || 'output.csv';
    $self->{page}->response->content_type('text/comma-separated-values');
    $self->{page}->response->header('Content-Disposition', qq{attachment; filename="$filename"});
    $self->{page}->response->body($self->render);
}

sub render {
    my $self = shift;

    my $content = '';

    my $csv = Text::CSV_XS->new($self->{page}->stash->{csv_option} || {binary => 1});

    my $oneline = sub {
        $csv->combine(@_);
        $content .= $csv->string . "\n";
    };

    unless ($self->{page}->stash->{rows} || $self->{page}->stash->{iter}) {
        croak "no rows for csv";
    }

    # headers
    if (my @header = @{ $self->{page}->stash->{header} || []}) {
        $oneline->(@header);
    }

    # body
    my @keys = @{ $self->{page}->stash->{keys} || []};
    if (my $iter = $self->{page}->stash->{iter}) {
        while (my $row = $iter->next) {
            $oneline->(map { $row->$_ } @keys);
        }
    }
    else {
        my @rows = @{ $self->{page}->stash->{rows}};
        for my $row ( @rows ) {
            if (ref $row eq 'HASH') {
                $oneline->(map { $row->{$_} } @keys);
            }
            elsif (blessed $row) {
                $oneline->(map { $row->$_ } @keys);
            }
            elsif (ref $row eq 'ARRAY') {
                $oneline->(@$row);
            }
            else {
                croak "invalid input: $row";
            }
        }
    }

    # footer
    if (my @footer = @{ $self->{page}->stash->{footer} || []}) {
        $oneline->(@footer);
    }

    return $content;
}

1;

__END__

=head1 NAME

Sledge::View::CSV - Sledge::Pages::Base compatible view.

=head1 SYNOPSIS

    package Your::Pages;
    use Sledge::Plugin::View;

    sub dispatch_foo {
        my $self = shift;

        $self->stash->{rows} = [[qw/a b/], [qw/c d/]];

        Sledge::View::CSV->new( $self )->process;
    }

    # output is...

    a,b
    c,d

=head1 DESCRIPTION

csv output view.

=head1 METHODS

=head2 new
    
    Sledge::View::CSV->new($page);

generate new instance.The argument is instance of Sledge::Pages::Base.

=head2 process

Set the contents and headers to $self->response.

=head2 render

rendering the csv.

=head1 CONFIGURATION

    $self->stash->{csv_option} = {sep_char => "\t"};

You can set the argument of Text::CSV_XS->new;

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

Tokuhiro Matsuno  C<< <tokuhiro __at__ mobilefactory.jp> >>

=head1 THANKS TO

    id:nekokak

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Tokuhiro Matsuno C<< <tokuhiro __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

