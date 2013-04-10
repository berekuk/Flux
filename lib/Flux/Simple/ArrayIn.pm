package Flux::Simple::ArrayIn;

use Moo;
with 'Flux::In';

has '_data' => (
    is => 'ro',
    required => 1,
);

sub BUILDARGS {
    my $class = shift;
    my ($data) = @_;
    return { _data => $data };
}

sub read {
    my $self = shift;
    return shift @{ $self->_data };
}

sub read_chunk {
    my $self = shift;
    my ($number) = @_;

    return unless @{ $self->_data };
    return [ splice @{ $self->_data }, 0, $number ];
}

sub commit {}

1;
