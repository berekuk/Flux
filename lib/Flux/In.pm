package Flux::In;

# ABSTRACT: input stream role

use Moo::Role;

=head1 SYNOPSIS

    $line = $in->read;
    $chunk = $in->read_chunk($limit);
    $in->commit;

=head1 DESCRIPTION

C<Flux::In> is the role which every reading stream must implement.

Consumers must implement C<read>, C<read_chunk> and C<commit> methods.

=head1 INTERFACE

=over

=item B<read()>

Get the next item from the stream.

Returns undef when there's no data left.

=cut
requires 'read';

=item B<read_chunk($limit)>

Get the new chunk with items. Chunk is an arrayref with items, ordered as if C<read()> was invoked several times.

C<$limit> is a recommendation. Most input streams respect it and return exactly this number of items in chunk, but some don't. So if you get a chunk with 1 item when you asked for 5, don't treat it as a sign that you don't need to read further. Read until you get an undef or an empty chunk.

=cut
requires 'read_chunk';

=item B<commit()>

Commit input stream's position.

Generally, successful commit means that you can restart your program and continue from the same position next time. Although some streams don't support position at all, for example, C<array_in> from L<Stream::Simple>.

Stream's author should make sure that stream is still readable after this.

=cut
requires 'commit';

=back

=cut

1;
