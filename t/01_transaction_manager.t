#!perl
use strict;
use warnings;
use Test::More;
use DBI;
use DBIx::Decorator::TransactionManager;
use Try::Tiny;
use Capture::Tiny qw(capture_stderr);

subtest 'transaction(begin/commit)', sub {
    my $dbh = DBIx::Decorator::TransactionManager->new(
        DBI->connect('dbi:Mock:', '', '', +{ AutoCommit => 1, RaiseError => 1 })
    );
    $dbh->txn_begin;
    ok( $dbh->in_transaction );
    $dbh->txn_commit;
    ok( !$dbh->in_transaction );
};

subtest 'transaction(begin/rollback)', sub {
    my $dbh = DBIx::Decorator::TransactionManager->new(
        DBI->connect('dbi:Mock:', '', '', +{ AutoCommit => 1, RaiseError => 1 })
    );
    $dbh->txn_begin;
    ok( $dbh->in_transaction );
    $dbh->txn_rollback;
    ok( !$dbh->in_transaction );
};


subtest 'default transaction is obsolute', sub {
    my $dbh = DBIx::Decorator::TransactionManager->new(
        DBI->connect('dbi:Mock:', '', '', +{ AutoCommit => 1, RaiseError => 1 })
    );
    exception_ok('use txn_begin or txn_scope instead', sub { $dbh->begin_work } );
    exception_ok("use txn_commit or commit from txn_scope's guard object instead",     sub { $dbh->commit } );
    exception_ok("use txn_rollback or rollback from txn_scope's guard object instead", sub { $dbh->rollback } );
};

subtest 'txn_scope(commit)', sub {
    my $dbh = DBIx::Decorator::TransactionManager->new(
        DBI->connect('dbi:Mock:', '', '', +{ AutoCommit => 1, RaiseError => 1 })
    );
    my $txn = $dbh->txn_scope;
    ok( $dbh->in_transaction );
    $txn->commit;
    ok( !$dbh->in_transaction );
};

subtest 'txn_scope(rollback)', sub {
    my $dbh = DBIx::Decorator::TransactionManager->new(
        DBI->connect('dbi:Mock:', '', '', +{ AutoCommit => 1, RaiseError => 1 })
    );
    my $txn = $dbh->txn_scope;
    ok( $dbh->in_transaction );
    $txn->commit;
    ok( !$dbh->in_transaction );
};

subtest 'txn_scope dismiss guard', sub {
    my $dbh = DBIx::Decorator::TransactionManager->new(
        DBI->connect('dbi:Mock:', '', '', +{ AutoCommit => 1, RaiseError => 1 })
    );
    {
        capture_stderr sub { # avoid warning message
            my $txn = $dbh->txn_scope;
            ok( $dbh->in_transaction );
        };
    } #dismiss guard
    ok( !$dbh->in_transaction );
};


done_testing;

sub exception_ok {
    my ($expected_message, $coderef) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    try {
        $coderef->();
        fail('exception expected');
    } catch {
        like( $_, qr/$expected_message/ );
    };
}
