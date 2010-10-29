#!perl

use Test::More tests => 9;

use DBIx::Class::Core;
DBIx::Class::Core->load_components(qw/Result::Validation/);

my $obj = DBIx::Class::Core->new();

ok $obj->validate, "validate return 1 when result_errors is null";
ok !defined $obj->result_errors, "result_errors is null";

$obj->add_result_error("key","error 1");

ok !$obj->validate, "validate return 0 when result_errors is not null";
isa_ok $obj->result_errors, 'HASH', "result_errors is not null and is a hash";

$obj->add_result_error("key","error 2");

isa_ok $obj->result_errors()->{'key'}, 'ARRAY', "result_errors is not null and is a hash";
is scalar(@{$obj->result_errors()->{'key'}}), 2, "1 key error can have more than one error logged";

$obj->add_result_error("key2","error key2");

is scalar(keys(%{$obj->result_errors()})), 2, "result error can have more than one key in error";

$obj->_erase_result_error();

ok $obj->validate, "_erase_result_error erase result_errors and object became valid";
ok !defined $obj->result_errors, "_erase_result_error erase result_errors and object became valid";

