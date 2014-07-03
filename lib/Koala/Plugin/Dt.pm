package Koala::Plugin::Dt;
use Mojo::Base 'Mojolicious::Plugin';

use DateTime;
use DateTime::Format::MySQL;
use DateTime::Format::HTTP;

sub register {
  my ($self, $app, $conf) = @_;
  
  sub reformat {
    my ($dt, $fmt) = @_;
      
    if ($fmt eq 'dd.mm.yy') {
      my $d = $dt->day   < 10 ? '0'.$dt->day   : $dt->day;
      my $m = $dt->month < 10 ? '0'.$dt->month : $dt->month;
      my $y = substr $dt->year, 2;
      
      return "$d.$m.$y";
    }
    elsif ($fmt eq 'GMT') {
      return DateTime::Format::HTTP->format_datetime($dt);
    }
    
    return "Invalid format";
  }
  
  $app->helper('dt' => sub {
    # Helper: dt
    #   Datetime values representation.
    # Parameters:
    #   time - int|str - unix time OR other time format
    # Return:
    #   str|int
    
    my ($self, $time, $format) = @_;
    
    # Current time
    if (!defined $time) {
      my $dt = DateTime->now();
      return $format ? reformat($dt, $format) : DateTime::Format::MySQL->format_datetime($dt);
    }
    # Show time
    elsif ($time =~ /^\d+$/) {
      my $dt = DateTime->from_epoch(epoch => $time);
      return $format ? reformat($dt, $format) : DateTime::Format::MySQL->format_datetime($dt);
    }
    # get time from string
    elsif ($time =~ /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/) {
      my $dt = DateTime::Format::MySQL->parse_datetime($time);
      return $dt->epoch();
    }
  });
}

1;

