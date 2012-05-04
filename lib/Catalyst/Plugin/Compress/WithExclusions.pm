package Catalyst::Plugin::Compress::WithExclusions;

use strict;
use warnings;
use base qw(Catalyst::Plugin::Compress);

=head1 NAME

Catalyst::Plugin::Compress::WithExclusions - Compresses all responses from the server, except excluded paths

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

my @excluded = (
  '^download',
);

=head1 SYNOPSIS

    use Catalyst qw/Compress::WithExclusions/;

Then specifiy the excluded paths as an array ref of regular expressions
and the compression format that you want to use.

    __PACKAGE__->config(
      compression_excluded => ['path_regex', ],
      compression_format => $format
    );

Accepted formats are the same as defined in L<Catalyst::Plugin::Compress>

=head1 SUBROUTINES/METHODS

=cut

sub setup {
  my $c = shift;

  if (exists $c->config->{compression_excluded}) {
    if (ref($c->config->{compression_excluded}) eq 'ARRAY') {
      @excluded = @{$c->config->{compression_excluded}};
    }
    else {
      if ($c->debug) {
        $c->log->debug("'compression_excluded' configuration should be an array reference'");
      }
    }
  }
  $c->maybe::next::method(@_);
}

=head2 should_compress_response

This is an internal method that fisrt checks to see if the path should be excluded
from compression and then passes on to the parent for further checks.

=cut

sub should_compress_response {
  my $c = shift;
  my $action = $c->req->action;

  foreach my $test (@excluded) {
    if ($action =~ /$test/) {
      return;
    }
  }
  $c->maybe::next::method(@_);
}

=head1 AUTHOR

Jody Clements, C<< <clementsj at janelia.hhmi.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-catalyst-plugin-compress-hmmer at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Catalyst-Plugin-Compress-WithExclusions>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Catalyst::Plugin::Compress::WithExclusions


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Catalyst-Plugin-Compress-WithExclusions>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Catalyst-Plugin-Compress-WithExclusions>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Catalyst-Plugin-Compress-WithExclusions>

=item * Search CPAN

L<http://search.cpan.org/dist/Catalyst-Plugin-Compress-WithExclusions/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Jody Clements.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Catalyst::Plugin::Compress::WithExclusions
