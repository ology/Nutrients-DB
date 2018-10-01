use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on it.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'Nutrients::DB',
    AUTHOR              => q{Gene Boggs <gene@ology.net>},
    VERSION_FROM        => 'lib/Nutrients/DB.pm',
    ABSTRACT            => 'Alphabetical interface into USDA nutrition',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer2'     => 0.205002,
        'Dancer2::Plugin::Database' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Nutrients-DB-*' },
);
