#!/usr/bin/perl
use strict;
no warnings 'all';

BEGIN {
    if ( $^O ne 'linux' ) {
        say STDERR "You're not running this under linux";
        say STDERR "This means that I can't guarantee that it works";
    }
}

use feature ':5.10';
my $_;    # Simplifies things

use Storable;
use autodie;
use Bio::DB::EUtilities;
use Bio::SeqIO;

my @files = grep { -f } @ARGV;

our $ERR       = '';
our $VERBOSE   = '';
our $OK_ERRORS = 1;
our %WARN;

my ( @fasta, @conv );
for (@files) {
    when ( \&is_fasta )      { push @fasta, $_ }
    when ( \&is_conversion ) { push @conv,  $_ }
    default                  { say "UNKOWN FILE: $_" };
}

if ( @fasta != 2 || @conv == 0 ) {
    say "ERROR: need 2 fasta files and 1 or 2 conversion files";
    say "Usage:";
    say "    $0 <files>";
    say "\nThe order of the files do not matter";
    say "Examples:";
    say "    $0 16s.fasta cytb.fasta all.conversion";
    say "    $0 cytb.fasta 16s.conversion cytb.conversion 16s.fasta";
    exit 1;
}

my %conversion = map { parse_conversion($_) } @conv;
my %sequences;
for (@fasta) {
    my %new_seqs = check_fasta( $_, \%conversion );
    @sequences{ keys %new_seqs } = values %new_seqs;
}

check_gis( \%conversion, \%sequences );

if ($ERR) {
    say "\nThere were $ERR errors";
    say "\nYou have to fix the above errors.";
    exit(1);
}
else {
    say "Correct";
}

# The aim of this method is to check that the given gi numbers point to a
# sequence at NCBI and that that sequence is the same as in the fasta file.
sub check_gis {
    my $conv = shift;
    my $seqs = shift;

    for my $name ( keys %$conv ) {
        next unless exists $conv->{$name}{gi};
        my ( $line, $file ) = @{ $conv->{$name} }{qw/ line file /};

        my ( $full, $gi, $pos, $start, $stop )
          = $conv->{$name}{gi}
          =~ /^ (?:gi\|)? ( (\d+) (?: :((\d+)-(\d+)) )? ) /x;

        if ( !$gi ) {
            if ( my $acc = looks_like_accession( $conv->{$name}{gi} ) ) {
                $gi   = get_gi_for_acc($acc);
                $full = $conv->{$name}{gi};
                ( $pos, $start, $stop ) = $full =~ /(?: :((\d+)-(\d+)) )/x;
            }
            if ( !$gi ) {
                warn "Can't check Gene Identifier: ", $conv->{$name}{gi},
                  "\n";
                next;
            }
        }

        my $ncbi_seq = fetch_ncbi($gi);
        if ($ncbi_seq) {
            if ( $gi ne $ncbi_seq->primary_id ) {
                warn
                  "This should not happen:\nThe sequence $gi do not have the gi $gi in NCBI";
            }

            if ( $ncbi_seq->description =~ /mitochondrion/ && !defined $pos )
            {
                ERROR(
                    "Malformed identifier, $file at line $line",
                    "GI points to entire mitochondrion genome, but no position specified",
                    $gi
                );
                next;
            }

            my $sequence;
            if ($pos) {
                $sequence = $ncbi_seq->subseq( $start, $stop );
            }
            else {
                $sequence = $ncbi_seq->seq;
            }
            if ( exists $seqs->{$name} && $seqs->{$name} ne $sequence ) {
                my $length_diff
                  = length($sequence) - length( $seqs->{$name} );
                my $extra_msg
                  = "The sequences are equally long, I don't know what the error is";
                if ( $length_diff > 0 ) {
                    $extra_msg
                      = sprintf
                      'Your sequence is %dbp longer, did you copy too much?',
                      $length_diff;
                }
                elsif ( $length_diff < 0 ) {
                    $extra_msg
                      = sprintf
                      'Your sequence is %dbp longer, did you copy too little?',
                      abs($length_diff);
                }
                if ( length( $seqs->{$name} ) > length($sequence) ) {
                }
                elsif ( length( $seqs->{$name} ) < length($sequence) ) {
                    $extra_msg
                      = "Your sequence is shorter, did you copy too little?";
                }

                ERROR(
                    "GI $full points to wrong sequence, $file at line $line",
                    $extra_msg,
                );
            }
        }
        else {
            say "NO seq for $gi";
        }
    }
}

# We cache the retrieved sequences with the Storable so the script runs faster
# the second time it's run.
sub fetch_ncbi {
    my $gi = shift;
    state $store = {};
    if ( -f '/tmp/x7_gis.store' && keys(%$store) == 0 ) {
        $store = retrieve('/tmp/x7_gis.store');
    }
    if ( !exists $store->{$gi} ) {
        eval {
            my $factory = Bio::DB::EUtilities->new(
                qw{
                  -eutil    efetch
                  -db       protein
                  -rettype  gb
                  -email    johan.viklund@ebc.uu.se
                  -id}, [$gi]
            );
            my $seq_str = $factory->get_Response->content;
            return unless $seq_str;
            $store->{$gi} = $seq_str;
            store( $store, '/tmp/x7_gis.store' );
        };
        if ($@) {

            #say "Some error for gi: <$gi>";
            #die $@;
            return;
        }
    }
    my $seq_str = $store->{$gi};
    open my $SEQ, '<', \$seq_str;
    my $seqio = Bio::SeqIO->new( -fh => $SEQ, -format => 'genbank' );
    return $seqio->next_seq;    # Should only be one sequence anyway
}

sub get_gi_for_acc {
    my $acc     = shift;
    my $factory = Bio::DB::EUtilities->new(
        -eutil => 'esearch',
        -email => 'johan.viklund@ebc.uu.se',
        -db    => 'nucleotide',
        -term  => $acc,
    );

    my @uids = $factory->get_ids;
    if (@uids) {
        return $uids[0];
    }

    return;
}

sub check_fasta {
    my $f          = shift;
    my $conversion = shift;
    open my $F, '<', $f;
    my %sequences;
    my $head;
    while (<$F>) {
        chomp;
        given ($_) {
            when (/^>(.*?)\s*$/) {
                $head = $1;
                if ( length $head > 8 ) {
                    ERROR( $f, "Header line too long at line $.", $head );
                }
                if ( !exists $conversion->{$head} ) {
                    ERROR(
                        $f,
                        "Can't find fasta header in conversion file, line $.",
                        $head
                    );
                }
            }
            when (/^\s*$/)         { $sequences{$head} .= $_ }
            when (/^[actg]+\s*$/i) { $sequences{$head} .= $_ }
            when (/^[actgunrswyk]+\s*$/i) {
                $sequences{$head} .= $_;
                say "Degenerate nucleotides (OK)" if $VERBOSE
            }
            when (/^[actgunrswyk-]+\s*$/i) {
                say "WARNING $f is an alignment" unless $WARN{"aln$f"}++;
                s/-//g;
                $sequences{$head} .= $_;
            }
            default {
                my @not_dna = /([^actgunrswyk])/ig;
                ERROR(
                    $f,
                    "Sequence contains illegal character(s), line $.",
                    "did you forget the '>'?",
                    "Illegal characters: @not_dna"
                );
            }
        }
    }
    return %sequences;
}

# Parse the conversion file
sub parse_conversion {
    my $f = shift;
    open my $F, '<', $f;
    my %conv;
  LINE:
    while (<$F>) {
        chomp;
        if (/^\s*$/) {
            ERROR( $f, "Malformed conversion file, line $.", "Line empty" );
            next LINE;
        }
        my @f = split /\t+/, $_;
        if ( @f < 3 ) {
            ERROR(
                $f,
                "Malformed conversion file, line $.",
                "Too few fields (you should separate your columns with tabs): you have "
                  . scalar(@f)
                  . " fields"
            );
            next LINE;
        }
        if ( @f > 3 && !( @f == 4 && !( @f ~~ /^\s+$/ ) ) ) {
            ERROR(
                $f,
                "Malformed conversion file, line $.",
                "Too many fields (are you mixing tabs and spaces?): "
                  . scalar(@f)
                  . " fields"
            );

            # If the error is mixing tabs and spaces, take care of that here
            # and continue
            my @new_f = grep /\S/, @f;
            if ( @new_f < @f ) {
                @f = @new_f;
            }

            next LINE unless @f >= 3;
        }
        my @field_desc = ( 'Short name', 'Long name', 'Gene Identifier' );
        for my $i ( 0 .. $#f ) {
            if ( $f[$i] =~ s/^\s+//g ) {
                ERROR(
                    $f,
                    "Malformed conversion file, line $.",
                    "$field_desc[$i] for $f[0], starts with space"
                );
            }
            elsif ( $f[$i] =~ s/\s+$//g ) {
                ERROR(
                    $f,
                    "Malformed conversion file, line $.",
                    "$field_desc[$i] for $f[0], ends with space"
                );
            }
        }
        if ( $f[2] !~ /^ (?:gi\|)? ( (\d+) (?: :(\d+-\d+) )? ) /x ) {
            ERROR( $f, "Malformed GI number, line $.", "GI: $f[2]" )
              unless looks_like_accession( $f[2] );
        }
        if ( exists $conv{ $f[0] } ) {
            ERROR( $f, "Shortname $f[0] not unique",
                'Did you use the same name for both of the sequences?',
            );
        }
        @{ $conv{ $f[0] } }{qw/ name gi line file /} = ( @f[ 1, 2 ], $., $f );
    }
    return %conv;
}

sub is_fasta {
    my $file = shift;
    open my $F, '<', $file;
    return 1 if <$F> =~ /^>/;
    return '';
}

# Exclude perl scripts
sub is_conversion {
    my $file = shift;
    open my $F, '<', $file;
    while (<$F>) {
        return if /^#!.*perl/;
        return if /use strict/;
    }
    return 1;
}

sub ERROR {
    my @message = @_;
    my $file    = '';
    if ( -f $message[0] ) {
        $file = shift @message;
    }

    if ($file) {
        printf "ERROR %s: %s\n", $file, shift @message;
    }
    else {
        printf "ERROR: %s\n", shift @message;
    }
    printf "      %s\n", $_ for @message;
    $ERR++;
}

sub looks_like_accession {
    my $gi = shift;
    if ( $gi =~ /^(\D+\d+\.?\d*)/ ) {
        return $1;
    }
    return;
}

