package Stream::Filter::FilteredOut;

use Moo;
with 'Flux::Out';

sub new {
    my ($class, $filter, $out) = @_;
    return bless {
        filter => $filter,
        out => $out,
    } => $class;
}

sub write {
    my ($self, $item) = @_;
    my @items = $self->{filter}->write($item);
    $self->{out}->write($_) for @items;
}

sub write_chunk {
    my ($self, $chunk) = @_;
    $chunk = $self->{filter}->write_chunk($chunk);
    return $self->{out}->write_chunk($chunk);
}

sub commit {
    my ($self) = @_;
    my @items = $self->{filter}->commit;
    $self->{out}->write_chunk(\@items);
    return $self->{out}->commit;
}

1;
