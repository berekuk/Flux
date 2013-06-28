package Flux::In::Role::Easy;

# ABSTRACT: simplified version of Flux::In role

=head1 CONSUMER SYNOPSIS

    use Moo;
    with "Flux::In::Role::Easy";

    my $i = 0;
    sub read {
        return $i++;
    }

=head1 DESCRIPTION

This role is an extension of L<Flux::In> role. It provides the sane C<read_chunk> implementation and the empty C<commit> implementation, so you only have to define C<read>.

=cut

use Moo::Role;
with 'Flux::In';

sub read_chunk {
    my $self = shift;
    my ($limit) = @_;

    my @chunk;
    while (defined($_ = $self->read)) {
        push @chunk, $_;
        last if @chunk >= $limit;
    }
    return unless @chunk; # return false if nothing can be read
    return \@chunk;
}

sub commit {
}

=head1 SEE ALSO

This role is a specialization of L<Flux::In>.

=cut

1;
