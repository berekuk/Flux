package Flux::Mapper::MappedOut;

# ABSTRACT: representation of mapper|out

=head1 DESCRIPTION

Don't create instances of this class directly.

Use C<$mapper | $out> syntax sugar instead.

=cut

use Moo;
with 'Flux::Out';

has 'mapper' => (
    is => 'ro',
    required => 1,
);

has 'out' => (
    is => 'ro',
    required => 1,
);

sub write {
    my $self = shift;
    my ($item) = @_;

    my @items = $self->mapper->write($item);
    $self->out->write($_) for @items;
    return;
}

sub write_chunk {
    my $self = shift;
    my ($chunk) = @_;

    $chunk = $self->mapper->write_chunk($chunk);
    $self->out->write_chunk($chunk);
    return;
}

sub commit {
    my ($self) = @_;

    my @items = $self->mapper->commit; # flushing the stuff remaining in possible mapper buffers
    $self->out->write_chunk(\@items);
    $self->out->commit;
    return;
}

1;
