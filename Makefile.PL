use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DBIx::Class::Result::Validation',
    AUTHOR              => q{Nicolas Oudard <nicolas@oudard.org>},
    VERSION_FROM        => 'lib/DBIx/Class/Result/Validation.pm',
    LICENSE             => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
        'Carp::Clan' => 0,
        'Try::Tiny' => 0,
        'namespace::clean' => 0,
        'Test::More' => 0,
        'DBIx::Class' => 0.08123,
        'Class::Accessor::Grouped' => 0.09008,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'DBIx-Class-Result-Validation-*' },
);

