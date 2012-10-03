package DBIx::Decorator;
use strict;
use warnings;
use DBI;
our @ISA = qw(DBI::db);
our $VERSION = '0.01';

sub new {
    my ($class, $dbh) = @_;
    my $self = $dbh;
    bless $self, $class;
}

1;
__END__

=head1 NAME

DBIx::Decorator - extensible DBI wrapper using Decorator pattern

=head1 SYNOPSIS

  use DBIx::Decorator;
  use DBI;
  use DBIx::Decorator::TransactionManager;
  my $dbh = DBIx::Decorator::TransactionManager->new(DBI->connect(...));
  my $txn = $wrapped_dbh->txn_scope(); # got transaction object from wrapped dbh.
  my $row = $wrapped_dbh->selectrow_hashref("SELECT * FROM employee WHERE id=?", undef, 123); #normal usage


=head1 DESCRIPTION

DBIx::Decorator is

=head1 METHODS

=head2 $wrapped_dbh = DBIx::Decorator->new($dbh)

create instance. returns wrapped $dbh. 


=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi {at} cpan.orgE<gt>

=head1 SEE ALSO

L<DBIx::Decorator::TransactionManager>


=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
