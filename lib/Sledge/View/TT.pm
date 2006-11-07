package Sledge::View::TT;
use strict;
use warnings;
use base qw/Sledge::View/;
use Carp;
use Template;
use Template::Stash::EscapeHTML;

sub process {
    my $self = shift;

    unless ( $self->{page}->response->content_type ) {
        $self->{page}->response->content_type('text/html; charset=utf-8');
    }

    $self->{page}->response->body($self->render);
}

sub render {
    my $self = shift;

    my $page = $self->{page};

    my $options = {
        ABSOLUTE     => 1,
        RELATIVE     => 1,
        INCLUDE_PATH => [ $page->create_config->tmpl_path, '.' ],
        STASH        => Template::Stash::EscapeHTML->new,
    };

    my $params = {
        config  => $page->create_config,
        r       => $page->r,
        session => $page->session,
        c       => $page,
        %{ $page->stash }
    };

    my $template = Template->new($options);
    my $input = $page->stash->{template};
    unless (ref($input) || -e $input) {
        Sledge::Exception::TemplateNotFound->throw(
            "No template file detected: $input",
        );
    }

    $template->process($input, $params, \my $output) or do {
        Sledge::Exception::TemplateParseError->throw($template->error);
    };

    return $output;
}

1;

__END__

=head1 NAME

Sledge::View::TT - TT support for Sledge::View(Highly experimental)

=head1 SYNOPSIS

    package Your::Pages;
    use Sledge::Plugin::View;

    sub dispatch_foo {
        my $self = shift;

        $self->stash->{rows} = [[qw/a b/], [qw/c d/]];

        $self->view('TT')->process;
    }

=head1 DESCRIPTION

Template Toolkit support for Sledge::View.

This isn't use a Sledge::Template::TT.

=head1 METHODS

=head2 new
    
    Sledge::View::TT->new($page);

generate new instance.The argument is instance of Sledge::Pages::Base.

=head2 process

Set the contents and headers to $self->response.

=head2 render

rendering with TT.

=head1 CONFIGURATION

    $self->stash->{template} = "path/to/template.tt";

set the path to tt template file.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head1 AUTHOR

Tokuhiro Matsuno  C<< <tokuhiro __at__ mobilefactory.jp> >>

=head1 SEE ALSO

L< Sledge::Template::TT >, L<Catalyst::View::TT>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2006, Tokuhiro Matsuno C<< <tokuhiro __at__ mobilefactory.jp> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

