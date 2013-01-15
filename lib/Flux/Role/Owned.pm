package Flux::Role::Owned;

use Moo::Role;

# ABSTRACT: role for stream objects which belong to specific user

=head1 METHODS

=over

=cut

=item B<owner()>

Get object owner's login string.

=cut
requires 'owner';

=back

=cut

1;
