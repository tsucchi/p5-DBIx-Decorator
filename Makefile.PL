use inc::Module::Install;
name 'DBIx-Decorator';
all_from 'lib/DBIx/Decorator.pm';
readme_from 'lib/DBIx/Decorator.pm';
readme_markdown_from 'lib/DBIx/Decorator.pm';
readme_pod_from 'lib/DBIx/Decorator.pm';
githubmeta;

requires 'DBI';
requires 'DBIx::TransactionManager';
test_requires 'DBD::Mock';
test_requires 'Try::Tiny';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
