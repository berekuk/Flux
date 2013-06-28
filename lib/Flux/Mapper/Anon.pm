package Flux::Mapper::Anon;

# ABSTRACT: callback-style mapper

=head1 DESCRIPTION

Usually, you shouldn't create instances of this class directly. Use C<mapper> helper from L<Flux::Simple> instead.

=cut

use Moo;
with 'Flux::Mapper::Role::Easy';

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
