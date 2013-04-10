package Flux::Simple;

# ABSTRACT: functional-style stream generators

=head1 SYNOPSIS

    use Flux::Simple qw( array_in array_out mapper );

    my $mapper = mapper { shift() * 3 };
    say $mapper->write(10); # 30

    my $in = array_in([ 5,6,7 ]);
    say $in->read; # 5

    my @data;
    my $out = array_out(\@data); # writes to $out will populate @data

=cut

use strict;
use warnings;

use Flux::Simple::ArrayIn;
use Flux::Simple::ArrayOut;
use Flux::Mapper::Anon;

use parent qw(Exporter);
our @EXPORT_OK = qw( array_in array_out mapper );

=head1 FUNCTIONS

=over

=item B<array_in($arrayref)>

Create an input stream which shifts items from a specified arrayref and returns them as values.

=cut
sub array_in {
    my ($arrayref) = @_;
    return Flux::Simple::ArrayIn->new($arrayref);
}

=item B<array_out($arrayref)>

Create an output stream which puts items into specified arrayref on writes.

=cut
sub array_out {
    my ($arrayref) = @_;
    return Flux::Simple::ArrayOut->new($arrayref);
}

=item B<mapper($write_cb)>

=item B<mapper($write_cb, $flush_cb)>

Create an anonymous mapper which calls C<&write_cb> on each item.

If C<&flush_cb> is provided, it will be called at the commit step and its results will be used too (but remember that flushable mappers can't be attached to input streams).

=cut
sub mapper(&;&) {
    my ($cb, $commit_cb) = @_;

    my @args = (cb => $cb);
    push @args, commit_cb => $commit_cb if defined $commit_cb;
    return Flux::Mapper::Anon->new(@args);
}

1;
