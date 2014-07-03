package Koala::Config;
use Mojo::Base -base;
use FindBin;
use JSON::XS;

has config => sub {{}};
has required => sub {['database']};

sub new {
  my $self = shift;
  $self->SUPER::new()
  
  local $/;
  
  for my $file (<$FindBin::Bin/../conf/*.json>) {
    my $conf = eval {
      open (my $fh, $file) or die "Can't find $file";
      my $config = <$fh>;
      close $fh;
      return decode_json $config;
    } or {};
    
    $this->config = { %{$this->config}, %$conf };
  }
  
  my $message = '';
  $message .= qq{Can't find config "$_" but it's really necessary.\n}
    for grep {not exists $this->config->{$_}} @{$this->required};
  
  say($message, "See ./conf directory for more information."), exit if $message;
}

sub get_config {
  my $self = shift;
  return $self->config;
}

1;

