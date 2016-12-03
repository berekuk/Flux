package Flux::In;

# ABSTRACT: input stream interface

use Moo::Role;

=head1 SYNOPSIS

    # How to use objects implementing this role

    $line = $in->read;
    $chunk = $in->read_chunk($limit);
    $in->commit;

=head1 CONSUMER SYNOPSIS

    # How to consume this role

    use Moo;
    with "Flux::In";

    has counter => (
        is => "rw",
        default => sub { 0 },
    );

    sub read {
        my ($self) = @_;
        my $counter = $self->counter;
        $self->counter($counter + 1);
        return "Line $counter";
    }

    sub read_chunk {
        my ($self, $limit) = @_;
        my $counter = $self->counter;
        $self->counter($counter + $limit);
        return [ $counter .. $counter + $limit - 1 ];
    }

    sub commit {
        say "commiting position";
    }

=head1 DESCRIPTION

C<Flux::In> is a role which every reading stream must implement.

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

=head1 SEE ALSO

L<Flux::In::Role::Easy> - specialization of this role for those who don't want to bother with 3 methods, and want to just implement C<read()>.

L<Flux::In::Role::Lag> - role for input streams which are aware of their lag.

=cut

1;
