#!perl

use Test::More tests => 2;

use DBIx::Class::Core;
DBIx::Class::Core->load_components(qw/Result::Validation/);

my $obj = DBIx::Class::Core->new();

ok $obj->validate, "validate return 1 when _validate is not redefined";
ok !defined $obj->result_errors, "result_errors is null when _validate is not redefined";

