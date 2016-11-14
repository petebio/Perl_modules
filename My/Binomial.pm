package My::Binomial;

##################################################################################################################
#                                                                                                                #
# Functions to calculate the binomial coefficient (n choose k).                                                  #
#                                                                                                                #
# Functions: factorial - Calculate the factorial for some number.                                                #
#            Useful for large numbers.                                                                           #
#            choose - Calculate the binomial coefficient.                                                        #
#                                                                                                                #
# Author: Peter Keane - peterakeane@gmail.com                                                                    #
#                                                                                                                #
##################################################################################################################

require Math::BigInt;
require Exporter;

use warnings;
use strict;
use vars qw($VERSION @ISA @EXPORT);

our $VERSION = 1.00;
our @ISA = qw(Exporter);

our @EXPORT = qw(factorial
		choose);
		
##################################################################################################################

sub factorial_BigInt{
	# Internal function. Not to be exported.
	my$n = shift;
	my$x = Math::BigInt -> new($n);
	my$fac = $x -> bfac;
	return $fac;
}

sub factorial{
	my$n = shift;
	my$fac = factorial_BigInt($n);
	my$fac_str = $fac -> bstr;
	return $fac_str;
}

sub choose{
	my($n, $k) = @_;

	if($k > $n){
		print STDERR "ERROR in choose: k must be less than n\n";
		return "NA";
	}

	my$x = factorial_BigInt($n)/(factorial_BigInt($k) * factorial_BigInt($n - $k));
	return $x -> bstr;
}

1;

##################################################################################################################
