package My::Pearson;

##################################################################################################################
#                                                                                                                #
# Module to calculate the Pearson correlation for two numeric vectors.                                           #
#                                                                                                                #
# Functions: pearson - Calculates the Pearson's correlation.                                                     #
#	         pcor - Calculate the first order partial Pearson's correlation                                  #
#		      for two vectors x and y, controlling for z.                                                #
#	         second_order_pcor - Calculate the second order partial Pearson's correlation                    #
#		      for two vectors x and y, controlling for w and z.                                          #
#                                                                                                                #
# Author: Peter Keane - peterakeane@gmail.com                                                                    #
#                                                                                                                #
##################################################################################################################

use Stats::Simple;

require Exporter;

use warnings;
use strict;
use vars qw($VERSION @ISA @EXPORT);

our $VERSION = 1.00;
our @ISA = qw(Exporter);

our @EXPORT = qw(pearson
		pcor
		second_order_pcor);

##################################################################################################################

sub pearson{
	my($vector_x, $vector_y) = @_;
	
	# Check if vector x and y are the same size.
	# If not, return NA.
	if(scalar @{$vector_x} != scalar @{$vector_y}){
		print STDERR "ERROR in Stats::Simple::pearson. Vectors must be of same size.\n";
		return "NA";
	}
	
	# Get the mean of x (x_bar) and y (y_bar).
	my$x_bar = array_mean($vector_x);
	my$y_bar = array_mean($vector_y);
	
	# Formula for Pearson's correlation
	#
	#            sum{(X_i - X_bar) * (Y_i - Y_bar)}
	# ---------------------------------------------------------
	# sqrt{sum(X_i - X_bar) ** 2} * sqrt{sum(Y_i - Y_bar) ** 2} 
	
	my$top = 0;
	my$bottom_x = 0;
	my$bottom_y = 0;
	
	for(my$i = 0; $i < scalar @{$vector_x}; $i++){
		$top += ($vector_x -> [$i] - $x_bar) * ($vector_y -> [$i] - $y_bar);
		$bottom_x += ($vector_x -> [$i] - $x_bar) ** 2;
		$bottom_y += ($vector_y -> [$i] - $y_bar) ** 2;
		
	}
	
	# If $bottom_x or $bottom_y is Zero, return an error.
	# This means that in either vector, the values are constant.
	# i.e. No value differs from the mean.
	if($bottom_x == 0 || $bottom_y == 0){
		print STDERR "ERROR: Standard deviation is 0";
		return "NA";
	}
	
	my$cor = $top / (sqrt($bottom_x) * sqrt($bottom_y));
	return $cor;
}

sub pcor{
	my($vector_x, $vector_y, $vector_z) = @_;
	
	my$xy = pearson($vector_x, $vector_y);
	my$xz = pearson($vector_x, $vector_z);
	my$yz = pearson($vector_y, $vector_z);
	
	# Make sure all correlations were calculated successfully.
	if($xy ne "NA" && $xz ne "NA" && $yz ne "NA"){
		my$pcor = ($xy - $xz * $yz) / (sqrt(1 - $xz ** 2) * sqrt(1 - $yz ** 2));
		return $pcor;
	}
	else{
		return "NA";
	}
}

sub second_order_pcor{
	my($vector_x, $vector_y, $vector_w, $vector_z) = @_;
	
	my$xy_z = pcor($vector_x, $vector_y, $vector_z);
	my$xw_z = pcor($vector_x, $vector_w, $vector_w);
	my$yw_z = pcor($vector_y, $vector_w, $vector_z);
	
	# Check all correlations were calculated successfully.
	if($xy_z ne "NA" && $xw_z ne "NA" && $yw_z ne "NA"){
		my$cor = ($xy_z - $xw_z * $yw_z) / (sqrt(1 - $xw_z ** 2) * sqrt(1 - $yw_z ** 2));
		return $cor;
	}
	else{
		return "NA";
	}
}

1;

##################################################################################################################
