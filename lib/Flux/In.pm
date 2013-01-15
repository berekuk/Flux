package Flux::In;

# ABSTRACT: input stream role

use Moo::Role;

=head1 SYNOPSIS

    $line = $in->read;
    $chunk = $in->read_chunk($limit);
    $in->commit;

=head1 DESCRIPTION

C<Flux::In> is a role which every reading stream must implement.

Consumers must implement C<read>, C<read_chunk> and C<commit> methods.

=head1 INTERFACE

=over

=item B<read()>

C<read()> method must return any defined scalar when there's something left in stream, and undef when stream is over.

=cut
requires 'read';

=item B<read_chunk($limit)>

C<read_chunk> receives an integer limit as its only argument and should return array ref with items, ordered as if C<read()> was invoked several times, or undef if there is no data left in the stream.

=cut
requires 'read_chunk';

=item B<commit()>

C<commit> method can commit position, print statistics or do anything neccessary to make sure that reading is completed correctly.

Stream's author should make sure that stream is still readable after that.

=cut
requires 'commit';

=back

=cut

1;
