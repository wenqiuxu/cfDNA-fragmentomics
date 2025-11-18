#!/usr/bin/perl
use strict;
use warnings;

my $ratio;
my $total_reads=0;
my %rate;

while(<>){
	chomp;
	my @array1=split(/\t/,$_);
	$ratio=$array1[2]/$array1[5];
	my $id="$array1[0]\t$array1[1]";
	$rate{$id}=$ratio;
	$total_reads=$total_reads+$array1[2]+$array1[5];
	next;
}

print "ID\tbins\traw_ratio\tnormalized_ratio\n";
foreach my $line1 (keys %rate) {
	chomp $line1;
	my $normalized=$rate{$line1}*1000000/$total_reads;
	print "$line1\t$rate{$line1}\t$normalized\n";
	next;
}
