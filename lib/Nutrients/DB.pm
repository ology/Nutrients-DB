package Nutrients::DB;

# ABSTRACT: Frobnicate Universes

use Dancer2;
use Dancer2::Plugin::Database;
#use Dancer2::Plugin::SessionDatabase;

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
#    _log_session(666, 'Hello!');

    my $letter = query_parameters->{letter};

    my $results = {};

    if ( $letter ) {
        my $table = 'nutrients';
        my $sql = qq/SELECT DISTINCT id, food FROM $table WHERE food LIKE "$letter%"/;
        my $sth = database($table)->prepare($sql);
        $sth->execute();
        $results = $sth->fetchall_hashref('food');
    }

    template 'index' => {
        page_title => 'Nutrients::DB',
        letter     => $letter,
        results    => $results,
    };
};

get '/food' => sub {
    my $id = query_parameters->{id};

    my $portions  = {};
    my $nutrients = {};
    my $food      = '';
    my $fgroup    = '';

    if ( $id ) {
        my $table = 'portions';
        my $sql = qq/SELECT * FROM $table WHERE id = ?/;
        my $sth = database($table)->prepare($sql);
        $sth->execute($id);
        $portions = $sth->fetchall_hashref('unit');

        $table = 'nutrients';
        $sql = qq/SELECT * FROM $table WHERE id = ?/;
        $sth = database($table)->prepare($sql);
        $sth->execute($id);
        $nutrients = $sth->fetchall_hashref('nutrient');

        for my $v ( values %$nutrients ) {
            $food   = $v->{food};
            $fgroup = $v->{fgroup};
            last;
        }
    }

    template 'food' => {
        page_title => 'Nutrients::DB',
        portions   => $portions,
        nutrients  => $nutrients,
        food       => $food,
        fgroup     => $fgroup,
    };
};

sub _log_session {
    my ($id, $data) = @_;
    my $tab = 'sessions';
    my $s = Dancer2::Session::DatabasePlugin->new(connection => $tab);
    my $sql = $s->create_flush_query();
    my $sth = database($tab)->prepare($sql);
    $sth->execute($id, $data);
}

true;

__END__

=head1 SEE ALSO

L<Dancer2>

=cut
