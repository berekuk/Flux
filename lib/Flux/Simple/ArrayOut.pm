package Flux::Simple::ArrayOut;

# ABSTRACT: output stream which stores data in a given array

=head1 SYNOPSIS

    use Flux::Simple::ArrayOut;
    $out = Flux::Simple::ArrayIn->new(\@data);
    $out->write('foo');
    $out->write('bar');

    say for @data
    # Prints:
    # foo
    # bar

=head1 DESCRIPTION

Usually, you shouldn't create instances of this class directly. Use C<array_out> helper from L<Flux::Simple> instead.

=cut

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
