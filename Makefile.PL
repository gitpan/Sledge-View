use strict;
use warnings;
use inc::Module::Install;

name            'Sledge-View';
all_from        'lib/Sledge/View.pm';

requires 'HTTP::Headers' => 0;
requires 'Class::Accessor::Fast' => 0;
requires 'UNIVERSAL::require' => 0;
build_requires 'Class::Trigger' => 0;
build_requires 'Test::Base' => 0;

features(
    'Sledge::View::CSV' => [
        -default => 1,
        recommends('Text::CSV_XS'),
        recommends('Sledge::Plugin::Stash'),
    ]
);

use_test_base;
auto_install;
WriteAll;

