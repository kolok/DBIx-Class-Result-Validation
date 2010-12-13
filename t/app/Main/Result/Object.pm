package t::app::Main::Result::Object;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('object');
__PACKAGE__->add_columns(qw/ objectid name /);
__PACKAGE__->set_primary_key('objectid');
__PACKAGE__->load_components(qw/ Result::Validation /);

sub _validate
{
  my $self = shift;
  my @other = $self->result_source->resultset->search({name => $self->name, objectid => { "!=", $self->objectid} });
  if (scalar @other)
  {
    $self->add_result_error('name', 'name must be unique');
  }
  if ($self->name eq 'error')
  {
    $self->add_result_error('name', "name can not be 'error'");
  }
  return $self->next::method(@_);
}
1;
