#!/usr/bin/perl

# Author: Karl Gemayel
# Created: November 30, 2016
# 
# Some code edited by AL.
#
# Run the GeneMarkS-2 gene-finder.

use strict;
use warnings;

use Cwd 'abs_path';
use Getopt::Long;
use File::Basename;

my $VERSION = "1.14";

# get script name
my $scriptName = basename($0);

# get path of current script
my $scriptPath = abs_path($0);
$scriptPath =~ /^(.*)\//;
$scriptPath = $1;

my $trainer = "$scriptPath/biogem";             # training of parameters 
my $predictor = "$scriptPath/gmhmmp2";          # predicting genes
my $comparePrediction = "$scriptPath/compp";    # compare prediction files to check for convergence

$VERSION .= GetHMMVersion();

# ------------------------------ #
#      Modes for iterations      #
# ------------------------------ #
my $modeNoMotif = "no-motif";
my $modeGroupA  = "group-a";
my $modeGroupB  = "group-b";
my $modeGroupC  = "group-c";
my $modeGroupDStep1  = "group-d1";
my $modeGroupDStep2  = "group-d2";
my $modeGroupX  = "group-x";
my @validIterationModes = ($modeNoMotif, $modeGroupA, $modeGroupB, $modeGroupC, $modeGroupDStep1, $modeGroupDStep2, $modeGroupX);

# ------------------------------ #
#    Default Variable Values     #
# ------------------------------ # 
my $D_GENETIC_CODE                      = "auto"                            ;
my $D_FNOUTPUT                          = "gms2.lst"                        ;
my $D_FORMAT_OUTPUT                     = "lst"                             ;
my $D_MGMTYPE                           = "auto"                            ;
my $D_PROM_WIDTH_D                      = 12                                ;
my $D_PROM_WIDTH_C                      = 6                                 ;
my $D_RBS_WIDTH                         = 6                                 ;
my $D_PROM_UPSTR_LEN_D                  = 40                                ;
my $D_PROM_UPSTR_LEN_C                  = 20                                ;
my $D_RBS_UPSTR_LEN                     = 20                                ;
my $D_SPACER_SCORE_THRESH_D             = 0.1                               ;
my $D_SPACER_SCORE_THRESH_C             = 0.25                              ;
my $D_SPACER_DIST_THRESH                = 14                                ;
my $D_SPACER_WINDOW_SIZE                = 1                                 ;
my $D_16S                               = "TAAGGAGGTGA"                     ;
my $D_MIN_MATCH_16S                     = 4                                 ;
my $D_MIN_MATCH_RBS_PROM                = 3                                 ;
my $D_MIN_FRAC_RBS_16S_MATCH            = 0.5                               ;
my $D_UPSTR_SIG_LENGTH                  = 35                                ;
my $D_UPSTR_SIG_ORDER                   = 2                                 ;
my $D_MAX_ITER                          = 10                                ;
my $D_CONV_THRESH                       = 0.99                              ;
my $D_COD_ORDER                         = 5                                 ;
my $D_NONCOD_ORDER                      = 2                                 ;
my $D_START_CONTEXT_ORDER               = 2                                 ;
my $D_FGIO_DIST_THRESH                  = 25                                ;
my $D_AVERAGE_GENE_LENGTH               = 600                               ;

# ------------------------------ #
#    Command-line variables      #
# ------------------------------ # 
my $fn_genome                                                               ;       # Name of file containing genome sequence
my $genomeType                                                              ;       # Type of genome: Options: archaea, bacteria, auto
my $geneticCode                         = $D_GENETIC_CODE                   ;       # Genetic code
my $fnoutput                            = $D_FNOUTPUT                       ;       # Name of final output file
my $formatOutput                        = $D_FORMAT_OUTPUT                  ;       # Format for output file
my $fnAA                                                                    ;       # amino acid sequences
my $fnNN                                                                    ;       # nucleotide sequences
my $gid                                 = ''                                ;       # change gene id labeling to contig_id with id local to contig
my $ncbi                                = ''                                ;       # parse genetic code from definition line of FASTA file
my $species                             = "unspecified"                     ;       # save name of species in the model file in field $NAME

# Output

my $gid_start                           = 0                                 ;
my $gid_label                           = ''                                ;

# Group-D
my $groupD_widthPromoter                = $D_PROM_WIDTH_D                   ;
my $groupD_widthRBS                     = $D_RBS_WIDTH                      ;
my $groupD_promoterUpstreamLength       = $D_PROM_UPSTR_LEN_D               ;
my $groupD_rbsUpstreamLength            = $D_RBS_UPSTR_LEN                  ;
my $groupD_spacerScoreThresh            = $D_SPACER_SCORE_THRESH_D          ;
my $groupD_spacerDistThresh             = $D_SPACER_DIST_THRESH             ;
my $groupD_spacerWindowSize             = $D_SPACER_WINDOW_SIZE             ;

# Group-C
my $groupC_widthPromoter                = $D_PROM_WIDTH_C                   ;
my $groupC_widthRBS                     = $D_RBS_WIDTH                      ;
my $groupC_promoterUpstreamLength       = $D_PROM_UPSTR_LEN_C               ;
my $groupC_rbsUpstreamLength            = $D_RBS_UPSTR_LEN                  ;
my $groupC_spacerScoreThresh            = $D_SPACER_SCORE_THRESH_C          ;
my $groupC_spacerWindowSize             = $D_SPACER_WINDOW_SIZE             ;
my $groupC_spacerDistThresh             = $D_SPACER_DIST_THRESH             ;
my $groupC_tail16S                      = $D_16S                            ;
my $groupC_minMatchToTail               = $D_MIN_MATCH_16S                  ;

# Group-B
my $groupB_widthRBS                     = $D_RBS_WIDTH                      ;
my $groupB_rbsUpstreamLength            = $D_RBS_UPSTR_LEN                  ;
my $groupB_minMatchPromoterRBS          = $D_MIN_MATCH_RBS_PROM             ;
my $groupB_minMatchRBS16S               = $D_MIN_MATCH_16S                  ;

# Group-A
my $groupA_widthRBS                     = $D_RBS_WIDTH                      ;
my $groupA_rbsUpstreamLength            = $D_RBS_UPSTR_LEN                  ;
my $groupA_percentMatchRBS              = $D_MIN_FRAC_RBS_16S_MATCH         ;
my $groupA_minMatchRBS16S               = $D_MIN_MATCH_16S                  ;
my $groupA_tail16S                      = $D_16S                            ;

# Group-X
my $groupX_widthRBS                     = $D_RBS_WIDTH                      ;
my $groupX_rbsUpstreamLength            = $D_RBS_UPSTR_LEN                  ;
my $groupX_upstreamSignatureLength      = $D_UPSTR_SIG_LENGTH               ;
my $groupX_upstreamSignatureOrder       = $D_UPSTR_SIG_ORDER                ;
my $groupX_tail16S                      = $D_16S                            ;

# Iteration control
my $MAX_ITER                            = $D_MAX_ITER                       ;       # number of max iterations in main cycle
my $CONV_THRESH                         = $D_CONV_THRESH                    ;       # convergence threshold
my $numIterWithoutRBS                   = 1                                 ;

# Model Hyperparameters
my $orderCod                            = $D_COD_ORDER                      ;       # order for coding model
my $orderNon                            = $D_NONCOD_ORDER                   ;       # order for noncoding model
my $scOrder                             = $D_START_CONTEXT_ORDER            ;       # start context order
my $fgioDistThresh                      = $D_FGIO_DIST_THRESH               ;
#
# Misc Variables
my $toMgmProb                           = 0.15                              ;
my $toNativeProb                        = 0.85                              ;
my $fixedNativeAtypicalProb                                                 ;
my $trainNonCodingOnFullGenome                                              ;
my $minAtypicalProb                     = 0.02                              ;
my $runMFinderWithoutSpacer                                                 ;
my $showAdvancedOptions                                                     ;            
my $mgmType = $D_MGMTYPE                                                    ;       # Type of MGM model: options: "bac, arc, auto"
my $verbose                                                                 ;       # verbose mode
my $keepAllFiles                                                            ;
my $forceGroup                                                              ;
my $fn_external                                                             ;       # External evidence in GFF format

# Parse command-line options
GetOptions (
    'seq=s'                                 =>  \$fn_genome,
    'genome-type=s'                         =>  \$genomeType,
    'gcode=s'                               =>  \$geneticCode,
    'output=s'                              =>  \$fnoutput,
    'format=s'                              =>  \$formatOutput,
    'faa=s'                                 =>  \$fnAA,
    'fnn=s'                                 =>  \$fnNN,
    'ncbi'                                  =>  \$ncbi,
    'species=s'                             =>  \$species,
    # Output
    'gid'                                   =>  \$gid,
    'gid_start=i'                           =>  \$gid_start,
    'gid_label=s'                           =>  \$gid_label,
    # Group-D
    'group-d-width-promoter=i'              =>  \$groupD_widthPromoter,
    'group-d-width-rbs=i'                   =>  \$groupD_widthRBS,
    'group-d-promoter-upstream-length=i'    =>  \$groupD_promoterUpstreamLength,
    'group-d-rbs-upstream-length=i'         =>  \$groupD_rbsUpstreamLength,
    'group-d-spacer-score-thresh=f'         =>  \$groupD_spacerScoreThresh,
    'group-d-spacer-dist-thresh=i'          =>  \$groupD_spacerDistThresh,
    'group-d-spacer-window-size=i'          =>  \$groupD_spacerWindowSize,
    # Group-C
    'group-c-width-promoter=i'              =>  \$groupC_widthPromoter,
    'group-c-width-rbs=i'                   =>  \$groupC_widthRBS,
    'group-c-promoter-upstream-length=i'    =>  \$groupC_promoterUpstreamLength,
    'group-c-rbs-upstream-length=i'         =>  \$groupC_rbsUpstreamLength,
    'group-c-spacer-score-thresh=f'         =>  \$groupC_spacerScoreThresh,
    'group-c-spacer-window-size=i'          =>  \$groupC_spacerWindowSize,
    'group-c-tail-16s=s'                    =>  \$groupC_tail16S,
    'group-c-min-match-to-tail=i'           =>  \$groupC_minMatchToTail,
    # Group-B
    'group-b-width-rbs=i'                   =>  \$groupB_widthRBS,
    'group-b-rbs-upstream-length=i'         =>  \$groupB_rbsUpstreamLength,
    'group-b-min-match-promoter-rbs=i'      =>  \$groupB_minMatchPromoterRBS,
    # Group-A
    'group-a-width-rbs=i'                   =>  \$groupA_widthRBS,
    'group-a-rbs-upstream-length=i'         =>  \$groupA_rbsUpstreamLength,
    'group-a-percent-match-rbs=f'           =>  \$groupA_percentMatchRBS,
    # Group-X
    'group-x-width-rbs=i'                   =>  \$groupX_widthRBS,
    'group-x-rbs-upstream-length=i'         =>  \$groupX_rbsUpstreamLength,
    'group-x-upstream-signature-length=i'   =>  \$groupX_upstreamSignatureLength,
    'group-x-upstream-signature-order=i'    =>  \$groupX_upstreamSignatureOrder,
    'group-x-tail-16s=s'                    =>  \$groupX_tail16S,
    # Iteration control
    'max-iter=i'                            =>  \$MAX_ITER,
    'conv-thresh=f'                         =>  \$CONV_THRESH,
    # Model Hyperparameters: Orders
    'order-cod=i'                           =>  \$orderCod,
    'order-non=i'                           =>  \$orderNon,
    'order-sc=i'                            =>  \$scOrder,
    # Model Hyperparameters: lengths
    'fgio-dist-thresh=i'                    =>  \$fgioDistThresh,
    # Misc
    'fixed-native-atypical-prob'            =>  \$fixedNativeAtypicalProb,
    'train-noncoding-on-full-genome'        =>  \$trainNonCodingOnFullGenome,
    'min-atypical-prob=f'                   =>  \$minAtypicalProb,
    'run-mfinder-without-spacer'            =>  \$runMFinderWithoutSpacer,
    'v'                                     =>  \$verbose,
    'advanced-options'                      =>  \$showAdvancedOptions,
    'mgm-type=s'                            =>  \$mgmType,
    'keep-all-files'                        =>  \$keepAllFiles,
    'force-group=s'                         =>  \$forceGroup,
    'ext=s'                                 =>  \$fn_external,
);

Usage($scriptName) if (!defined $fn_genome or !defined $genomeType or !isValidGenomeType($genomeType));

# tests of data for NCBI specifc data formats
if ($ncbi)
{
	$geneticCode = GetGeneticCodeFromFile( $fn_genome);
}

# variable that's set if group B is tested and Promoter and RBS matched
my $testGroupC_PromoterMatchedRBS;

# setup temporary file collection
my @tempFiles;

# Determine genetic code
# In AUTO mode, set the gcode
# In user supplied mode, compare the gcode
$geneticCode = CheckSetGeneticCodeFromSequence( $fn_genome, $geneticCode );

# create "single fasta format" from multifasta file
my $fnseq = "tmpseq.fna";
MultiToSingleFASTA($fn_genome, $fnseq);

# add temporary files
push @tempFiles, ($fnseq) unless $keepAllFiles;

my $mgmMod = "$scriptPath/mgm_$geneticCode.mod";        # name of MGM mod file (based on genetic code)
my $modForFinalPred = "tmp.mod";                        # used to keep a version of the model at every iteration 

my $alignmentInMFinder = "right";
if (defined $runMFinderWithoutSpacer) {
    $alignmentInMFinder = "none";
}

my $testGroupD = ($genomeType eq "archaea"  or $genomeType eq "auto");
my $testGroupC = ($genomeType eq "bacteria" or $genomeType eq "auto");

my $testGroupDStep1 = $testGroupD;
my $testGroupDStep2 = $testGroupD;

#----------------------------------------
# Run initial MGM prediction
#----------------------------------------
my $mgmPred = CreatePredFileName("0");                               # create a prediction filename for iteration 0
#run("$scriptPath/gmhmmp2 -M $mgmMod -s $fnseq -o $mgmPred ");       # Run MGM
run("$predictor -M $mgmMod -s $fnseq -o $mgmPred ");                 # Run MGM

# add temporary files
push @tempFiles, ($mgmPred) unless $keepAllFiles;

# Compute probability of bacteria #bac/total; add probability to native mod file
my ($bacProb, $arcProb) = EstimateBacArc($mgmPred);

#----------------------------------------
# Main Cycle: Run X iterations 
#----------------------------------------
my $prevPred = $mgmPred;        # Previous iteration prediction: start with MGM predictions
my $prevMod = $mgmMod;          # Previous iteration model:      start with MGM model

# Run iterations without start motif model
my $iterBegin = 1;
my $iterEnd = $numIterWithoutRBS;
my $prevIter = RunIterations( { "mode" => $modeNoMotif, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );


if (defined $forceGroup) {
    my $forceMode;
    $forceMode = $modeGroupA if ($forceGroup eq "A");
    $forceMode = $modeGroupB if ($forceGroup eq "B");
    $forceMode = $modeGroupC if ($forceGroup eq "C");
    $forceMode = $modeGroupDStep1 if ($forceGroup eq "D");
    $forceMode = $modeGroupDStep2 if ($forceGroup eq "D2");
    $forceMode = $modeGroupX if ($forceGroup eq "X");

    ($iterBegin, $iterEnd) = GetBeginEndIterations($prevIter);
    
    $prevIter = RunIterations( { "mode" => $forceMode, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );
}
else {

    # Group D - step 1: If Group-D testing enabled, run single iteration to test for Group-D membership (step 1)
    if ($testGroupDStep1) {
        $iterBegin = $prevIter + 1;
        $iterEnd   = $iterBegin;            

        print "Testing Step-1 of Group-D membership...\n" if defined $verbose;
        
        $prevIter = RunIterations( { "mode" => $modeGroupDStep1, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );
    }

    if ($testGroupDStep1 and IsGroupD($prevIter)) {
        print "Group-D membership: successful (by step 1).\n" if defined $verbose;

        ($iterBegin, $iterEnd) = GetBeginEndIterations($prevIter);
        
        $prevIter = RunIterations( { "mode" => $modeGroupDStep1, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );
    }
    else {

        # If Group D (step-1) was tested, revert iteration count and move model file
        if ($testGroupDStep1) {
            print "Group-D membership: failed.\n" if defined $verbose;
            MoveFilesFromIteration($prevIter, "groupD1") if $keepAllFiles;                            # revert files of failed iteration
            $prevIter -= 1;                                                 # decrement iteration counter by 1
        }

        # Group D: if Group-D testing enabled, run single iteration to test for Group-D membership
        if ($testGroupDStep2) {
            $iterBegin = $prevIter + 1;
            $iterEnd   = $iterBegin;            

            print "Testing Step-2 of Group-D membership...\n" if defined $verbose;

            $prevIter = RunIterations( { "mode" => $modeGroupDStep2, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );
        }

        # Group-D: if membership satisfied, run remaining iterations until convergence
        if ($testGroupDStep2 and IsGroupD($prevIter)) {

            print "Group-D membership: successful (by step 2).\n" if defined $verbose;

            ($iterBegin, $iterEnd) = GetBeginEndIterations($prevIter);
            
            $prevIter = RunIterations( { "mode" => $modeGroupDStep2, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );
        }
        # Group D: If membership not satisfied, move on to group C
        else {
            # If Group D was tested, revert iteration count and move model file
            if ($testGroupDStep2) {
                print "Group-D membership: failed.\n" if defined $verbose;
                MoveFilesFromIteration($prevIter, "groupD2") if $keepAllFiles;                              # revert files of failed iteration
                $prevIter -= 1;                                                 # decrement iteration counter by 1
            }

            # Group C: single iteration to test for Group-D membership
            if ($testGroupC) {
                $iterBegin = $prevIter + 1;
                $iterEnd = $iterBegin;          
                $prevIter = RunIterations( { "mode" => $modeGroupC, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );
            }

            # Group-C: if membership satisfied, run remaining iterations until convergence
            if ($testGroupC and IsGroupC($prevIter)) {
                
                print "Group-C membership: successful.\n" if defined $verbose;

                ($iterBegin, $iterEnd) = GetBeginEndIterations($prevIter);

                $prevIter = RunIterations( { "mode" => $modeGroupC, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );
            }
            # Group C: If membership not satisfied, move on to group B
            else {

                MoveFilesFromIteration($prevIter, "groupC") if ($testGroupC and $keepAllFiles);
                MoveFilesFromIteration($prevIter, "groupD2") if ($testGroupDStep2 and !$testGroupC and $keepAllFiles);
                MoveFilesFromIteration($prevIter, "groupD1") if ($testGroupDStep1 and not !$testGroupDStep2 and !$testGroupC and $keepAllFiles);
                $prevIter -= 1;

                # Group B: single iteration to test for Group-B membership
                $iterBegin = $prevIter + 1;
                $iterEnd = $iterBegin;
                $prevIter = RunIterations( { "mode" => $modeGroupB, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );

                # Group-B: if membership satisfied, run remaining iterations until convergence
                if (IsGroupB($prevIter)) {

                    print "Group-B membership: successful.\n" if defined $verbose;

                    ($iterBegin, $iterEnd) = GetBeginEndIterations($prevIter);

                    $prevIter = RunIterations( { "mode" => $modeGroupB, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );
                }
                # Group B: If membership not satisfied, move on to group A
                else {

                    # go back one iteration (to cancel group B)
                    MoveFilesFromIteration($prevIter, "groupB") if $keepAllFiles;
                    $prevIter -= 1;
                    
                    # Group A: single iteration to test for Group-A membership
                    $iterBegin = $prevIter + 1;
                    $iterEnd = $iterBegin;
                    $prevIter = RunIterations( { "mode" => $modeGroupA, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd  } );
                    
                    # Group-A: if membership satisfied, run remaining iterations until convergence
                    if (IsGroupA($prevIter)) {
                        print "Group-A membership: successful.\n" if defined $verbose;

                        ($iterBegin, $iterEnd) = GetBeginEndIterations($prevIter);

                        $prevIter = RunIterations( { "mode" => $modeGroupA, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );
                    }
                    # Group A: If membership not satisfied, move on to group X
                    else {
                        # go back one iteration (to cancel group A)
                        MoveFilesFromIteration($prevIter, 'groupA') if $keepAllFiles;
                        $prevIter -= 1;

                        ($iterBegin, $iterEnd) = GetBeginEndIterations($prevIter);
                        $prevIter = RunIterations( { "mode" => $modeGroupX, "iteration-begin" => $iterBegin, "iteration-end" => $iterEnd } );
                    } 
                }
            }
        }
    }
}

$prevPred = CreatePredFileName($prevIter);       # Prediction file: get name of previous iteration
$prevMod  = CreateModFileName($prevIter);        # Model file: get name of previous iteration

#----------------------------------------
# Clean up and get scores
#----------------------------------------

my $finalPred = $fnoutput;
my $finalMod = "GMS2.mod";
my $finalMGM = $mgmMod;  
run("cp $prevMod $finalMod");

# add bacteria and archaea probability to modfile
AddToModel($finalMod, "TO_ATYPICAL_FIRST_BACTERIA", $bacProb);
AddToModel($finalMod, "TO_ATYPICAL_SECOND_ARCHAEA", $arcProb);

if (not $fixedNativeAtypicalProb) {
    ($toNativeProb, $toMgmProb) = EstimateNativeAtypical($prevPred);
}
# add mgm and native probabilities to modfile
AddToModel($finalMod, "TO_MGM", $toMgmProb);
AddToModel($finalMod, "TO_NATIVE", $toNativeProb);
# AddToModel($finalMod, "TO_NATIVE", 15);

# add version of GMS-2 to model file
AddToModel($finalMod, "BUILD", "GeneMarkS-2-". $VERSION);

# set species name
ReplaceInModel($finalMod, "NAME", $species);

# form prediction array
my @com_arr = ();

push @com_arr, $predictor;
push @com_arr, "-m";
push @com_arr, $finalMod;
push @com_arr, "-M";
push @com_arr, $finalMGM;
push @com_arr, "-s";
push @com_arr, $fn_genome;
push @com_arr, "-o";
push @com_arr, "$finalPred";
push @com_arr, "--format";
push @com_arr, $formatOutput;

push @com_arr, "--AA"               if defined $fnAA;
push @com_arr, $fnAA                if defined $fnAA;
push @com_arr, "--NT"               if defined $fnNN;
push @com_arr, $fnNN                if defined $fnNN;
push @com_arr, "--gid_per_contig"   if $gid;
push @com_arr, "--defline_parse"    if $ncbi;
push @com_arr, "-e"                 if $fn_external;
push @com_arr, $fn_external         if $fn_external;
push @com_arr, "--gid_start"        if $gid_start;
push @com_arr, $gid_start           if $gid_start;
push @com_arr, "--gid_label"        if $gid_label;
push @com_arr, $gid_label           if $gid_label;

run_arg( @com_arr );

#run("$predictor -m $finalMod -M $finalMGM -s $fn_genome -o $finalPred --format $formatOutput $extraOutput");

run ("rm -f @tempFiles");

#
sub CheckSetGeneticCodeFromSequence
{
	my $fname = shift;
	my $gcode = shift;

	my $gcode_predicted = 0;

	my $mod_11 = "$scriptPath/mgm_11.mod";
	my $mod_4  = "$scriptPath/mgm_4.mod";
	my $prediction_by_mod_11 = "tmp_mgm_11.gff";
	my $prediction_by_mod_4  = "tmp_mgm_4.gff";;

	run("$predictor -M $mod_11 -s $fname -o $prediction_by_mod_11 -f gff");
	push @tempFiles, ($prediction_by_mod_11) unless $keepAllFiles;
	my $average_gene_length = GetAverageGeneLength( $prediction_by_mod_11 );
	
	if( $average_gene_length > $D_AVERAGE_GENE_LENGTH )
	{
		$gcode_predicted = 11;
	}
	else
	{
		run("$predictor -M $mod_4 -s $fname -o $prediction_by_mod_4 -f gff");
		push @tempFiles, ($prediction_by_mod_4) unless $keepAllFiles;
		$average_gene_length = GetAverageGeneLength( $prediction_by_mod_4 );

		if( $average_gene_length > $D_AVERAGE_GENE_LENGTH )
		{
			$gcode_predicted = 4;
		}
		else
		{
			print "warning, genetic code test negative for 11 and 4\n";
		}
	}

	if ($gcode eq "auto")
	{
		if ($gcode_predicted)
		{
			$gcode = $gcode_predicted;
		}
		else
		{
			$gcode = 11;
			print "warning, defaulting to genetic code 11\n";
		}
	}
	else
	{
		if (( ($gcode == 11)or( $gcode==1)) and ($gcode_predicted == 11))
		{
			;
		}
		elsif (( ($gcode == 4)or( $gcode==25)) and ($gcode_predicted == 4))
		{
			;
		}
		elsif ( $gcode != $gcode_predicted )
		{
			print "warning, predicted genetic code differs from the specified: $gcode vs $gcode_predicted\n";
		}
	}

	print "# genetic code: $gcode\n" if $verbose;

	return $gcode;
}

sub GetAverageGeneLength
{
	my $fname = shift;

	my $sum_length = 0;
	my $count = 0;

	open( my $IN, $fname ) or die "error on open file $fname: !$\n";
	while(<$IN>)
	{
		next if /^#/;
		next if /^\s*$/;

		if ( /^[^\t]+\t\S+\t\S+\t(\d+)\t(\d+)\t/ )
		{
			$sum_length += $2 - $1 + 1;
			$count += 1;
		}
		else { die "error, 'GetAverageGeneLength' unexpected format found: $_"; }
	}
	close $IN;

	my $average_length = 0;
	if ( $count > 0 )
	{
		$average_length = sprintf( "%.0f", $sum_length/$count );
	}

	print "# average gene length: $average_length\n" if $verbose;

	return $average_length;
}

sub GetGeneticCodeFromFile
{
	my $fname = shift;

	my $genetic_code = 0;
	my %h;

	open( my $IN, $fname) or die"error on open file $fname: $!\n";
	while( my $line = <$IN> )
	{
		next if ( $line !~ /^\s*>/ );

		%h = $line =~ m/\[\s*(\S+)\s*=\s*(\S.*?)s*\]/g;

		if ( exists $h{ 'gcode' } )
		{
			if ( $genetic_code and ( $genetic_code ne $h{ 'gcode' } ))
			{
				die "error: different genetic codes are specified for the same input file: $genetic_code and $h{ 'gcode' }\n";
			}
			else
			{
				$genetic_code = $h{ 'gcode' };
			}
		}	
	}
	close $IN;

	die "error, genetic code information not found in defenition line: $_" if (!$genetic_code);

	return $genetic_code;
}

# Calculate number of iterations remaining (until we reach max number of allowed iterations)
sub NumOfIterRemaining {
    my ($prevIter, $maxIter) = @_;

    return $maxIter - $prevIter;
}

# Return true if the FGIO that don't match 16S have a localized signal located before the distance threshold
sub FGIONotMatching16SHaveSignalBeforeThresh {
    my ($prevIter, $distThresh, $scoreThresh, $windowSize) = @_;

    $prevPred = "itr_$prevIter.lst";
    $prevMod = "itr_$prevIter.mod";
    #my $isBacteriaProm = run("$trainer experiment promoter-is-valid-for-bacteria --fnmod $prevMod --dist-thresh $distThresh --score-thresh $scoreThresh");
    my $isBacteriaProm = run("$trainer experiment promoter-is-valid-for-bacteria --fnmod $prevMod --dist-thresh $distThresh --score-thresh $scoreThresh --window-size $windowSize --min-leaderless-percent 11 --min-leaderless-count 100 --fnlabels $prevPred --fnseq $fnseq");

    chomp $isBacteriaProm;
    return $isBacteriaProm eq "yes";
}

sub RBSSignalLocalized {
    my ($prevIter, $distThresh, $scoreThresh, $windowSize) = @_;

    my $fnmod = "itr_$prevIter.mod";

    my $rbsIsLocalized = run("$trainer experiment rbs-is-localized --fnmod $prevMod --dist-thresh $distThresh --score-thresh $scoreThresh --window-size $windowSize");
    chomp $rbsIsLocalized;

    return $rbsIsLocalized eq "yes";
}

# Return true if the FGIO have a localized motif signal located further than a distance threshold
sub FGIOHaveSignalAfterThresh {
    my ($prevIter, $distThresh, $scoreThresh, $windowSize) = @_;

    $prevMod = "itr_$prevIter.mod";
    #my $isArchaea = run("$trainer experiment promoter-is-valid-for-archaea --fnmod $prevMod --dist-thresh $distThresh");
    my $isArchaea = run("$trainer experiment promoter-is-valid-for-archaea --fnmod $prevMod --dist-thresh $distThresh --score-thresh $scoreThresh --window-size $windowSize");

    chomp $isArchaea;

    return $isArchaea eq "yes";
}

# Return true if the fraction of predicted RBS is greater than the threshold
sub PredictedRBSMatch16S {
    my ($fnpred, $seq16S, $minMatch) = @_;

    my $rbsMatchedOutput = run("$trainer experiment match-rbs-to-16s --fnlabels $fnpred --match-to $seq16S --min-match $minMatch --allow-ag-sub");

    my @matchInfo = split(' ', $rbsMatchedOutput);
    my $percentMatched = $matchInfo[1] / $matchInfo[0];

    # my $denom=system('cat $fnpred | grep -E "(native|atypical)[[:space:]]+[ACGT]+[[:space:]]+[[:digit:]]+[[:space:]]+1[[:space:]]*" | wc -l');
    # $percentMatched = $matchInfo[1] / $denom;

    print "Percent of matched RBS: $percentMatched\n" if defined $verbose;

    return $percentMatched >= $groupA_percentMatchRBS;
}

# Return true if the Promoter and RBS model consensus sequences match each other
sub PromoterAndRBSConsensusMatch {
    my ($prevIter, $minMatch) = @_;

    my $fnmod = "itr_$prevIter.mod";

    my $isGroupB = run("$trainer experiment promoter-and-rbs-match --fnmod $fnmod --match-thresh $minMatch");
    chomp $isGroupB;

    return $isGroupB eq "yes";
}

# Return true if the RBS model consensus matches the 16S tail
sub RBSConsensusAnd16SMatch {
    my ($prevIter, $minMatch) = @_;

    my $fnmod = "itr_$prevIter.mod";

    my $isMatched = run("$trainer experiment rbs-consensus-and-16s-match --fnmod $fnmod --allow-ag-sub");
    chomp $isMatched;

    return $isMatched eq "yes";
}

# Run GMS2 iterations in a particular mode
sub RunIterations {
    my %params = %{ $_[0] };

    my $mode        = $params{"mode"};
    my $iterBegin   = $params{"iteration-begin"};
    my $iterEnd     = $params{"iteration-end"};

    my $iter = $iterBegin;

    if ($iter <= 0) {
        print "Cannot run training for iteration <= 0.";
        return;
    }

    while ($iter <= $iterEnd) {

        print "Mode $mode: Entering iteration $iter...\n" if defined $verbose;

        # train on native genes
        my $nativeOnly = 0;
        if ($iter > 1) {
            $nativeOnly = 1;
        }

        my $currMod  = CreateModFileName($iter);        # model file for current iteration
        my $currPred = CreatePredFileName($iter);       # prediction file for current iteration
        my $prevPred = CreatePredFileName($iter-1);

        # Training step: use prediction of previous iteration
        my $trainingCommand = GetTrainingCommand($iter, $mode);          # construct training command
        run("$trainingCommand");                                         # run training command

        # add bacteria and archaea probability to model file
        AddToModel($currMod, "TO_ATYPICAL_FIRST_BACTERIA", $bacProb);
        AddToModel($currMod, "TO_ATYPICAL_SECOND_ARCHAEA", $arcProb);

        if (not $fixedNativeAtypicalProb and $iter > 1) {
            ($toNativeProb, $toMgmProb) = EstimateNativeAtypical($prevPred);
        }
        # add mgm and native probabilities to modfile
        AddToModel($currMod, "TO_MGM", $toMgmProb);
        AddToModel($currMod, "TO_NATIVE", $toNativeProb);

        # Prediction step: using current model file
        my $errCode = run("$predictor -m $currMod -M $mgmMod -s $fnseq -o $currPred --format train");

        # Check for convergence
        my $similarity = run("$comparePrediction -n -a $prevPred -b $currPred -G");

        print "Iteration : $similarity\n" if defined $verbose;


        # add temporary files
        push @tempFiles, ($currMod, $currPred) unless $keepAllFiles;
        

        if ( ($similarity > 99 && $iter > 2) ) {
            print "Converged at iteration $iter\n" if defined $verbose;
            return $iter;
        }

        # set previous prediction (before exiting loop)
        $prevPred = $currPred;
        $prevMod = $currMod;


        $iter++;
    }

    return $iter-1;
}

# Run a system command and log it
sub run {
    my $command = shift;
    open(FILE, ">>log");
    print FILE $command . "\n";
    my $value = `$command`;
    chomp($value);
    return $value;
}

sub run_arg
{
	my @arg_arr = @_;

	open(FILE, ">>log");
	foreach my $value (@arg_arr)
	{
		print FILE  ($value ."\t");
	}
	print FILE "\n";

	my $return_value = system(@arg_arr);

	return $return_value;
}

# Estimate bacteria and archaea probabilities based on the counts in the prediction file
sub EstimateBacArc {
    my $fname = shift;
    my $counts_all = 0;
    my $counts_bac = 0;
    my $c_all = 0;
    my $c_bac = 0;

    my $min_gene_length_bac_arc = 600;

    open( my $IN , $fname ) or die "error on open file $fname: $!\n";
    while( my $line = <$IN>)
    {
        next if ( $line =~ /^\s*$/ );
        next if ( $line =~ /^#/ );
        next if ( $line =~ /SequenceID:/ );

        if ( $line =~ /^\s*\d+\s+[+-]\s+\S+\s+\S+\s+(\d+)\s+bac\s*/ )
        {
            if ( $1 >= $min_gene_length_bac_arc )
            {
                ++$counts_bac;
                ++$counts_all;
            }

            $c_all += 1;
            $c_bac += 1;	
        }
        elsif ( $line =~ /^\s*\d+\s+[+-]\s+\S+\s+\S+\s+(\d+)\s+arc\s*/ )
        {
            if ( $1 >= $min_gene_length_bac_arc )
            {
                ++$counts_all;
            }

            $c_all += 1;
        }
        else {die;}
    }
    close $IN;

    if ( !$c_all ) { print "error, no genes predicted in file: $fname\n"; exit 1; }

    if ( $counts_all < 10 )
    {
       print "warning, majority of genes in $fname are below $min_gene_length_bac_arc\n";
       $counts_all = $c_all;
       $counts_bac = $c_bac;
    }

    # pseudocounts
    $counts_all += 2;
    $counts_bac += 1;

    if (defined $verbose) {
        my $counts_arc = $counts_all - $counts_bac;
        my $bacProb = $counts_bac / $counts_all;
        my $arcProb = $counts_arc / $counts_all;
        print "NumBac = $counts_bac\n";
        print "NumArc = $counts_arc\n";
        print "Bacteria Probability: $bacProb\n";
        print "Archaea Probability: $arcProb\n";
    }

    return ( sprintf( "%.5f", $counts_bac/$counts_all ), sprintf( "%.5f", ($counts_all - $counts_bac)/$counts_all ) );
}

# Esitmate native and atypical probabilities based on the counts in the prediction file
sub EstimateNativeAtypical {
    my $fname = shift;
    my $counts_all = 0;
    my $counts_native = 0;
    my $c_all = 0;
    my $c_native = 0;

    my $min_gene_length_native_atypical = 600;

    open( my $IN , $fname ) or die "error on open file $fname: $!\n";
    while( my $line = <$IN>)
    {
        next if ( $line =~ /^\s*$/ );
        next if ( $line =~ /^#/ );
        next if ( $line =~ /SequenceID:/ );

        my $currLength = -1;
        if ( $line =~ /^\s*\d+\s+[+-]\s+\d+\s+\d+\s+(\d+)\s*/ ) {
            $currLength = $1;
        }

        # if ( $line =~ /^\s*\d+\s+[+-]\s+\d+\s+\d+\s+(\d+)\s+(\S+)\s+(\S+)\s+(\d+)\s+native\s*/ )
        if ( $line =~ /\s+native\s*$/ ) 
        {
            if ( $currLength >= $min_gene_length_native_atypical )
            {
                ++$counts_native;
                ++$counts_all;
            }

            $c_all += 1;
            $c_native += 1;
        }
        #elsif ( $line =~ /^\s*\d+\s+[+-]\s+\d+\s+\d+\s+(\d+)\s+(\S+)\s+(\S+)\s+(\d+)\s+atypical\s*/ )
        elsif ( $line =~ /\s+atypical\s*$/ ) 
        {
            if ( $currLength >= $min_gene_length_native_atypical )
            {
                ++$counts_all;
            }

            $c_all += 1;
        }
        #else {die;}
    }
    close $IN;

    if (!$c_all)  { print "error, no genes predicted in file: $fname\n"; exit 1; }

    if ( $counts_all < 10 )
    {
       print "warning, majority of genes in $fname are below $min_gene_length_native_atypical\n";
       $counts_all = $c_all;
       $counts_native = $c_native;
    }

    # pseudocounts
    $counts_all += 2;
    $counts_native += 1;

    if (defined $verbose) {
        my $counts_atypical = $counts_all - $counts_native;
        my $nativeProb = $counts_native / $counts_all;
        my $atypicalProb = $counts_atypical / $counts_all;
        print "NumNative = $counts_native\n";
        print "NumAtypical = $counts_atypical\n";
        print "Native Probability: $nativeProb\n";
        print "Atypical Probability: $atypicalProb\n";
    }

    my $probNative = $counts_native/$counts_all;
    my $probAtypical = ($counts_all - $counts_native)/$counts_all;
    if ($probAtypical < $minAtypicalProb) {
        $probAtypical = $minAtypicalProb;
        $probNative = 1 - $probAtypical;
    }

    return ( sprintf( "%.5f", $probNative ), sprintf( "%.5f", $probAtypical) );
}

# Converts a multifasta file to single fasta by concatenating all sequences into one
sub MultiToSingleFASTA {
    # input and output filenames
    my ($fnin, $fnout) = @_;
    
    run ("echo '>anydef' > $fnout");
    run ("grep -v '>' $fnin | tr '[:lower:]' '[:upper:]' >> $fnout");
    return;
}

# Replace value in model file for a key
sub ReplaceInModel
{
   my ( $fname, $label, $value ) = @_;

   my $file_content = '';

   open (my $IN, $fname) or die "Error: Could not open file $fname\n";
   while( <$IN> )
   {
      if ( /\$$label\s+\S+\s*/ )
      {       
         $file_content .= ( "\$$label $value\n" );
      }
      else
      {
         $file_content .= $_
      }
   }
   close $IN;

   open (my $OUT, ">", $fname) or die "Error: Could not open file $fname\n";
   print $OUT $file_content;
   close $OUT;
}

# Add label/value pair to a model file
sub AddToModel {
    my ( $fname, $label, $value ) = @_;
    open (my $fout, ">>", $fname) or die "Error: Could not open file $fname\n";

    print $fout "\$" . $label . " $value\n";
    close $fout;
}

# Create name for model file based on iteration number
sub CreateModFileName {
    my $iter = $_[0];
    return "itr_$iter.mod";
}

# Create name for prediction file based on iteration number
sub CreatePredFileName {
    my $iter = $_[0];
    return "itr_$iter.lst";
}

# Create name for Motif Finder Output file based on iteration number
sub CreateMFinderResultFileName {
    my $iter = $_[0];
    return "itr_$iter.mfinderresult";
}

# Returns true if the genome type is valid: archaea, bacteria, auto
sub isValidGenomeType {
    my $gt = $_[0];
    return ($gt eq "archaea" or $gt eq "bacteria" or $gt eq "auto");
}

##############################
#                            #
#   Group Membership Tests   #
#                            #
##############################

sub IsGroupD {
    my $iter = $_[0];

    my $testResult = FGIOHaveSignalAfterThresh($iter, $groupD_spacerDistThresh, $groupD_spacerScoreThresh, $groupD_spacerWindowSize);

    return $testResult;
}

sub IsGroupC {
    my $iter = $_[0];

    my $test1 = FGIONotMatching16SHaveSignalBeforeThresh($iter, $groupC_spacerDistThresh, $groupC_spacerScoreThresh, $groupC_spacerWindowSize);
    my $test2 = PromoterAndRBSConsensusMatch($iter, $groupB_minMatchPromoterRBS);

    $testGroupC_PromoterMatchedRBS = $test2;

    if ($test1 and not $test2) {
        return 1;
    }
    else {
        return undef;
    }
}

sub IsGroupB {
    my $iter = $_[0];

    my $test = RBSConsensusAnd16SMatch($iter, $groupB_minMatchRBS16S);

    if (!$test) {

        if (RBSSignalLocalized($iter, 14, 0.15, 1)) {
            return 1;
        }
        return 0;
        # return 1;

        if ($testGroupC) {
            
            if ($testGroupC_PromoterMatchedRBS) {
                return 1;
            }
            else {
                return undef;
            }
        }
        # if group C wasn't tested for
        else {
            return 1;
        }
    }
    else {
        return undef;
    }
}

sub IsGroupA {
    my $iter = $_[0];

    my $fnpred = CreatePredFileName($iter);

    my $test = PredictedRBSMatch16S($fnpred, $groupA_tail16S, $groupA_minMatchRBS16S);

    return $test;

}

##############################
#                            #
#   Auxilliary Functions     #
#                            #
##############################

sub GetTrainingCommand {
    my ($currIter, $mode) = @_;

    if ($currIter == 0) {
        print "Cannot construct training model at iteration 0";
        return undef;
    }

    my $prevIter = $currIter - 1;

    my $currMod  = CreateModFileName($currIter);        # model file for current iteration
    my $prevPred = CreatePredFileName($prevIter);       # prediction file of previous iteration

    # train on native genes
    my $nativeOnly = 0;
    if ($currIter > 1) {
        $nativeOnly = 1;
    }
    
    # Training step: use prediction of previous iteration
    my $trainingCommand = "$trainer gms2-training -s $fnseq -l $prevPred -m $currMod --order-coding $orderCod --order-noncoding $orderNon --only-train-on-native $nativeOnly --genetic-code $geneticCode --order-start-context $scOrder --fgio-dist-thr $fgioDistThresh";

    #$trainingCommand .= " --len-start-context 18 --margin-start-context -15 ";

    if ($mode eq $modeNoMotif) {
        $trainingCommand .= " --run-motif-search false";
        $trainingCommand .= " --genome-group D";        # FIXME: remove requirement from training
    }
    elsif ($mode eq $modeGroupDStep1) {
        $trainingCommand .= " --genome-group D --gd-upstr-len-rbs $groupD_rbsUpstreamLength --align $alignmentInMFinder --gd-width-rbs $groupD_widthRBS --gd-upstr-len-prom $groupD_promoterUpstreamLength --gd-width-prom $groupD_widthPromoter";            
    }
    elsif ($mode eq $modeGroupDStep2) {
        $trainingCommand .= " --genome-group D2 --gd-upstr-len-rbs $groupD_rbsUpstreamLength --align $alignmentInMFinder --gd-width-rbs $groupD_widthRBS --gd-upstr-len-prom $groupD_promoterUpstreamLength --gd-width-prom $groupD_widthPromoter --gd-extended-sd $groupC_tail16S";            
    }
    elsif ($mode eq $modeGroupC) {
        $trainingCommand .= " --genome-group C --gc-upstr-len-rbs $groupC_rbsUpstreamLength --align $alignmentInMFinder --gc-width-rbs $groupC_widthRBS --gc-upstr-len-prom $groupC_promoterUpstreamLength --gc-width-prom $groupC_widthPromoter --gc-extended-sd $groupC_tail16S";
    }
    elsif ($mode eq $modeGroupB) {
        $trainingCommand .= " --genome-group B --gb-upstr-len-rbs $groupB_rbsUpstreamLength --align $alignmentInMFinder --gb-width-rbs $groupB_widthRBS"; #  --gc-upstr-reg-3-prime 3";  # 
        # $trainingCommand .= " --genome-group C2 --align $alignmentInMFinder ";  # --gc-upstr-reg-3-prime 3
    }
    elsif ($mode eq $modeGroupA) {
        $trainingCommand .= " --genome-group A --ga-upstr-len-rbs $groupA_rbsUpstreamLength --align $alignmentInMFinder --ga-width-rbs $groupA_widthRBS";
    }
    elsif ($mode eq $modeGroupX) {
        $trainingCommand .= " --genome-group X --gx-upstr-len-rbs $groupX_rbsUpstreamLength --align $alignmentInMFinder --gx-width-rbs $groupX_widthRBS --gx-len-upstr-sig $groupX_upstreamSignatureLength --gx-order-upstr-sig $groupX_upstreamSignatureOrder --gx-extended-sd $groupX_tail16S";
    }
    else {
        die "Mode invalid: should not reach this point";
    }

    return $trainingCommand;
}

sub MoveFilesFromIteration {
    my $iter = $_[0];
    my $name = $_[1];

    my $fnmod  = CreateModFileName  ($iter);
    my $fnpred = CreatePredFileName ($iter);

    print "Move files from iteration $iter to name '$name'\n" if defined $verbose;

    run("mv $fnmod  $name.mod");
    run("mv $fnpred $name.lst");
}

sub GetBeginEndIterations {
    my ($prevIter) = @_;

    my $numIterRemain = NumOfIterRemaining($prevIter, $MAX_ITER);

    $iterBegin = $prevIter + 1;
    $iterEnd = $iterBegin + $numIterRemain - 1;

    return ($iterBegin, $iterEnd);
}

# FIXME: fnn, faa, check gcode 11,4, keep-all-files

sub GetHMMVersion
{
	my $hmm_version = "";
	my $hmm_usage = `$predictor 2>&1`;

	if (defined $hmm_usage)
	{
		if ( $hmm_usage  =~ /version *(\S+)/ )
		{
			$hmm_version = "_". $1;
		}
	}

	return $hmm_version;
}

# Usage function: print usage message and exit script
sub Usage {
    my $name = $_[0];
    print "Usage: $name --seq SEQ --genome-type TYPE";
    print
"
Basic Options: 
--seq                                   File containing genome sequence in FASTA format
--genome-type                           Type of genome: archaea, bacteria, auto (default: $geneticCode)
--gcode                                 Genetic code (default: $D_GENETIC_CODE. Supported: 11, 4, 25 and 15)
--output                                Name of output file (default: $D_FNOUTPUT)
--format                                Format of output file (default: $D_FORMAT_OUTPUT)
--ext                                   Name of file with external information in GFF format (PLUS mode of GMS2)
--fnn                                   Name of output file that will hold nucleotide sequences of predicted genes
--faa                                   Name of output file that will hold protein sequences of predicted genes
--gid                                   Change gene ID format
--species                               Name of the species to use inside the model file (default: $species)
--advanced-options                      Show the advanced options

Version: $VERSION
";

    if (defined $showAdvancedOptions) {
        print 
"
Advanced Options:
# Output
--gid_start  [intiger]                  Start gene ID with this number
--gid_label  [string]                   Add this label as prefix to gene IDs in definition line of FASTA files

# Iteration control
--max-iter                              Number of max iterations in the main cycle (default: $D_MAX_ITER)
--conv-thresh                           The convergence threshold (in range [0,1]) (default: $D_CONV_THRESH)

# Misc
fixed-native-atypical-prob              Fix the native and atypical prior probabilities
train-noncoding-on-full-genome          Train the non-coding model on the full genome
min-atypical-prob                       Set minimum prior probability for atypical genes
run-mfinder-without-spacer              Disable the \"location distribution\" in the motif finders
mgm-type                                Type of genome model to use for MGM predictions
                                        Option: bac, arc, auto. Default: (default: $D_MGMTYPE)
keep-all-files                          Keep all intermediary files 
fgio-dist-thresh                        Distance threshold for FGIO identification

# Group-D
group-d-width-promoter                  Width of the promoter motif model (default: $D_PROM_WIDTH_D)
group-d-width-rbs                       Width of the rbs motif model (default: $D_RBS_WIDTH)
group-d-promoter-upstream-length        Upstream length for promoter training (default: $D_PROM_UPSTR_LEN_D)
group-d-rbs-upstream-length             Upstream length for rbs training (default: $D_RBS_UPSTR_LEN)
group-d-spacer-score-thresh             Minimum peak threshold for the spacer distribution (default: $D_SPACER_SCORE_THRESH_D)
group-d-spacer-dist-thresh              Minimum distance threshold for the spacer distribution (default: $D_SPACER_DIST_THRESH)
group-d-spacer-window-size              Window size for calculating the \"peak value\" to compare
                                        against the score threshold. (default: $D_SPACER_WINDOW_SIZE)
# Group-C
group-c-width-promoter                  Width of the promoter motif model (default: $D_PROM_WIDTH_C)
group-c-width-rbs                       Width of the rbs motif model (default: $D_RBS_WIDTH)
group-c-promoter-upstream-length        Upstream length for promoter training (default: $D_PROM_UPSTR_LEN_C)
group-c-rbs-upstream-length             Upstream length for rbs training (default: $D_RBS_UPSTR_LEN)
group-c-spacer-score-thresh             Minimum peak threshold for the spacer distribution (default: $D_SPACER_SCORE_THRESH_C)
group-c-spacer-window-size              Window size for calculating the \"peak value\" to compare
                                        against the score threshold (default: $D_SPACER_WINDOW_SIZE)
group-c-tail-16s                        The 16S rRNA tail used for selecting training sequences for
                                        the promoter model (default: $D_16S)
group-c-min-match-to-tail               Minimum number of consecutive nucleotide matches to the 16S (default: $D_MIN_MATCH_16S)

# Group-B
group-b-width-rbs                       Width of the rbs motif model (default: $D_RBS_WIDTH)
group-b-rbs-upstream-length             Upstream length for rbs training (default: $D_RBS_UPSTR_LEN)
group-b-min-match-promoter-rbs          Minimum number of consecutive nucleotide matches between the 
                                        promoter and RBS (default: $D_MIN_MATCH_RBS_PROM)

# Group-A
group-a-width-rbs                       Width of the rbs motif model (default: $D_RBS_WIDTH)
group-a-rbs-upstream-length             Upstream length for rbs training (default: $D_RBS_UPSTR_LEN)
group-a-percent-match-rbs               Minimum percentage of predicted RBS sequences that match to 16S (default: $D_MIN_FRAC_RBS_16S_MATCH)

# Group-X
group-x-width-rbs                       Width of the rbs motif model (default: $D_RBS_WIDTH)
group-x-rbs-upstream-length             Upstream length for rbs training (default: $D_RBS_UPSTR_LEN)
group-x-upstream-signature-length       Length of the upstream-signature Nonuniform Markov model (default: $D_UPSTR_SIG_LENGTH)
group-x-upstream-signature-order        Order of the upstream-signature Nonuniform Markov model (default: $D_UPSTR_SIG_ORDER)
group-x-tail-16s                        The 16S rRNA tail used for selecting training sequences for
                                        the RBS model (default: $D_16S)
";
    }

    exit;
}

