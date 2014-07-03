package Koala::Plugin::Paginator;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::ByteStream;

sub register {
  my ($self, $app, $conf) = @_;
  
  $app->helper('paginator' => sub {
    # Helper: paginator
    #   Paginator (what do you expect to see here?)
    # Parameters:
    #   self Mojolicious::Controller (I thought)
    #   url_name Str Mojolicious::Routes::Route's name
    #   cur Int current page number
    #   count Int count of items
    #   size Int like sql limit
    #   params ArrayRef Mojolicious::Routes::Route's params
    # Return:
    #   Mojo::ByteStream paginator's html
    
    my ($self, $url_name, $cur, $count, $size, $params) = @_;
    
    my $html = '';
    return '' if not defined $count or $count <= $size;
    
    my $last = int($count/$size);
    ++$last if $count % $size;
    
    # Render first page.
    $html .= sprintf '<a href="%s">&laquo;</a>',
      $self->url_for($url_name, page => 1) if $cur != 1;
    
    for my $i ($cur-5 .. $cur+5) {
      next if $i < 1 || $i > $last;
      $params = [] unless defined $params;
      
      $html .= ($i == $cur ? sprintf '<span>%s</span>', $cur :
        sprintf '<a href="%s">%s</a>',
          $self->url_for($url_name, @$params, page => $i), $i);
    }
    
    # Render last page.
    $html .= sprintf '<a href="%s">&raquo;</a>',
      $self->url_for($url_name, page => $last) if $cur != $last;
    
    Mojo::ByteStream->new("<div class=\"paginator\">$html</div>");
  });
}

1;

