package Flux::Simple::ArrayOut;

use Moo;
with 'Flux::Out';

has '_data' => (
    is => 'ro',
    required => 1,
);

sub BUILDARGS {
    my $class = shift;
    my ($data) = @_;
    return { _data => $data };
}

sub write {
    my $self = shift;
    my ($item) = @_;
    push @{ $self->_data }, $item;
    return;
}

sub write_chunk {
    my $self = shift;
    my ($chunk) = @_;

    push @{ $self->_data }, @$chunk;
    return;
}

sub commit {}

1;
