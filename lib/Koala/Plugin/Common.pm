package Koala::Plugin::Common;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::ByteStream;

sub register {
  my ($self, $app, $conf) = @_;
  
  $app->helper('config' => sub {
    state $config = Koala::Config->new;
    return $config->get_config();
  });
  
  $app->helper('error_json' => sub {
    my ($self, @data) = @_;
    return $self->render(json => {status => 500, @data});
  });
  
  $app->helper('not_found' => sub {
    return shift->render(template => 'not_found', status => 404)
  });
  
  $app->helper('not_found_json' => sub {
    shift->render(json => {
      error => 404,
      status => 404,
      'message' => 'Page not found'
    })
  });
  
  $app->helper('crlf' => sub {
    my ($self, $text) = @_;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    $text =~ s/\r?\n/<br>/g;
    return Mojo::ByteStream->new($text);
  });
}

1;

