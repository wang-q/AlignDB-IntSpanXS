use 5.008000;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'AlignDB::IntSpanXS',
    VERSION_FROM  => 'lib/AlignDB/IntSpanXS.pm',
    PREREQ_PM     => { "AlignDB::IntSpan" => 0, },
    ABSTRACT_FROM => 'lib/AlignDB/IntSpanXS.pm',
    AUTHOR        => 'Wang Qiang <wangqiang1997{at}gmail.com>',
    LIBS          => '',
    DEFINE => '',                 # '-DHAVE_SOMETHING'
    INC    => '-I. ',
    OBJECT => 'intspan.o xs.o',
);
