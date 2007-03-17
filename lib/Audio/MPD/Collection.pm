#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#

package Audio::MPD::Collection;

use strict;
use warnings;
use Audio::MPD::Item::Directory;
use Audio::MPD::Item::Song;
use Scalar::Util qw[ weaken ];

use base qw[ Class::Accessor::Fast ];
__PACKAGE__->mk_accessors( qw[ _mpd ] );


our ($VERSION) = '$Rev$' =~ /(\d+)/;

#--
# Constructor

#
# my $collection = Audio::MPD::Collection->new( $mpd );
#
# This will create the object, holding a back-reference to the Audio::MPD
# object itself (for communication purposes). But in order to play safe and
# to free the memory in time, this reference is weakened.
#
# Note that you're not supposed to call this constructor yourself, an
# Audio::MPD::Collection is automatically created for you during the creation
# of an Audio::MPD object.
#
sub new {
    my ($pkg, $mpd) = @_;

    my $self = { _mpd => $mpd };
    weaken( $self->{_mpd} );
    return $self;
}


#--
# Public methods

# -- Collection: retrieving the whole collection

#
# my @albums = $collection->all_albums;
#
# Return the list of all albums (strings) currently known by mpd.
#
sub all_albums {
    my ($self) = @_;
    return
        map { /^Album: (.+)$/ ? $1 : () }
        $self->_mpd->_send_command( "list album\n" );
}


#
# my @artists = $collection->all_artists;
#
# Return the list of all artists (strings) currently known by mpd.
#
sub all_artists {
    my ($self) = @_;
    return
        map { /^Artist: (.+)$/ ? $1 : () }
        $self->_mpd->_send_command( "list artist\n" );
}


#
# my @titles = $collection->all_titles;
#
# Return the list of all titles (strings) currently known by mpd.
#
sub all_titles {
    my ($self) = @_;
    return
        map { /^Title: (.+)$/ ? $1 : () }
        $self->_mpd->_send_command( "list title\n" );
}


#
# my @pathes = $collection->all_pathes;
#
# Return the list of all pathes (strings) currently known by mpd.
#
sub all_pathes {
    my ($self) = @_;
    return
        map { /^File: (.+)$/ ? $1 : () }
        $self->_mpd->_send_command( "list filename\n" );
}


# -- Collection: songs, albums & artists relations

#
# my @albums = albums_from_artist($artist);
#
# Return all albums performed by $artist or where $artist participated.
#
sub albums_from_artist {
    my ($self, $artist) = @_;
    return
        map { /^Album: (.+)$/ ? $1 : () }
        $self->_mpd->_send_command( qq[list album "$artist"\n] );
}



1;

__END__


=head1 NAME

Audio::MPD::Collection - an object to query MPD's collection


=head1 SYNOPSIS

    my $song = $mpd->collection->random_song;


=head1 DESCRIPTION

C<Audio::MPD::Collection> is a class meant to access & query MPD's
collection. You will be able to use those high-level methods instead
of using the low-level methods provided by mpd itself.


=head1 PUBLIC METHODS

=head2 Constructor

=over 4

=item new( $mpd )

This will create the object, holding a back-reference to the C<Audio::MPD>
object itself (for communication purposes). But in order to play safe and
to free the memory in time, this reference is weakened.

Note that you're not supposed to call this constructor yourself, an
C<Audio::MPD::Collection> is automatically created for you during the creation
of an C<Audio::MPD> object.

=back


=head2 Retrieving the whole collection

=over 4

=item all_albums()

Return the list of all albums (strings) currently known by mpd.


=item all_artists()

Return the list of all artists (strings) currently known by mpd.


=item all_titles()

Return the list of all song titles (strings) currently known by mpd.


=item all_pathes()

Return the list of all pathes (strings) currently known by mpd.


=back


=head2 Songs, albums & artists relations

=over 4

=item albums_from_artist( $artist )

Return all albums performed by $artist or where $artist participated.


=back


=head1 SEE ALSO

You can find more information on the mpd project on its homepage at
L<http://www.musicpd.org>, or its wiki L<http://mpd.wikia.com>.

Regarding this Perl module, you can report bugs on CPAN via
L<http://rt.cpan.org/Public/Bug/Report.html?Queue=Audio-MPD>.

Audio::MPD development takes place on <audio-mpd@googlegroups.com>: feel free
to join us. (use L<http://groups.google.com/group/audio-mpd> to sign in). Our
subversion repository is located at L<https://svn.musicpd.org>.


=head1 AUTHORS

Jerome Quelin <jquelin@cpan.org>


=head1 COPYRIGHT AND LICENSE

Copyright (c) 2007 Jerome Quelin <jquelin@cpan.org>


This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

=cut
