package OOCEapps::PkgUpd::GitHub;
use Mojo::Base 'OOCEapps::PkgUpd::base';

my %TRANSFORM = (
    'azure-agent'   => 'WALinuxAgent',
    'libgd'         => 'gd',
    'fuse'          => 'Version',
    'minio'         => 'RELEASE',
    'minio-mc'      => 'RELEASE',
);

# public methods
sub canParse {
    my $self = shift;
    my $name = shift;
    my $url  = shift;

    # OpenJDK needs an extra parser
    return $url =~ /github\.com/ && $name !~ m|^developer/java/openjdk|;
}

sub getVersions {
    my $self = shift;
    my $name = shift;
    my $res  = shift;

    $name = $self->extractName($name);

    # jsonrpclib and meson are Python packages - remove the version suffix
    $name =~ s/-\d{2}$// if $name =~ /^(?:jsonrpclib|meson)/;

    $name = $TRANSFORM{$name} if exists $TRANSFORM{$name};

    my @versions = $res->dom->find('a')->each;
    s/_/./g for @versions;
    return [
        map { m#/releases/tag/(?:v|release-|stable-|R\.|$name-?\.?)?
            (\d{4}(?:-\d{2}){2}T(?:\d{2}-){2}\d{2}Z|[\d.]+\d+)
            (?!-?(?:\.\d+|rc\d+|dev|a(?:lpha)?|b(?:eta)?))#ix
        } @versions
    ];
}

1;

__END__

=head1 COPYRIGHT

Copyright 2020 OmniOS Community Edition (OmniOSce) Association.

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

S<Dominik Hassler E<lt>hadfl@omniosce.orgE<gt>>

=head1 HISTORY

2017-09-06 had Initial Version

=cut

