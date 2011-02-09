#!/usr/bin/perl -w

use strict;
use warnings;
use Test::More;
use t::app::Main;
use t::lib::Utils;

plan tests => 7;

my $schema = t::app::Main->connect('dbi:SQLite:t/example.db');
$schema->deploy({ add_drop_table => 1 });
populate_database($schema);

my ($obj1, $result1) = $schema->resultset('Object')->create({name => "good"});
is($result1, 1, "create Object with name 'good' is Ok");
my @objects1 = $schema->resultset('Object')->search({name => "good"});
is( scalar(@objects1),1,"validation is ok, object was create");

my ($obj2,$result2) = $schema->resultset('Object')->create({name => "good"});
is( $result2, 0, "can not create 2 objects with the same name");
my @objects2 = $schema->resultset('Object')->search({name => "good"});
is( scalar(@objects2),1,"can not create 2 objects with the same name");

my $object3 = $objects2[0];
$object3->name('error');
my $result3 = $object3->update();
ok( $object3->result_errors, "can not update object with an error");
my @objects3 = $schema->resultset('Object')->search({name => "error"});
is( scalar(@objects3),0,"can not update object with the name 'error'");
my @objects4 = $schema->resultset('Object')->search({name => "good"});
is( scalar(@objects4),1,"can not update object with the name 'error'");

