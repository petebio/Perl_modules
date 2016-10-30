package My::Sets;

##################################################################################################################
#                                                                                                                #
# Functions to calculate simple set similarity metrics.                                                          #
#                                                                                                                #
# Functions: jaccard - Calculates the jaccard index of two arrays.                                               #
#	     simpson - Calculate the Simpson coefficient of two arrays.                                          #
#    	     match - Calculates the match coefficient of two arrays.                                             #
#                                                                                                                #
# Author: Peter Keane - peterakeane@gmail.com                                                                    #
#                                                                                                                #
##################################################################################################################

require Array::Utils qw(:all);

require Exporter;

use warnings;
use strict;
use vars qw($VERSION @ISA @EXPORT);

our $VERSION = 1.00;
our @ISA = qw(Exporter);

our @EXPORT = qw(jaccard
		simpson
		match);

##################################################################################################################

sub jaccard{
	my($set_a, $set_b) = @_;
	my$shared = scalar intersect(@{$set_a}, @{$set_b});
	my$union = scalar unique(@{$set_a}, @{$set_b});
	my$jaccard = $shared / $union;
	
	return $jaccard;
}

sub simpson{
	my($set_a, $set_b)= @_;
	my$shared = scalar intersect(@{$set_a}, @{$set_b});
	my@sizes = sort {$a <=> $b} (scalar @{$set_a}, scalar @{$set_b});
	my$min = $sizes[0];
	my$simpson = $shared / $min;
	
	return $simpson;
}

sub match{
	my($set_a, $set_b)= @_;
	my$shared = scalar intersect(@{$set_a}, @{$set_b});
	my$match = ($shared ** 2) / ((scalar @{$set_a}) * (scalar @{$set_b}));
	
	return $match;
}

1;

##################################################################################################################
