package Flux::Mapper::Easy;

# ABSTRACT: simplified version of Flux::Mapper role

=head1 DESCRIPTION

This role is an extension of Flux::Mapper role. It provides the sane C<write_chunk> implementation and the empty C<commit> implementation, so you only have to define C<write>.

=cut

use Moo::Role;
with 'Flux::Mapper';

sub write_chunk {
    my ($self, $chunk) = @_;
    die "write_chunk method expects arrayref, you specified: '$chunk'" unless ref($chunk) eq 'ARRAY'; # can chunks be blessed into something?
    my @result_chunk;
    for my $item (@$chunk) {
        push @result_chunk, $self->write($item);
    }
    return \@result_chunk;
}

sub commit {
    return ();
}

=head1 SEE ALSO

You can use C<mapper> helper from L<Flux::Simple> to create a mapper object without defining a new class.

=cut

1;
