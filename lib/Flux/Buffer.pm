package Flux::Buffer;

# ABSTRACT: reordering buffer role

=head1 SYNOPSIS

    $buffer->save([ "abc", "def" ]);

    say $buffer->size; # 2

    $buffer->load(2); # returns [ [5, "abc"], [6, "def"] ]

    say $buffer->size; # 2

    $buffer->delete([5,6]);

use Moo::Role;

=head1 METHODS

=over

=item B<save($chunk)>

Save C<@$chunk> items into a buffer.

=cut
requires 'save';

=item B<load($limit)>

Load up to C<$limit> enumerated items from a buffer.

=cut
requires 'load';

=item B<delete($ids)>

Remove items identified by C<@$ids> from the buffer.

=cut
requires 'delete';

=item B<lag()>

Measure buffer size in bytes.

=cut
requires 'lag';

=back

=cut

1;
