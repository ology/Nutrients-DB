Nutrients-DB
============

Alphabetical web interface into the classic USDA nutrition database

To use this, first unzip the nutrients.sqlite.zip file.

You will need a webserver installed, so I recommend doing this:

  > sudo cpan Plack

Then run the psgi app with a webserver like this:

  > plackup bin/app.psgi
