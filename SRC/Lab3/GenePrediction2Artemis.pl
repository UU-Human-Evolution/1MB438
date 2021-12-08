#!/usr/bin/perl -w
use Getopt::Long;

#perldoc documentation
=head1  NAME

	GenePrediction2Artemis.pl - conversion script for gene predictions.

=head1 PURPOSE

	GenePrediction2Artemis.pl converts the output file from getorf or GeneMark to a file that can be read in Artemis. Give input and output and either getorf or genemark.

=head1 USAGE

	GenePrediction2Artemis.pl -i|input gene_precition -o|output artemis_file [ -getorf -genemark ]

	-getorf for getorf output files

	-genemark for GeneMark output files

=cut

#script options
my $Genes 	= '';
my $ArtemisFile = '';
my $getorf= '';
my $genemark 	= '';

#type -i or -input File, getorf and genemark are only flags

GetOptions(
	'i|inout=s' 	=> \$Genes,
	'o|output=s' 	=> \$ArtemisFile,
	'getorf' 	=> \$getorf,
	'genemark' 	=> \$genemark,	
);

#display perldoc documentation if the options are wrong or program was run with no options
unless ( $Genes && $ArtemisFile && ( $getorf || $genemark ) ) {
	exec('perldoc',$0);
}

#open the necessary files
open my $GENES,   '<', $Genes 		or die "Could not open $Genes to read";
open my $ARTEMIS, '>', $ArtemisFile 	or die "Could not open $ArtemisFile to write";

#subroutine printing gene feature in artemis format
sub PrintGene {
	#read in variables strand, beginning, end, color and file handle to a file
	my ($s,$b,$e,$c,$fh) = @_;
	#the number of spaces between FT and CDS etc if crucial - if you change it Artemis will not read in the file!
	if ($s eq '+') 	{ print $fh "FT   CDS             " . $b . "\.\." . $e . "\n"; }
	else 		{ print $fh "FT   CDS             complement(" . $e . "\.\." . $b . ")\n"; }
	print $fh "FT                   \/color=\"$c\"\n";
}

#read the input line by line
while ( my $Line = <$GENES> ) {
	if ( $getorf ) {
		#use a reguler expression to read in the gene position
		#>Buchnera_1 [1 - 1893] aphidicola str. Sg (Schizaphis graminum), beginning
		if ( $Line =~ /\[(\d+) - (\d+)\]/ ) {
			my $beginning = $1, my $end = $2;
			#set the gene color to 5
			my $colour = 5;
			my $strand;
			#check which one is the beginning and the end and add/remove 3 bp
			if ( $beginning < $end )	{ $strand = '+'; $end += 3; }
			else 				{ $strand = '-'; $end -= 3; }
			PrintGene($strand,$beginning,$end,$colour,$ARTEMIS);
		}
	}
	elsif ( $genemark ) {
		#use a regular expression to read in the values for strand (+ or -), gene start (digits) and stop (digits), for example:
		#     2        +        2026        2844          819        1
		if ( $Line =~ /([+-])\s+(\d+)\s+(\d+)/ ) {
			my $strand = $1; my $beginning = $2; my $end = $3;
			#set the gene color to 6
			my $colour = 6;
			PrintGene($strand,$beginning,$end,$colour,$ARTEMIS);
		}
	}

}
close($GENES);
close($ARTEMIS);

