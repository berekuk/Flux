package Flux::In::Role::Easy;

# ABSTRACT: role to implement input streams with only one read() method

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

1;
