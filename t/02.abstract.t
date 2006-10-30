use strict;
use warnings;
use Test::Base;
use Sledge::View;

filters(
    {   input    => [qw/eval/],
        expected => [qw/regexp/],
    }
);

plan tests => 1*blocks;

run_like 'input' => 'expected';

__END__

=== process
--- input
Sledge::View->process
--- expected
This method is abstract

=== render
--- input
Sledge::View->render
--- expected
This method is abstract
