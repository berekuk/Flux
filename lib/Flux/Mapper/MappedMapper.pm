package Flux::Mapper::MappedMapper;

use Moo;
with 'Flux::Mapper';

has ['left', 'right'] => (
    is => 'ro',
    required => 1,
);

sub write {
    my ($self, $item) = @_;
    my @items = $self->left->write($item);
    my @result = map { $self->right->write($_) } @items;
    return (wantarray ? @result : $result[0]);
}

sub write_chunk {
    my ($self, $chunk) = @_;
    $chunk = $self->left->write_chunk($chunk);
    return $self->right->write_chunk($chunk);
}

sub commit {
    my ($self) = @_;
    my @items = $self->left->commit;
    my $result = $self->right->write_chunk(\@items);
    push @$result, $self->right->commit;
    return @$result;
}

1;