package Stream::Filter::FilteredIn;

use Moo;
with 'Flux::In';

sub new {
    my ($class, $in, $filter) = @_;
    return bless {
        filter => $filter,
        in => $in,
    } => $class;
}

sub read {
    my ($self) = @_;
    while (my $item = $self->{in}->read()) {
        my @filtered = $self->{filter}->write($item);
        next unless @filtered;
        die "One-to-many not implemented in source filters" unless @filtered == 1;
        return $filtered[0];
    }
    return; # underlying input stream is depleted
}

sub read_chunk {
    my ($self, $limit) = @_;
    my $chunk = $self->{in}->read_chunk($limit);
    return unless $chunk;
    return $self->{filter}->write_chunk($chunk);
}

sub commit {
    my ($self) = @_;
    my @items = $self->{filter}->commit;
    die "flushable filters cannot be attached to input streams" if @items;
    #FIXME: check it earlier
    $self->{in}->commit;
}

sub lag {
    my $self = shift;
    die "underlying input stream doesn't implement Lag role" unless $self->{in}->DOES('Stream::In::Role::Lag');
    return $self->{in}->lag;
}

sub shift {
    my $self = shift;
    my $item = $self->read or return;
    return @$item;
}

sub DOES {
    my ($self, $role) = @_;
    if ($role eq 'Stream::In::Role::Lag' or $role eq 'Stream::In::Role::Shift') {
        # Some roles depen on being implemented by the underlying input stream.
        # I guess in future we'll have lots of such role propagating logic... in this case moose metaclasses would be handy.
        return $self->{in}->DOES($role);
    }
    return $self->SUPER::DOES($role);
}

{
    no strict 'refs';
    *does = \&DOES;
}

1;
