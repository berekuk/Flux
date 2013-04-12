package Flux::Storage::Role::ClientList;

# ABSTRACT: common methods for storages with named clients

=head1 SYNOPSIS

    @client_names = $storage->client_names;

    $in = $storage->stream($client_name);

    $storage->register_client($client_name);
    $storage->unregister_client($client_name);

    $storage->has_client($client_name);

=head1 DESRIPTION

Some storages are able to generate stream by client's name. This role guarantees that storage implements some common methods for listing and registering storage clients.

=cut

use Moo::Role;

=head1 METHODS

=over

=item B<< client_names() >>

Get all storage client names as a plain list.

=cut
requires 'client_names';

=item B<< register_client($name) >>

Register a new client in the storage.

Default implementation does nothing.

=cut
sub register_client($$) {
}

=item B<< unregister_client($name) >>

Unregister a client from the storage.

Default implementation does nothing.

=cut
sub unregister_client($$) {
}

=item B<< has_client($name) >>

Check whether the storage has a client with given name.

Default implementation uses C<client_names()>, but you can override it for the sake of performance.

=cut
sub has_client {
    my $self = shift;
    my ($name) = @_;

    return grep { $_ eq $name } $self->client_names;
}

=back

=cut

1;
