package Advent::Point::Point2;

use Mojo::Base 'Advent::Point';

sub new {
    my ($class, $x, $y) = @_;

    my $self = {
        x => $x,
        y => $y,
    };
    bless $self, $class;
    return $self;
}

sub add {
    my ($self, $p) = @_;
    my $nx = $self->x + $p->x;
    my $ny = $self->y + $p->y;
    return Advent::Point::Point2->new($nx, $ny);
}

sub dist {
    my ($self, $p) = @_;
    my $dx = abs($self->x - $p->x);
    my $dy = abs($self->y - $p->y);
    return $dx + $dy;
}

sub key {
    my $self = shift;
    return join $;, ($self->x, $self->y);
}

sub print {
    my $self = shift;
    say '(' . $self->x . ', ' , $self->y . ')';
}

1;
