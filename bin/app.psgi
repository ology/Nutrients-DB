#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use Nutrients::DB;

Nutrients::DB->to_app;

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use Nutrients::DB;
use Plack::Builder;

builder {
    enable 'Deflater';
    Nutrients::DB->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to mount several applications on different path

use Nutrients::DB;
use Nutrients::DB_admin;

use Plack::Builder;

builder {
    mount '/'      => Nutrients::DB->to_app;
    mount '/admin'      => Nutrients::DB_admin->to_app;
}

=end comment

=cut

