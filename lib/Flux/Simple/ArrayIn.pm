package Flux::Simple::ArrayIn;

# ABSTRACT: input stream representation of an array

=head1 SYNOPSIS

    use Flux::Simple::ArrayIn;
    $in = Flux::Simple::ArrayIn->new(\@items);

=head1 DESCRIPTION

Usually, you shouldn't create instances of this class directly. Use C<array_in> helper from L<Flux::Simple> instead.

=cut

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
