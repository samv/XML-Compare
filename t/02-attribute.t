#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 8;
use XML::Compare;

# $XML::Compare::VERBOSE = 1;

my $same = [
   {
       name => 'Some Attributes',
       xml1 => '<foo foo="bar" baz="buz"></foo>',
       xml2 => '<foo baz="buz" foo="bar"></foo>',
   },
   {
       name => "Same attributes (default namespace doesn't apply)",
       xml1 => '<foo xmlns="uri:a"><e foo="bar" /></foo>',
       xml2 => '<a:foo xmlns:a="uri:a"><a:e foo="bar" /></a:foo>',
   },
   {
       name => 'Same attributes, namespace and no namespace',
       xml1 => '<foo xmlns:a="uri:a"><e a:foo="bar" foo="buz" /></foo>',
       xml2 => '<foo xmlns:a="uri:a"><e a:foo="bar" foo="buz" /></foo>',
   },
   {
       name => 'Attributes with namespaces',
       xml1 => '<foo xmlns:a="uri:a" xmlns:b="uri:b"><e a:foo="bar" b:baz="buz" /></foo>',
       xml2 => '<foo xmlns:cat="uri:a" xmlns:dog="uri:b"><e cat:foo="bar" dog:baz="buz" /></foo>',
   },
   {
       name => 'Same localname, different with namespaces',
       xml1 => '<foo xmlns:a="uri:a" xmlns:b="uri:b"><e a:foo="bar" b:foo="buz" /></foo>',
       xml2 => '<foo xmlns:cat="uri:a" xmlns:dog="uri:b"><e cat:foo="bar" dog:foo="buz" /></foo>',
   },
   {
       name => 'Same attributes (using different namespaces)',
       xml1 => '<foo xmlns:a="uri:a"><e a:foo="bar" /></foo>',
       xml2 => '<foo xmlns:b="uri:a"><e b:foo="bar" /></foo>',
   },
];

my $diff = [
   {
       name => 'Different attributes',
       xml1 => '<foo bar="baz" />',
       xml2 => '<foo baz="buz" />',
   },
   {
       name => 'Same attributes, different namespaces',
       xml1 => '<foo xmlns:a="uri:a"><e a:foo="bar" /></foo>',
       xml2 => '<foo xmlns:a="uri:b"><e a:foo="bar" /></foo>',
   },
];

foreach my $t ( @$same ) {
    ok( XML::Compare::is_same($t->{xml1}, $t->{xml2}), $t->{name} );
}

foreach my $t ( @$diff ) {
    ok( XML::Compare::is_different($t->{xml1}, $t->{xml2}), $t->{name} );
}
