#!/usr/bin/perl

no warnings 'all';
use strict;

my $treefile = $ARGV[0];
my $nametable = $ARGV[1];
open my $IN, $nametable or die "Could not open name_table.txt: $!";

my %speciesname_of;
my @taxa;

while(<$IN>){
    my @col = split;
    $speciesname_of{$col[0]} = $col[1];
    push @taxa, $col[0];
}

close $IN;

open $IN, $treefile or die "Could not open $treefile: $!";

while(<$IN>){
    for my $taxon (@taxa){
        s/$taxon(,|\)|:)/$speciesname_of{$taxon}$1/;
    }
    print;
}


