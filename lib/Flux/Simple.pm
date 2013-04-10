package Flux::Simple;

use strict;
use warnings;

use Flux::Simple::ArrayIn;
use Flux::Simple::ArrayOut;
use Flux::Mapper::Anon;

use parent qw(Exporter);
our @EXPORT_OK = qw( array_in array_out mapper );

sub array_in {
    my ($arrayref) = @_;
    return Flux::Simple::ArrayIn->new($arrayref);
}

sub array_out {
    my ($arrayref) = @_;
    return Flux::Simple::ArrayOut->new($arrayref);
}

sub mapper(&) {
    my ($cb) = @_;

    return Flux::Mapper::Anon->new(cb => $cb);
}

1;
