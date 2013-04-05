package Flux::Role::Description;

use Moo::Role;

# ABSTRACT: role for stream objects that implement 'description'

=head1 METHODS

=over

=cut

=item B<description()>

String with object's description.

Should not end with "\n" but can contain "\n" in the middle of the string.

=cut
requires 'description';

=back

=cut

1;
