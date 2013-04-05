package Flux::Mapper::Anon;

use Moo;
with 'Flux::Mapper::Easy';

use Params::Validate qw(:all);

has 'cb' => (
    is => 'ro',
    required => 1,
    # CODEREF
);

has 'commit_cb' => (
    is => 'ro',
    # CODEREF
    default => sub {
        sub {}
    },
);

sub write {
    my ($self, $item) = @_;
    return $self->{callback}->($item);
}

sub commit {
    my ($self) = @_;
    return $self->{commit}->();
}

1;
