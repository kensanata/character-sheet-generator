#!/usr/bin/env perl

# Copyright (C) 2015 Alex Schroeder <alex@gnu.org>

# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <http://www.gnu.org/licenses/>.

use Test::More;
use Test::Mojo;
use FindBin;
use strict;
use warnings;

$ENV{MOJO_HOME} = "$FindBin::Bin/..";
require "$FindBin::Bin/../halberdsnhelmets.pl";

my $t = Test::Mojo->new;

$t->get_ok('/halberdsnhelmets/char?ac=0')
    ->status_is(200)
    ->header_is('Content-Type' => 'image/svg+xml')
    ->text_is('text#ac tspan' => '0', 'ac zero is shown');

done_testing();
