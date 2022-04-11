#!/usr/bin/env perl

# Copyright (C) 2016-2022 Alex Schroeder <alex@gnu.org>

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
use Test::Mojo;
use utf8;

my $t = Test::Mojo->new('Game::CharacterSheetGenerator');
$t->app->log->level('warn');

$t->get_ok('/decode/de?code=A976ECT37-OZMKGII776Lb2U')
    ->status_is(200)
    ->header_is('Content-Type' => 'text/html;charset=UTF-8');

sub simplify {
  my $str = shift;
  $str =~ s/^\n*//;
  $str =~ s/^name:.*\n//m;
  $str =~ s/^charsheet:.*\n//m;
  $str =~ s/^xp:.*\n//m;
  $str =~ s/^portrait:.*\n//m;
  $str =~ s/^property: \d+ Gold\n//m;
  $str =~ s/^abilities: Code: .*\n//m;
  return $str;
}

my $new = simplify($t->tx->res->dom->at('textarea')->content);
my $original = simplify(<<EOT);
name: Rabia
str: 10
dex: 9
con: 7
int: 6
wis: 14
cha: 12
level: 1
thac0: 19
class: Dieb
hp: 3
ac: 7
property: Rucksack
property: Wegzehrung (1 Woche)
property: Lederrüstung
property: Langschwert
property: Kurzbogen
property: Köcher mit 20 Pfeilen (2)
property: Dolch (2)
property: Diebeswerkzeug
property: Laterne
property: Ölflasche
property: 12 Holzpfähle und Hammer
property: Spiegel
property: 14 Gold
abilities: 1/6 für normale Aufgaben
abilities: 2/6 für alle Aktivitäten
abilities: +4 und Schaden ×2 für hinterhältigen Angriff
abilities: Code: A976ECT37-OZMKGII776Lb2U
charsheet: Charakterblatt.svg
breath: 16
poison: 14
petrify: 13
wands: 15
spells: 13
EOT

for (my $i = 0; $i < length($new); $i++) {
  if (substr($original, $i, 1) ne substr($new, $i, 1)) {
    die "pos $i:\n"
	. join("\n", map { "< $_" } split(/\n/, substr($original, 0, $i) . "⌘" . substr($original, $i))) . "\n"
	. "====\n"
	. join("\n", map { "> $_" } split(/\n/, substr($new, 0, $i) . "⌘" . substr($new, $i))) . "\n";
  }
}
is($new, $original, "matches original character sheet");

done_testing;
