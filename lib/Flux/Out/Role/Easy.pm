package Flux::Out::Role::Easy;

# ABSTRACT: simplified version of Flux::Out role

=head1 CONSUMER SYNOPSIS

    use Moo;
    with "Flux::Out::Role::Easy";

    sub write {
        my ($self, $item) = @_;
        say $item;
    }

=head1 DESCRIPTION

This role is an extension of L<Flux::Out> role. It provides the sane C<write_chunk> implementation and the empty C<commit> implementation, so you only have to define C<write>.

=cut

use Moo::Role;
with 'Flux::Out';

sub write_chunk {
    my $self = shift;
    my ($chunk, @extra) = @_;

    die "write_chunk method expects arrayref, you specified: '$chunk'" unless ref($chunk) eq 'ARRAY'; # can chunks be blessed into something?
    for my $item (@$chunk) {
        $self->write($item, @extra);
    }
    return;
}

sub commit {
}

=head1 SEE ALSO

This role is a specialization of L<Flux::Out>.

=cut

1;
