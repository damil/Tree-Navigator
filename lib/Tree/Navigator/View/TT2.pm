package Tree::Navigator::View::TT2;
use strict;
use warnings;

use Moose;
use namespace::autoclean;
use Template;

=pod

TODO : supply INCLUDE_PATH=> [$self]

sub paths {
}

sub error {

}

Q: inherit from Template::Base ??

Probl: each node type should have a way to "register" some share dirs

paths : join @INC, mro_linear_isa(ref $self);

=cut



my %template_common_args = (
  TRIM => 1,
 );

extends 'Tree::Navigator::View';
has 'tt'    => ( is => 'ro', isa => 'Template' );
has 'input' => ( is => 'ro' );

around 'BUILDARGS' => sub {
  my $parent_buildargs = shift;
  my $class            = shift;
  my $input            = shift;
  my $template_args    = $class->$parent_buildargs(@_);

  return {tt    => Template->new(%$template_args),
          input => $input};

  # TODO: also take args from $tn->config
};



sub render {
  my ($self, $node, $request) = @_;

  my $values = { node    => $node,
                 data    => $node->data,
                 request => $request };
  $self->tt->process($self->input, $values, \my $output)
    or return [500, ['Content-type' => 'text/plain'],
                    [$self->tt->error->as_string] ];

  return [200, ['Content-type' => 'text/html'], [$output] ];

  # TODO: extend API to choose other content-type and maybe add other headers
}


1; # end of package Tree::Navigator::View::TT2

__END__
