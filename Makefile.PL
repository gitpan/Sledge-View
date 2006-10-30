use strict;
use warnings;
use inc::Module::Install;

name            'Sledge-View';
all_from        'lib/Sledge/View.pm';

requires 'Class::Accessor::Fast' => 0;
requires 'UNIVERSAL::require' => 0;
build_requires 'Class::Trigger' => 0;
build_requires 'Test::Base' => 0;

use_test_base;
auto_install;
WriteAll;

