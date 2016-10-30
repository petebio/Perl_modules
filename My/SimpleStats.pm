package My::SimpleStats;

##################################################################################################################
#                                                                                                                #
# Calculate simple descriptive statistics for two numerical vectors.                                             #
#                                                                                                                #
# Functions: array_mean - Calculate the mean of two arrays.                                                      #
#	         array_median - Calculate the median of two arrays.                                                  #
#            array_sd - Calculate the standard deviation of two arrays.                                          #
#            calc_cv - Calculate the coefficient of variation of an array.                                       #
#                                                                                                                #
# Author: Peter Keane - peterakeane@gmail.com                                                                    #
#                                                                                                                #
##################################################################################################################

require Statistics::Descriptive;
require Exporter;

use warnings;
use strict;
use vars qw($VERSION @ISA @EXPORT);

our $VERSION = 1.00;
our @ISA = qw(Exporter);
our @EXPORT = qw(array_mean
		array_median
		array_sd
		calc_cv);

##################################################################################################################

sub read_stat{
	# Internal function. Not to be exported
	my$vector = shift;
	my$stat = Statistics::Descriptive::Full -> new;
	$stat -> add_data($vector);
	return $stat;
}

sub array_mean{
	my$vector = shift;
	
	if(scalar @{$vector} == 0){
		print STDERR "ERROR in Stats::Simple::array_mean. Vector must not be of length 0\n";
		return 0;
	}
	
	my$stat = read_stat($vector);
	my$mean = $stat -> mean;
	return $mean;
}

sub array_median{
	my$vector = shift;
	
	if(scalar @{$vector} == 0){
		print STDERR "ERROR in Stats::Simple::array_median. Vector must not be of length 0\n";
		return 0;
	}
	
	my$stat = read_stat($vector);
	my$median = $stat -> median;
	return $median;
}

sub array_sd{
	my$vector = shift;
	
	if(scalar @{$vector} == 0){
		print STDERR "Error in Stats::Simple::array_sd. Vector must not be of length 0\n";
		return 0;
	}
	
	my$stat = read_stat($vector);
	my$sd = $stat -> standard_deviation;
	return $sd;
}

sub calc_cv{
	my$vector = shift;
	
	if(scalar @{$vector} == 0){
		print STDERR "ERROR in Stats::Simple::calc_cv. Vector must not be of length 0\n";
		return 0;
	}
	
	my$mu = array_mean($vector);
	my$sigma = array_sd($vector);
	my$n = scalar @{$vector};

	if($mu == 0){
		return 0;
	}
	
	my$cv = 100 * ($sigma / $mu);
	my$adj_cv = (1 + (1/(4 * $n))) * $cv;
	
	return $adj_cv;
}

1;

##################################################################################################################
