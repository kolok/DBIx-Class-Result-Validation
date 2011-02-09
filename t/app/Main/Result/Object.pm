package t::app::Main::Result::Object;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('object');
__PACKAGE__->add_columns('objectid',
                         { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
                         'name',
                         {data_type => 'varchar', is_nullable => 0});
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
