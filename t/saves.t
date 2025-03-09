#!/usr/bin/env perl

# Copyright (C) 2025 Alex Schroeder <alex@gnu.org>

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
use Game::CharacterSheetGenerator;
use Test::More;

# Default save for level 1 fighter

my $char = { class => "fighter", level => 1 };
$char->{provided} = [keys %$char];
Game::CharacterSheetGenerator::saves($char);

is($char->{"breath-bonus"}, "+5", "fighter 1 save vs dragon breath");
is($char->{breath}, 15, "fighter 1 save vs dragon breath Target 20");

$char = { class => "fighter", level => 4 };
$char->{provided} = [keys %$char];
Game::CharacterSheetGenerator::saves($char);

is($char->{"breath-bonus"}, "+7", "fighter 3 save vs dragon breath");
is($char->{breath}, 13, "fighter 3 save vs dragon breath Target 20");

$char = { breath => 19 };
$char->{provided} = [keys %$char];
Game::CharacterSheetGenerator::saves($char);

is($char->{breath}, 19, "classic");
is($char->{"breath-bonus"}, "+1", "from classic to Target 20");

$char = { "breath-bonus" => "+1" };
$char->{provided} = [keys %$char];
Game::CharacterSheetGenerator::saves($char);

is($char->{breath}, 19, "from Target 20 to classic");
is($char->{"breath-bonus"}, "+1", "Target 20");

done_testing();
