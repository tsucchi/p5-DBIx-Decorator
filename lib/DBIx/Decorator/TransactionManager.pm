package DBIx::Decorator::TransactionManager;
use parent qw(DBIx::Decorator);

use strict;
use warnings;
use DBIx::TransactionManager;
use Carp qw();

sub new {
    my ($class, $dbh) = @_;
    my $self = $class->SUPER::new($dbh);
    $self->{txn_manager} = DBIx::TransactionManager->new($self);
    bless $self, $class;
}

sub txn_begin {
    my $self = shift;
    $self->{txn_manager}->txn_begin(@_);
}

sub txn_commit {
    my $self = shift;
    $self->{txn_manager}->txn_commit(@_);
}

sub txn_rollback {
    my $self = shift;
    $self->{txn_manager}->txn_rollback(@_);
}

sub txn_scope {
    my $self = shift;
    return $self->{txn_manager}->txn_scope(@_);
}

sub in_transaction {
    my $self = shift;
    return $self->{txn_manager}->in_transaction(@_);
}

sub begin_work {
    my $self = shift;
    if( !$self->_is_managed_transaction() ) {
        Carp::croak("use txn_begin or txn_scope instead");
    }
    $self->SUPER::begin_work(@_);
}

sub commit {
    my $self = shift;
    if( !$self->_is_managed_transaction() ) {
        Carp::croak("use txn_commit or commit from txn_scope's guard object instead");
    }
    $self->SUPER::commit(@_);
}

sub rollback {
    my $self = shift;
    if( !$self->_is_managed_transaction() ) {
        Carp::croak("use txn_rollback or rollback from txn_scope's guard object instead");
    }
    $self->SUPER::rollback(@_);
}

sub _is_managed_transaction {
    my ($self) = @_;
    my ($package) = caller(1);
    return $package eq 'DBIx::TransactionManager';
}


1;
__END__

=head1 NAME

DBIx::Decorator::TransactionManager - add transaction management functionality to DBI

=head1 SYNOPSIS

  use DBI;
  use DBIx::Decorator::TransactionManager; # DBIx::Decorator's subclass
  my $dbh = DBIx::Decorator::TransactionManager->new(DBI->connect(...));
  my $txn = $dbh->txn_scope(); # got transaction object from wrapped dbh.
  my $row = $dbh->selectrow_hashref("SELECT * FROM employee WHERE id=?", undef, 123); #normal usage
  # $dbh->begin_work; # this is not allowed!

=head1 DESCRIPTION

DBIx::Decorator::TransactionManager provides transaction management functionality to DBI's database handler($dbh).
this module provieds methods that  L<DBIx::TransactionManager> has and prohibits default transaction functionality 
that provides L<DBI>(begin_work/commit/rollback).

=head1 METHODS

=head2 $wrapped_dbh = DBIx::Decorator::TransactionManager->new($dbh)

create instance. returns wrapped $dbh. wrapped $dbh and provide additional methods that L<DBIx::TransactionManager> has.

=head1 METHODS FROM DBIx::TransactionManager

=head2 txn_begin

=head2 txn_commit

=head2 txn_rollback

=head2 txn_scope

=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi {at} cpan.orgE<gt>

=head1 SEE ALSO

L<DBIx::Decorator>, L<DBIx::TransactionManager>


=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
