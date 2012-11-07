package TAP::Formatter::Color::Win32;

# The following is taken from TAP::Formatter::Color 3.25
# with a little tweak for Test::Pretty to always use Term::ANSIColor
# even under Win32.

use strict;
use vars qw($VERSION @ISA);

@ISA = qw(TAP::Object);

my $NO_COLOR;

BEGIN {
    $NO_COLOR = 0;

    eval 'use Term::ANSIColor; use Win32::Console::ANSI';
    if ($@) {
        $NO_COLOR = $@;
    }
    else {
        *set_color = sub {
            my ( $self, $output, $color ) = @_;
            $output->( color($color) );
        };
    }

    if ($NO_COLOR) {
        *set_color = sub { };
    }
}

sub _initialize {
    my $self = shift;

    if ($NO_COLOR) {

        # shorten that message a bit
        ( my $error = $NO_COLOR ) =~ s/ in \@INC .*//s;
        warn "Note: Cannot run tests in color: $error\n";
        return;    # abort object construction
    }

    return $self;
}

sub can_color {
    return !$NO_COLOR;
}

1;
