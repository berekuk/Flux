package Flux::Mapper::MappedMapper;

use Moo::Role;
with 'Flux::Mapper';

sub new {
    my ($class, $f1, $f2) = @_;
    return bless {
        f1 => $f1,
        f2 => $f2,
    } => $class;
}

sub write {
    my ($self, $item) = @_;
    my @items = $self->{f1}->write($item);
    my @result = map { $self->{f2}->write($_) } @items;
    return (wantarray ? @result : $result[0]);
}

sub write_chunk {
    my ($self, $chunk) = @_;
    $chunk = $self->{f1}->write_chunk($chunk);
    return $self->{f2}->write_chunk($chunk);
}

sub commit {
    my ($self) = @_;
    my @items = $self->{f1}->commit;
    my $result = $self->{f2}->write_chunk(\@items);
    push @$result, $self->{f2}->commit;
    return @$result;
}

1;
