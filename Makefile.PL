use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DBIx::Class::Result::Validation',
    AUTHOR              => q{Nicolas Oudard <noudard@weborama.com>},
    VERSION_FROM        => 'lib/DBIx/Class/Result/Validation.pm',
    LICENSE             => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'DBIx::Class' => 0.08123,
        'Class::Accessor::Grouped' => 0.09008,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'DBIx-Class-Result-Validation-*' },
);

