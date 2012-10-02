use inc::Module::Install;
name 'DBIx-Decorator';
all_from 'lib/DBIx/Decorator.pm';
readme_from 'lib/DBIx/Decorator.pm';
readme_markdown_from 'lib/DBIx/Decorator.pm';
readme_pod_from 'lib/DBIx/Decorator.pm';
githubmeta;

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
