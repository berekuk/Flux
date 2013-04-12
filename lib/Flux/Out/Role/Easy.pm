package Flux::Out::Role::Easy;

# ABSTRACT: role to implement output streams with only one write() method

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

1;
