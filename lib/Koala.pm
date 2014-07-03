package Koala;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;
  push @{$self->plugins->namespaces}, 'Koala::Plugin';

  $self->plugin('Paginator');
  $self->plugin('Dt');
  $self->plugin('Common');

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
}

1;
