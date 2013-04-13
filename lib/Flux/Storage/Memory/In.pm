package Flux::Storage::Memory::In;

# ABSTRACT: in-memory input stream for Flux::MemoryStorage

use Moo;
with
    'Flux::In::Role::Easy',
    'Flux::In::Role::Lag';

has 'storage' => (
    is => 'ro',
    required => 1,
);

has 'client' => (
    is => 'ro',
    required => 1,
);

has 'pos' => (
    is => 'rw',
    lazy => 1,
    default => sub {
        my $self = shift;
        return $self->storage->_get_client_pos($self->client);
    },
);

sub read {
    my $self = shift;
    my $item = $self->storage->_read($self->pos);
    return unless $item;
    $self->pos($self->pos + 1);
    return $item;
}

sub commit {
    my $self = shift;
    $self->storage->_set_client_pos($self->client, $self->pos);
}

sub lag {
    my $self = shift;
    return $self->storage->_lag($self->pos);
}

sub DEMOLISH {
    local $@;
    my $self = shift;
    $self->storage->_unlock_client($self->client);
}

1;
