package Flux::Mapper::Easy;

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

1;
