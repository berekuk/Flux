package Flux::In::Role::Lag;

# ABSTRACT: role for input streams which are aware of their lag

=head1 DESCRIPTION

Input streams implementing this role can be asked for the amount of data remaining in the stream.

Amount units are implementation-specific. Sometimes it's in bytes, sometimes it's in items.

=cut

use Moo::Role;

=head1 METHODS

=over

=item B<lag()>

Get stream's lag.

=cut
requires 'lag';

=back

=cut

1;
