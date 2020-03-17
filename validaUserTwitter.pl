#!/usr/bin/env perl
use 5.14.1;
use warnings;
use utf8;
use open qw/:std :utf8/;

use Twitter::API;

my $client = Twitter::API->new_with_traits(
    traits => [ qw/ApiMethods/ ],
    consumer_key        => "51GtjuDVFbGgpLKbppH4M8Uv4",
    consumer_secret     => "V67ug41vUT5vRTOT7eCrIl8fsvcIB46IGoYOt5YQ71y0ANGHPg",
    access_token        => "30951060-DNMk0Fjrgf7XoTw956gpgwtHO04rRyuI1VMkJfWHF",
    access_token_secret => "iwimJbbp1DEuZ8QbiJE0z3Sbsf0xH7JptFrxMWpq7Xzra",
);

my $r = $client->verify_credentials;
say "$$r{screen_name} is authorized";

my $mentions = $client->mentions;
for my $status ( @$mentions ) {
    say $$status{text};
}
