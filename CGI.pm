# $Id: CGI.pm,v 1.4 2003/03/21 17:50:32 philip Exp $
# $Name:  $

package Form::CGI;
use strict;
use warnings FATAL => 'all';
use Carp;

use CGI ();

$CGI::DefaultClass = $CGI::DefaultClass =__PACKAGE__;
$Form::CGI::AutoloadClass  = $Form::CGI::AutoloadClass = 'CGI';
@Form::CGI::ISA = qw( CGI );

use Time::Util;
use Date::Util;

require Exporter;
#use AutoLoader qw(AUTOLOAD);

#our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(

) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
   none
);

our $VERSION = do { my @r = (q$Revision: 1.4 $ =~ /\d+/g); sprintf " %d." . "%02d" x $#r, @r };

sub new {
    my $class = shift;
    my $this = $class->SUPER::new( @_ );

#    Apache->request->register_cleanup(\&CGI::Pretty::_reset_globals) if ($CGI::MOD_PERL);
    $class->_reset_globals if $CGI::PERLEX;

    return bless $this, $class;
}

sub delete { return 1}; ## Wonder Why I need this

sub _reset_globals     { initialize_globals() }
sub initialize_globals { return 1}

sub date_get ($$) {

  my ($self, $name) = @_;

  my $year    = $self->SUPER::param("$name\_year");
  my $month   = $self->SUPER::param("$name\_month");
  my $day     = $self->SUPER::param("$name\_day");
  my $weekday = $self->SUPER::param("$name\_weekday");

  if (wantarray) {
    return ($year, $month, $day, $weekday);
  }
  else {
    return "$year $month $day $weekday";
  }
}

sub time_get ($$) {

  my ($self, $name) = @_;

  my $hour = $self->SUPER::param("$name\_hour");
  my $min  = $self->SUPER::param("$name\_min");
  my $sec  = $self->SUPER::param("$name\_sec");
  my $ampm = $self->SUPER::param("$name\_ampm");

  if (wantarray) {
    return ($hour, $min, $sec, $ampm);
  }
  else {
    return "$hour:$min:$sec $ampm";
  }
}

sub time ($$\@\%) {

  my ($self, $name, $parts, $attrs) = @_;
  my $str = "";
  
  {
    no strict 'refs';

  $str .= $self->SUPER::popup_menu(
			    -name    => "$name\_hour",
                            -values  => \@hours,
 			    -default => $attrs->{'hour'}
                           ) if grep /hour/, @$parts;

  $str .= $self->SUPER::popup_menu(
			    -name   => "$name\_min",
                            -values => \@mins,
 			    -default => $attrs->{'min'}
                           ) if grep /mins/, @$parts;

  $str .= $self->SUPER::popup_menu(
			    -name   => "$name\_sec",
                            -values => \@secs,
 			    -default => $attrs->{'secs'}
                           ) if grep /secs/, @$parts;

  $str .= $self->SUPER::popup_menu(
			    -name   => "$name\_ampm",
                            -values => \@ampms,
 			    -default => $attrs->{'ampm'}
                           ) if grep /ampm/, @$parts;
  }

  return $str;
}

sub date ($$\@\%) {

  my ($self, $name, $parts, $attrs) = @_;
  my $str = "";
  my @years = ();

  if (grep /years/, @$parts) {
    confess ("No year range given") unless exists $attrs->{'years'};
    @years = @{$attrs->{'years'}};
  }


  {
    no strict 'refs';

  $str .= $self->SUPER::popup_menu(
                            -name    => "$name\_weekday",
                            -values  => \@weekdays_full,
                            -default => $attrs->{'weekday'}
                           ) if grep /weekdays/, @$parts;

  $str .= $self->SUPER::popup_menu(
                            -name    => "$name\_month",
                            -values  => \@months_full,
                            -default => $attrs->{'month'}
                           ) if grep /months/, @$parts;

  $str .= $self->SUPER::popup_menu(
                            -name   => "$name\_day",
                            -values => \@days,
                            -default => $attrs->{'day'}
                           ) if grep /^days$/, @$parts;

  $str .= $self->SUPER::popup_menu(
                            -name   => "$name\_year",
                            -values => \@years,
                            -default => $attrs->{'year'}
                           ) if grep /years/, @$parts;

  }

  return $str;
}




1;
__END__
=head1 NAME
    
Form::CGI - Utility which subclasses CGI adding my preferences
    
=head1 SYNOPSIS   
    
  use Form::CGI;
 
=head2 EXPORT

=head1 AUTHOR

Philip M. Gollucci, E<lt>philip@p6m7g8.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Philip M. Gollucci

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 ChangeLog

 $Log: CGI.pm,v $
 Revision 1.4  2003/03/21 17:50:32  philip
 Fixed the prototypes
 Added time_get, date_get
   They're not quite right yet, must return strings in formats that DateTime::Format and
   friends except
 Eventually, this module should sub class CGI::Pretty instead of just CGI.pm

 Revision 1.3  2003/03/16 18:03:32  philip
 Removed # from ChangeLog sections in perldocumation so it formats correctly

 Revision 1.2  2003/03/16 17:59:26  philip
 Moved =cut to end so that ChangeLog can be part of perldoc

 Revision 1.1.1.1  2003/03/16 16:36:45  philip
 Imported Sources

=cut
