#!/usr/bin/perl

use v5.18;
use File::Slurp;

foreach my $infile (@ARGV) {
	my @chunks = read_file( $infile );
	my @reconstituted = ( );
	say "chunking $infile";
	foreach my $chunk (@chunks) {

# {{{

=cut

      <div style="background-color: #444444;">
      <span style="color: #c27ba0">this text is pink.</span><br />
      <span style="color: #6fa8dc;">this text is blue.</span><br />
      </div>

    21:41 alice: remember i said i get this sense of smug superiority from you?
    21:41 alice: it is because you don't seem to make any effort to actually talk to me

=cut

# }}}

		if ($chunk =~ /\d\d:\d\d <\s?dram[^>]+>/) {
			# This is alice
			$chunk =~ s/<dram[^>]+>/alice:/;
			# make it pink
			$chunk = q{<span style="color: #c27ba0">} . $chunk . q{</span><br />};
		}
		elsif ($chunk =~ /\d\d:\d\d <\s?reali[^>]+>/) {
			# This is bob
			$chunk =~ s/<\s?reali[^>]+>/bob:/;
			$chunk = q{<span style="color: #6fa8dc">} . $chunk . q{</span><br />};
		}
		else {
			say "Well, okay. We are going to ignore this line: $chunk";
		}
		push @reconstituted, $chunk;
	}

	unshift @reconstituted, q{<div style="background-color: #444444;">}.qq{\n};
	push @reconstituted, q{</div>}.qq{\n};

	say "spewing chunks into ${infile}.html";

	write_file( $infile.".html", @reconstituted );
}
