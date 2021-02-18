package OOCEapps::PkgUpd::Gnome;
use Mojo::Base 'OOCEapps::PkgUpd::base';

# public methods
sub canParse {
    my $self = shift;
    my $name = shift;
    my $url  = shift;

    return $url =~ m|^https?://download\.gnome\.org|;
}

sub getVersions {
    my $self = shift;
    my $name = shift;
    my $res  = shift;

    $name =~ s/sigcpp/libsigc++/;
    $name =~ s/glib2/glib/;
    $name =~ s/libidl/libIDL/;
    $name = $self->extractName($name);

    my $versions = $res->json ? $res->json->[2]->{$name} : [];

    return [ grep { ! /^\d+\.\d+[13579]\./ } @$versions ]
        if $name eq "glib";

    return $versions;
}

1;

__END__

=head1 COPYRIGHT

Copyright 2018 OmniOS Community Edition (OmniOSce) Association.

=head1 LICENSE

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.
This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
more details.
You should have received a copy of the GNU General Public License along with
this program. If not, see L<http://www.gnu.org/licenses/>.

=head1 AUTHOR

S<Dominik Hassler E<lt>hadfl@omnios.orgE<gt>>

=head1 HISTORY

2017-09-06 had Initial Version

=cut

