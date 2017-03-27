#!/usr/bin/perl -w

use Test::More tests => 1;
use t::app::Main;
use t::lib::Utils;
use Try::Tiny;
use Data::Dumper;
#use DBIx::Class::Core;
#DBIx::Class::Core->load_components(qw/Result::Validation/);
#my $obj = DBIx::Class::Core->new();
#ok $obj->validate, "validate return 1 when _validate is not redefined";
#ok !defined $obj->result_errors, "result_errors is null when _validate is not redefined";


my $schema = t::app::Main->connect('dbi:SQLite:t/example.db');
$schema->deploy({ add_drop_table => 1 });
populate_database($schema);

subtest "Enum Validation" => sub {
my $obj1;
$obj1 = $schema->resultset('Object')->create({name => "good", my_enum => "val1", my_enum_def => "val1"});
ok($obj1->id, "create Object with name 'good' is Ok");

my $obj2;
my $error;
try {
    $obj2 = $schema->resultset('Object')->create({name => "goodx", my_enum=>"valx", my_enum_def => "val1"});
}
catch {
    $error = $_;
};
ok(!defined $obj2, "can not object with a non valid my_enum");
isa_ok( $error, "DBIx::Class::Result::Validation::VException", "error returned is a DBIx::Class::Result::Validation::VException");
ok( $error->object->result_errors, "error returned object with result_error");
ok (defined$error->object->result_errors->{my_enum}, "error exists on my_enum");


my $obj3;
$error="";
try {
    $obj3 = $schema->resultset('Object')->create({name => "goodx", my_enum_def => "val2"});
}
catch {
    $error = $_;
};
ok($obj3->id, "create Object with name 'goodx' is Ok, default value works on my_enum");


my $obj4;
$error="";
try {
    $obj4 = $schema->resultset('Object')->create({name => "goodxy", my_enum_def => "val666"});
}
catch {
    $error = $_;
};
ok(!defined $obj4, "can not object with a non valid my_enum_def");
isa_ok( $error, "DBIx::Class::Result::Validation::VException", "error returned is a DBIx::Class::Result::Validation::VException");
ok( $error->object->result_errors, "error returned object with result_error");
ok (defined $error->object->result_errors->{my_enum_def}, "error exists on my_enum_def");

my $obj5;
$error="";
try {
    $obj5 = $schema->resultset('Object')->create({name => "goodxy"});
}
catch {
    $error = $_;
};
ok(!defined $obj5, "can not object with a non valid my_enum_def");
isa_ok( $error, "DBIx::Class::Result::Validation::VException", "error returned is a DBIx::Class::Result::Validation::VException");
ok( $error->object->result_errors, "error returned object with result_error");
ok (defined $error->object->result_errors->{my_enum_def}, "error exists on my_enum_def : must be defined");
};
