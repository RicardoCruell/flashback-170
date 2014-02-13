#!/usr/bin/env perl

use strict;
use warnings;

use DBI;
use CGI;
use CGI::Cookie;

my $cgi = CGI->new;

my $email = $cgi->param('email');
my $password = $cgi->param('password');

my $db_location = "./db/fb.sqlite";

my $dbh = DBI->connect("dbi:SQLite:dbname=".$db_location, 
                        undef, 
                        undef, 
                        { sqlite_unicode => 1});

my $statement = $dbh->prepare("SELECT rowid, email, password 
                                FROM users 
                                WHERE email = ? AND password = ?");
$statement->execute(($email,$password));

my @results = $statement->fetchrow_array;

if ((scalar @results) == 0) {
    print  $cgi->redirect('./login-error.html');    
}
else {
    my $userid = $results[0];
    my $cookie = $cgi->cookie(-name=>'user_id',-value=>$userid);
    print  $cgi->redirect(-uri => './your-brain.html', -cookie=>$cookie);    

}
