#!/usr/bin/perl

use strict;

my $fastagbk = $ARGV[0];
my $ifeature = $ARGV[1];
my $out = $ARGV[2];

open(IN,"<$fastagbk") || die;
open(OUT,">$out") || die;

my $seqmark=0;
while (<IN>){
    chomp;
    chop if(/\r$/);
    if(/^LOCUS/){
        print OUT "$_\n";
        printf OUT "%-21s%s\n", "FEATURES","Location/Qualifiers";

        open(FEA,"<$ifeature") || die;
        my $title = <FEA>;
        chomp $title;
        chop $title if(/\r$/);
        my @title = split(/\t/,$title);

        # determine which column is strand
        my $col_strand;
        for(my $n=0;$n<=$#title;$n++){
            if($title[$n] eq "strand"){
                $col_strand = $n;
            }
        }
        my $coor_start = $col_strand+1;
        my $coor_end;

        print "column strand: $col_strand\n";
        print "column coor start: $coor_start\n";


        while (<FEA>){
            chomp;
            chop if(/\r$/);
            my @line =split(/\t/);

            print "-------------------------------------\n";
            print "$line[0]\t$line[1]\t",scalar(@line),"\n";

            $coor_end = scalar(@line)-1;
            print "column coor end: $coor_end\n";

            my $final_coor;  # get the final coordinate format

            
            if($line[$col_strand] eq "+"){############################
                my $icoor;
                for(my $j=$coor_start;$j<=$coor_end-1;$j+=2){
                    if(!defined $icoor){
                        $icoor = "$line[$j]..$line[$j+1]";
                    }else{
                        $icoor .= ","."$line[$j]..$line[$j+1]";
                    }
                }

                if($icoor =~ /\,/){
                    $final_coor = "join(".$icoor.")"
                }else{
                    $final_coor = $icoor;
                }

                print "final coordinate: $final_coor\n";

            }else{#######################

                my $icoor;
                for(my $j=$coor_end-1; $j>=$coor_start;$j-=2){
                    if(!defined $icoor){
                        $icoor = "complement($line[$j]..$line[$j+1])";
                    }else{
                        $icoor .= ","."complement($line[$j]..$line[$j+1])";
                    }
                }

                if($icoor =~ /\,/){
                    $final_coor = "join(".$icoor.")"
                }else{
                    $final_coor = $icoor;
                }

                print "final coordinate: $final_coor\n";

            }

            ############################
            # print feature
            printf OUT "     %-16s%s\n", "$line[0]","$final_coor";

            for (my $ncol=1;$ncol<=$col_strand-1;$ncol++){
                next if($line[$ncol] eq "NA");
                printf OUT "                     %s\n","/$title[$ncol]=\"$line[$ncol]\"";
            }

            

        }

        close FEA;


    }elsif(/^ORIGIN/){
        $seqmark=1;
    }

    if($seqmark == 1){
        print OUT "$_\n";
    }
    
}

close IN;
