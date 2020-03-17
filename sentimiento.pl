use JSON;
#use strict;
#use warnings;
use Data::Dumper; 
use LWP::UserAgent;
use HTTP::Request;


my $texto = "lo que pasa en el pais, es que el gobierno no esta cumpliendo con lo que se comprometio estoy desacuerdo con lo que esta pasando";

my $url = 'https://api.meaningcloud.com/sentiment-2.1';
my $query = 'key=03251e2ff7438ac2c5d99409f5648180&lang=es&txt='.$texto.'&model=general';




my $ua = LWP::UserAgent->new;

my $req = HTTP::Request->new(POST => $url);

$req->content_type('application/x-www-form-urlencoded');
$req->content($query);

my $response = $ua->request($req);
my $content = $response->content(); #contenido de la respuesta

print "Content-type: text/html\n\n";
#print $content;
my $perl_scalar = JSON->new->utf8->decode($content);
printf("Opinion : %s\n",$perl_scalar->{agreement});
printf("Porcentaje Certeza : %s \n",$perl_scalar->{confidence});


#print  Dumper($perl_scalar);

#print Dumper($r);