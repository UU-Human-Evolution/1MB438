#!/usr/bin/perl -w
use Getopt::Long;

#perldoc documentation
=head1  NAME

	PromoterPrediction2Artemis.pl - conversion script for prmoter predictions.

=head1 PURPOSE

	PromoterPrediction2Artemis.pl converts the output file from BRPOM or SAK to a file that can be read in Artemis. Give input and output and either bprom or sak, and optionally thresholds to be used.

=head1 USAGE

	PromoterPrediction2Artemis.pl -i|input promoter_prediction -o|output artemis_file [ -bprom -sak -l|ldf -s|score ]

	-bprom for BRPOM output files

	-sak for SAK output files

	-l|ldf threshold for ldf in bprom output

	-s|score threshold for score that can be used with both sak and bprom outputs

=cut

#script options
my $Promoters 	= '';
my $ArtemisFile = '';
my $bprom	= '';
my $sak 	= '';
my $ldf_threshold 	= 0;
my $score_threshold 	= 0;

#type -i or -input File, bprom and sak are only flags, through -l or -ldf and -s or -score you can give a floating point number to be used as threshold for printing features

GetOptions(
	'i|inout=s' 	=> \$Promoters,
	'o|output=s' 	=> \$ArtemisFile,
	'bprom' 	=> \$bprom,
	'sak' 		=> \$sak,
	'l|ldf=f' 	=> \$ldf_threshold,	
	's|score=f' 	=> \$score_threshold,
);

#display perldoc documentation if the options are wrong or program was run with no options
unless ( $Promoters && $ArtemisFile && ( $bprom || $sak ) ) {
	exec('perldoc',$0);
}

if ( $ldf_threshold && $sak ) {
	print "You can't use ldf with sak output! Read the documentation by running the script with no parameters.";
}

#open the necessary files
open my $PROM,   '<', $Promoters 	or die "Could not open $Promoters to read";
open my $ARTEMIS, '>', $ArtemisFile 	or die "Could not open $ArtemisFile to write";

#set the colors
my $prom_color = 4; my $prom_10_color = 3; my $prom_35_color = 2;
#read the input line by line
while ( my $Line = <$PROM> ) {
	if ( $bprom ) {
		#use a reguler expression to read in the promoter informtion from the 3 lines
		#Promoter Pos:   3421 LDF- 17.62
		#-10 box at pos.   3406 TTTTATAAT Score    86
		#-35 box at pos.   3385 TTTAAA    Score    41
		if ( $Line =~ /Promoter Pos:\s*(\d+)\s*LDF-\s*([\d|\.]+)/ ) {
			my $prom_pos = $1, my $current_ldf = $2;
			$Line = <$PROM>;
			my($start10,$score10) = $Line =~ m{-10 box at pos.\s*(\d+)\s*.+\s*Score\s*(-?\d+)};
			my $stop10 = $start10 + 9;
			$Line = <$PROM>;
			my($start35,$score35) = $Line =~ m{-35 box at pos.\s*(\d+)\s*.+\s*Score\s*(-?\d+)};
			my $stop35 = $start35 + 6;
			#print the feature if score/ldf larger than thresholds which are 0 by default
			if ( ($score10 + $score35 > $score_threshold) && ($current_ldf > $ldf_threshold) ) {
				print $ARTEMIS "FT   promoter        " . $prom_pos . "\.\." . $prom_pos . "\n";
				print $ARTEMIS "FT                   \/color=\"$prom_color\"\n";
				print $ARTEMIS "FT   -10_signal        " . $start10 . "\.\." . $stop10 . "\n";
				print $ARTEMIS "FT                     \/color=\"$prom_10_color\"\n";
				print $ARTEMIS "FT   -35_signal        " . $start35 . "\.\." . $stop35 . "\n";
				print $ARTEMIS "FT                     \/color=\"$prom_35_color\"\n";
			}
		}
	}
	elsif ( $sak ) {
		#use a regular expression to read in the values for strand (+ or -), gene start (digits) and stop (digits), for example:
		#65	0.0292479
		if ( $Line =~ /^(-?\d+)\s*(-?\d+\.?\d*)/ ) {
			my $prom_pos = $1, my $current_score = $2;
			if ( $current_score > $score_threshold ) {
				if ($prom_pos < 0) {
					$prom_pos = -$prom_pos;
					print $ARTEMIS "FT   promoter        complement(" . $prom_pos . ")\n";
					print $ARTEMIS "FT                   \/color=\"$prom_color\"\n";
				}
				else {
					print $ARTEMIS "FT   promoter        " . $prom_pos . "\n";
    					print $ARTEMIS "FT                   \/color=\"$prom_color\"\n";
				}
			}
		}
	}

}
close($PROM);
close($ARTEMIS);

