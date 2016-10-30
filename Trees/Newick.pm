package Trees::Newick;

##################################################################################################################
#                                                                                                                #
# Module to perform that uses the Bio::TreeIO BioPerl module to perform                                          #
# various operations on phylogenetic trees.                                                                      #
#                                                                                                                #
# Functions - read_newick - Create a tree object from a string containing a newick format tree.                  #
#             get_taxa - Get a list of all taxa (tip labels) of the phylogenetic tree.                           #
#             get_clade - Get all tip labels descended from a given node.                                        #
#             is_clade - Determine of a given set of taxa form a single clade.                                   #
#             get_branches - Get a list of all branches in the phylogenetic tree.                                #
#             compare_trees - Compare the branches of two phylogenetic trees to determine                        #
#              if the trees are identical (contain the same set of branches.                                     #
#             get_parents - Find child - parent relationships for each node on the tree.                         #
#             get_children - For each node of the phylogenetic tree, get a list                                  #
#              of all nodes descended from that node.                                                            #
#                                                                                                                #
##################################################################################################################

require Array::Utils qw(:all);
require Bio::TreeIO;
require IO::String;
require Exporter;

use warnings;
use strict;
use vars qw($VERSION @ISA @EXPORT);

our $VERSION = 1.00;
our @ISA = qw(Exporter);

our @EXPORT = qw(read_newick
		get_taxa
		get_clade
		is_clade
		get_branches
		compare_trees
		get_parents
		get_children);

##################################################################################################################

sub read_newick{
	my$raw_tree = shift;
	
	my$io = IO::String -> new($raw_tree);
	my$tree_io = Bio::TreeIO -> new(-format => "newick", -fh => $io);
	my$tree = $tree_io -> next_tree;
	
	return $tree;
}

sub get_taxa{
	my$tree = shift;
	
	my@leaf_nodes;
	foreach my$node ($tree -> get_leaf_nodes){
		push(@leaf_nodes, $node -> id);
	}
	
	return @leaf_nodes;
}

sub get_clade{
	my$node = shift;
	
	my@clade;
	if($node -> is_Leaf){
		push(@clade, $node -> id);
	}
	else{
		foreach my$child ($node -> get_all_Descendents){
			if($child -> is_Leaf){
				push(@clade, $child -> id);
			}
		}
	}
	
	return @clade;
}

sub is_clade{
	my($node_ids, $tree) = @_;
	
	my@nodes;
	foreach my$id (@{$node_ids}){
		my$node = $tree -> find_node(-id => $id);
		push(@nodes, $node);
	}
	
	my$lca = $tree -> get_lca(-nodes => \@nodes);
	
	my@clade = get_clade($lca);
	
	if(scalar @clade == scalar @{$node_ids}){
		return 1;
	}
	else{
		return 0;
	}
}

sub get_branches{
	my$tree = shift;
	
	my$root = $tree -> get_root_node;
	
	my@branches;
	foreach my$node ($root -> get_all_Descendents){
		my@taxa = get_clade($node);
		my$branch_id = join(",", sort {$a cmp $b} @taxa);
		push(@branches, $branch_id);
	}
	
	return @branches;
}

sub compare_trees{
	my($tree_a, $tree_b) = @_;

	my@branches_a = get_branches($tree_a);
	my@branches_b = get_branches($tree_a);
	
	if(scalar @branches_a == scalar @branches_b){
		my$overlap = scalar intersect(@branches_a, @branches_b);
	
		if($overlap == scalar @branches_a){
			return 1;
		}
		else{
			return 0;
		}
	}
	else{
		return 0;
	}
}

sub get_parents{
	my$tree = shift;
	
	my$root = $tree -> get_root_node;
	
	my%parents;
	foreach my$node ($root -> get_all_Descendents){
		my$node_id = join(",", sort {$a cmp $b} get_clade($node));

		my$parent_node = $node -> ancestor;
		my$parent_id = join(",", sort {$a cmp $b} get_clade($parent_node));

		$parents{$node_id} = $parent_id;
	}
	
	return %parents;
}

sub get_children{
	my$tree = shift;
	
	my$root = $tree -> get_root_node;
	
	my%children;
	foreach my$node ($root -> get_all_Descendents){
		my$node_id = join(",", sort {$a cmp $b} get_clade($node));

		my$parent_node = $node -> ancestor;
		my$parent_id = join(",", sort {$a cmp $b} get_clade($parent_node));

		push(@{$children{$parent_id}}, $node_id);
	}
	
	return %children;
}

1;

##################################################################################################################