#!/usr/bin/perl
use strict;
use warnings;

my $sidebin_dep;
my $midbin_dep;
my $tss_score;
my $tss_id;

while(<>){
        chomp;
        my @array=split(/\t/,$_);

        if($tss_id){
                if($tss_id eq "$array[3]:$array[6]"){
                        if($array[5]<=5 || $array[5]>15){
                                $sidebin_dep+=$array[7];
                                next;
                        }elsif($array[5]>=8 && $array[5]<=13){
                                $midbin_dep+=$array[7];
                                next;
                        }
                }else{
			if($sidebin_dep){
                        	$tss_score=($midbin_dep/6)/($sidebin_dep/10);
                        	print "$tss_id\t$tss_score\n";
			}else{
				print "$tss_id\tNA\n";
			}

                        $tss_score=0;
                        $tss_id="";
                        $midbin_dep=0;
                        $sidebin_dep=0;
                        redo;
                }
        }else{
                $tss_id="$array[3]:$array[6]";
                if($array[5]<=5 || $array[5]>15){
                        $sidebin_dep=$array[7];
                        next;
                }elsif($array[5]>=8 && $array[5]<=13){
                        $midbin_dep=$array[7];
                        next;
                }
        }
}

if($sidebin_dep){
	$tss_score=($midbin_dep/6)/($sidebin_dep/10);
	print "$tss_id\t$tss_score\n";
}else{
	print "$tss_id\tNA\n";
}
