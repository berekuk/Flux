package Flux::Mapper;

# ABSTRACT: objects for transforming input or output streams.

=head1 SYNOPSIS

    $new_item = $mapper->write($item);
    # or when you know that mapper can generate multiple items from one:
    @items = $mapper->write($item);

    $new_chunk = $mapper->write_chunk(\@items);

    @last_items = $mapper->commit; # some mappers keep items in internal buffer and process them at commit step

    $mapped_in = $in | $mapper; # resulting object is a input stream
    $double_mapper = $mapper1 | $mapper2; # resulting object is a mapper too
    $mapped_out = $mapper | $out # resulting object is a output stream

=head1 DESCRIPTION

C<Flux::Mapper> instances can be attached to other streams to filter, expand and transform their data.

It's API is currently identical to C<Flux::Out>, consisting of C<write>, C<write_chunk> and C<commit> methods, but unlike common output streams, values returned from these methods are always getting used.

Depending on context, mappers can map input or output streams, or be attached to other mappers to construct more complex mappers.

The easiest way to create a new mapper is to use C<mapper(&)> function from C<Flux::Simple>. Alternatively, you can inherit your class from C<Flux::Mapper> and implement C<write> and/or C<write_chunk> methods (and optionally C<commit> too).

C<|> operator is overloaded by all mappers. It works differently depending on a second argument. Synopsis contains some examples which show the details.

Mappers don't have to return all results after each C<write> call, and results don't have to match mapper's input in one-to-one fashion. On the other hand, there are some mapper clients which assume it to be so. In the future there'll probably emerge some specializations expressed in roles.

=cut

use Moo::Role;

use Carp;
use Scalar::Util qw(blessed);

use Flux::Out;

use overload '|' => sub {
    my ($left, $right, $swap) = @_;

    require Flux::Mapper::MappedIn;
    require Flux::Mapper::MappedOut;
    require Flux::Mapper::MappedMapper;

    if ($swap) {
        ($left, $right) = ($right, $left);
    }
    unless (blessed $left and $left->can('does')) {
        croak "Left side of pipe is not a flux object, but '$left'";
    }
    unless (blessed $right and $right->can('does')) {
        croak "Right side of pipe is not a flux object, but '$right'";
    }

    if ($left->does('Flux::Mapper') and $right->does('Flux::Mapper')) {
        # m | m
        return Flux::Mapper::MappedMapper->new(left => $left, right => $right);
    }

    if ($left->does('Flux::Mapper') and $right->does('Flux::Out')) {
        # m | o
        return Flux::Mapper::MappedOut->new(mapper => $left, out => $right);
    }

    if ($left->does('Flux::In') and $right->does('Flux::Mapper')) {
        # i | m
        return Flux::Mapper::MappedIn->new(in => $left, mapper => $right);
    }

    croak "Strange arguments '$left' and '$right'";

}, '""' => sub { $_[0] }; # strangely, when I overload |, I need to overload other operators too...

=head1 INTERFACE

=over

=item I<write($item)>

Process one item and return some "mapped" (rewritten) items.

Number of returned items can be any, from zero to several, so returned data should always be processed in the list context, unless you're absolutely sure that your filter is of one-to-one kind.

=cut
requires 'write';

=item I<write_chunk($chunk)>

Process one chunk and returns another, rewritten chunk.

Rewritten chunk can contain any number of items, independently from the original chunk, but it should be an arrayref, even if it's empty.

=cut
requires 'write_chunk';

=item I<commit()>

C<commit> method can flush cached data and return remaining transformed items as plain list.

If you don't need flushing, just return C<()>, or use C<Flux::Mapper::Easy> instead of this role.

=cut
requires 'commit';

=back

=cut

1;
