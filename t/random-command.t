#!/usr/bin/env perl

# Copyright (C) 2023 Alex Schroeder <alex@gnu.org>

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

use Modern::Perl;
use Test::More;
use IPC::Open2;
use Mojo::DOM;
use Test::Mojo;
use Mojo::File;

my $script = Mojo::File->new('script', 'character-sheet-generator');

# random

my $pid = open2(my $out, my $in, $^X, $script, 'random', 'de', 'text', 'class=Mietling');
# always slurp!
undef $/;
my $data = <$out>;
like($data, qr/^class: Mietling$/m, "Mietling");
like($data, qr/^level: 0$/m, "Stufe");
like($data, qr/^hp: [1-4]$/m, "hp");
waitpid($pid, 0);
my $child_exit_status = $? >> 8;
is($child_exit_status, 0, "Exit status OK");


done_testing;
