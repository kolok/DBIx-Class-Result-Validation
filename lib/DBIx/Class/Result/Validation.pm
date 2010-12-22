package DBIx::Class::Result::Validation;

use strict;
use warnings;

=head1 NAME

DBIx::Class::Result::Validation - DBIx::Class component to manage validation on result object

=head1 VERSION

Version 0.03

=cut


our $VERSION = '0.03';

=head1 SYNOPSIS

DBIx::Class::Result::Validation component call validate function before insert or update object and unauthorized these actions if validation set result_errors accessor.

In your result class load_component :

    Package::Schema::Result::MyClass;

    use strict;
    use warning;

    __PACKAGE__->load_component(qw/ ... Result::Validation /);

defined your _validate function which will be called by validate function

    sub _validate
    {
      my $self = shift;
      #validate if this object exist whith the same label
      my @other = $self->result_source->resultset->search({ label => $self->label
                                                            id => {"!=", $self->id}});
      if (scalar @other)
      {
        $self->add_result_error('label', 'label must be unique');
      }

    }

When you try to create or update an object Package::Schema::Result::MyClass, if an other one with the same label exist, this one will be not created, validate return 0 and $self->result_errors will be set.

$self->result_errors return :

    { label => ['label must be unique'] }

Otherwise, object is create, validate return 1 and $self->result_errors is undef.

It is possible to set more than one key error and more than one error by key

    $self->add_result_error('label', 'label must be unique');
    $self->add_result_error('label', "label must not be `$self->label'");
    $self->add_result_error('id', 'id is ok but not label');

$self->result_errors return :

    {
      label => [
              'label must be unique',
              "label must not be `my label'"
              ],
      id => [
           'id is ok but not label'
            ]
    }

=head1 Reserved Accessor

DBIx::Class::Result::Validation component create a new accessor to Result object.

    $self->result_errors

This field is used to store all errors

=cut

use base qw/ DBIx::Class Class::Accessor::Grouped /;
__PACKAGE__->mk_group_accessors(simple => qw(result_errors));

=head1 SUBROUTINES/METHODS

=head2 validate

This validate function is called before insert or update action.
If result_errors is not defined it return true

You can redefined it in your Result object and call back it with  :

    return $self->next::method(@_);

=cut

sub validate {
  my $self = shift;
  $self->_erase_result_error();
  $self->_validate();
  return 0 if (defined $self->result_errors());
  return 1;
};

=head2 _validate

_validate function is the function to redefine with validation behaviour object

=cut

sub _validate
{
  return 1;
}

=head2 add_result_error

    $self->add_result_error($key, $error_string)

Add a string error attributed to a key (field of object)

=cut

sub add_result_error
{
  my ($self, $key, $value) = @_;
  if (defined $self->result_errors)
  {
    if (defined $self->{result_errors}->{$key})
    { push(@{$self->{result_errors}->{$key}}, $value); }
    else
    { $self->{result_errors}->{$key} = [$value]; }
  }
  else
  { $self->result_errors({$key => [$value]}); }
}

=head2 insert

call before DBIx::Calss::Base insert

Insert is done only if validate method return true

=cut

sub insert {
    my $self = shift;
    return ($self->next::method(@_),1) if ($self->validate);
    return ($self, 0);
}

=head2 update

call before DBIx::Calss::Base update

Update is done only if validate method return true

=cut

sub update {
    my $self = shift;
    my $columns = shift;
    $self->set_inflated_columns($columns) if $columns;
    return $self->next::method(@_) if ($self->validate);
    return 0;
}

=head2 _erase_result_error

this function is called to re-init result_errors before call validate function

=cut

sub _erase_result_error
{
    my $self = shift;
    $self->result_errors(undef);
}

1;
__END__

=head1 SEE ALSO

L<"DBIx::Class">

=head1 AUTHOR

Nicolas Oudard <nicolas@oudard.org>

=head1 CONTRIBUTORS


=head1 LICENSE

You may distribute this code under the same terms as Perl itself.
