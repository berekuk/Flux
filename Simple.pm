=head1 EXPORTABLE FUNCTIONS

=over

=item I<filter(&write_cb)>

=item I<filter(&write_cb, &flush_cb)>

Create anonymous fitler which calls C<&write_cb> on each item.

If C<&flush_cb> is provided, it'll be called at commit step and it's results will be used too (but remember that flushable filters can't be attached to input streams).

=cut
# not a method! (TODO - remove it from method namespace using namespace::clean?)
sub filter(&;&) {
    my ($filter, $commit) = validate_pos(@_, { type => CODEREF }, { type => CODEREF, optional => 1 });
    # alternative constructor
    return Stream::Filter::Anon->new($filter, $commit);
}

