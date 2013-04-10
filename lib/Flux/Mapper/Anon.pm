package Flux::Mapper::Anon;

use Moo;
with 'Flux::Mapper::Easy';

has 'cb' => (
    is => 'ro',
    required => 1,
    # CODEREF
);

has 'commit_cb' => (
    is => 'ro',
    # CODEREF
    default => sub {
        sub { return }
    },
);

sub write {
    my ($self, $item) = @_;
    return $self->cb->($item);
}

sub commit {
    my ($self) = @_;
    return $self->commit_cb->();
}

1;
