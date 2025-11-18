#!/usr/bin/perl
use strict;
use warnings;

my %length_num;
my $gene;
my $output="TSS_ID";
my $len;

for ($len=100;$len<=300;$len++) {
	$output="$output\t$len";
}
print "$output\n";
$output="";

while(<>){
	chomp;
	my @fields1=split(/\t/,$_);
	if($gene){
		if($gene eq $fields1[0]){
			if($length_num{$fields1[1]}){
				$length_num{$fields1[1]}++;
				next;
			}else{
				$length_num{$fields1[1]}=1;
				next;
			}
		}else{
			for ($len=100;$len<=300;$len++) {
				if($length_num{$len}){
					$output="$output\t$length_num{$len}";
				}else{
					$output="$output\t0";
				}
			}
			print "$output\n";
			$output="";
			$gene="";
			%length_num=();
			$len=0;
			redo;
		}
	}else{
		$gene=$fields1[0];
		$output=$gene;
		$length_num{$fields1[1]}=1;
		next;
	}
}

for ($len=100;$len<=300;$len++) {
	if($length_num{$len}){
		$output="$output\t$length_num{$len}";
	}else{
		$output="$output\t0";
	}
}
print "$output\n";
