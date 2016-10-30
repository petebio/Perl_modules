package My::Spearman;

##################################################################################################################
#                                                                                                                #
# Module to calculate the Spearman correlation for two numeric vectors.                                          #
#                                                                                                                #
# Functions - spearman - Calculate the spearman correlation.                                                     #
#             pcor_spreamen - Calculate the partial spearman correlation                                         #
#              for two vectors, x and y, controlling for z                                                       #
#                                                                                                                #
##################################################################################################################

require Statistics::RankCorrelation;
require Exporter;

use warnings;
use strict;
use vars qw($VERSION @ISA @EXPORT);

our $VERSION = 1.00;
our @ISA = qw(Exporter);
our @EXPORT = qw(spearman
		pcor_spearman);

##################################################################################################################

sub spearman{
	my($vector_a, $vector_b) = @_;
	my$stat = Statistics::RankCorrelation -> new($vector_a, $vector_b, sorted => 1);
	my$r = $stat -> spearman;
	return $r;
}

sub pcor_spearman{
	my($x, $y, $z) = @_;

	my$xy = calc_spearman($x, $y);
	my$xz = calc_spearman($x, $z);
	my$yz = calc_spearman($y, $z);

	my$pcor = ($xy - $xz * $yz) / (sqrt(1 - $xz ** 2) * sqrt(1 - $yz ** 2));

	return $pcor;
}

1;

##################################################################################################################