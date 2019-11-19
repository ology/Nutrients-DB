package Nutrients::DB;

# ABSTRACT: Frobnicate Universes

use Dancer2;
use Dancer2::Plugin::Database;

our $VERSION = '0.01';

=head1 NAME

Nutrients::DB - Frobnicate Universes

=head1 DESCRIPTION

A C<Nutrients::DB> frobnicates universes.

=head1 ROUTES

=head2 /

Main page.

=cut

get '/' => sub {
    my $letter = query_parameters->{letter};

    my $results = {};

    if ( $letter ) {
        my $table = 'nutrients';
        my $sql = qq/SELECT DISTINCT id, food FROM $table WHERE food LIKE ?/;
        my $sth = database($table)->prepare($sql);
        $sth->execute( $letter . '%' );
        $results = $sth->fetchall_hashref('food');
    }

    template 'index' => {
        letter  => $letter,
        results => $results,
    };
};

post '/search' => sub {
    my $search = body_parameters->{search_text};

    my $results = {};

    if ( $search ) {
        my $table = 'nutrients';
        my $sql = qq/SELECT DISTINCT id, food FROM $table WHERE food LIKE ?/;
        my $sth = database($table)->prepare($sql);
        $sth->execute( '%' . $search . '%' );
        $results = $sth->fetchall_hashref('food');
    }

    template 'index' => {
        results => $results,
    };
};

get '/food' => sub {
    my $id = query_parameters->{id};

    my $nutrients = {};
    my $food      = '';
    my $fgroup    = '';

    if ( $id ) {
        my $table = 'nutrients';
        my $sql = qq/SELECT * FROM $table WHERE id = ?/;
        my $sth = database($table)->prepare($sql);
        $sth->execute($id);
        $nutrients = $sth->fetchall_hashref('nutrient');

        for my $v ( values %$nutrients ) {
            $food   = $v->{food};
            $fgroup = $v->{fgroup};
            last;
        }
    }

    template 'food' => {
        nutrients => $nutrients,
        food      => $food,
        fgroup    => $fgroup,
    };
};

post '/compare' => sub {
    my @compare = body_parameters->get_all('compare');

    my $nutrients1 = {};
    my $nutrients2 = {};
    my $food1      = '';
    my $food2      = '';

    if ( @compare == 2 ) {
        my $table = 'nutrients';
        my $sql = qq/SELECT * FROM $table WHERE id = ?/;
        my $sth = database($table)->prepare($sql);
        $sth->execute($compare[0]);
        $nutrients1 = $sth->fetchall_hashref('nutrient');

        for my $v ( values %$nutrients1 ) {
            $food1 = $v->{food};
            last;
        }

        $sth->execute($compare[1]);
        $nutrients2 = $sth->fetchall_hashref('nutrient');

        for my $v ( values %$nutrients2 ) {
            $food2 = $v->{food};
            last;
        }

        my $nuts = {};

        for my $k ( keys %$nutrients2 ) {
            $nuts->{$k} = $nutrients2->{$k}{value};
        }

        for my $k ( keys %$nutrients1 ) {
            $nutrients1->{$k}{value} = $nutrients1->{$k}{value} . ' / '
                . ($nuts->{$k} ? $nuts->{$k} : 0);
        }
    }

    template 'compare' => {
        food1     => $food1,
        food2     => $food2,
        nutrients => $nutrients1,
    };
};

true;

__END__

=head1 SEE ALSO

L<Dancer2>

=head1 AUTHOR
 
Gene Boggs <gene@cpan.org>
 
=head1 COPYRIGHT AND LICENSE
 
This software is copyright (c) 2019 by Gene Boggs.
 
This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
 
=cut
