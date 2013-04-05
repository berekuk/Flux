#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';
use Test::More;
use Test::Fatal;

use Flux::Mapper::Anon;

is exception { Flux::Mapper::Anon->new }, undef;

done_testing;
