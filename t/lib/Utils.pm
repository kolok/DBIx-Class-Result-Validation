package t::lib::Utils;

use strict;
use warnings;

use base 'Exporter';
use vars '@EXPORT';

@EXPORT = qw/ populate_database /;

sub populate_database
{
  my $schema = shift;


  my @artists = (['object 1'], ['object 2']);
  $schema->populate('Object', [
    [qw/name/],
    @artists,
    ]);
}

1;
