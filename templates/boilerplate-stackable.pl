#!/usr/bin/perl

# Copyright (c) 2015, Robert T Dowling
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

@classes = qw(Scalar PrimeFactored Polynomial FactoredPolynomial DomainErr);
@binops = qw(add sub mul div mod power colon hm md and or xor ee gcd lcm);
@binops2 = qw(divMod);
@unops = qw(log2 pow2 not floor addinv multinv exp ln sin cos tan arcsin arccos
	    arctan d2r r2d sqrt squared ceil ceillog2 ceilpow2 times2 divide2
	    round factor expand);

$class = $input = "Stackable.k";

# Read input until // boilerplate, then insert this code

open FIN, "$input";
if (FIN) {
    while (<FIN>) {
	print;
	last if /\/\/ boilerplate/;
    }
}
insert_boilerplate();
if (FIN) {
    while (<FIN>) {
	print;
    }
}

sub insert_boilerplate () {
    print "/*bp*/  // $class\n";
    print "/*bp*/  \n";
    for $c (@classes) {
	for $o (@binops) {
	    print "/*bp*/  public Stackable ${o} (${c} y) { return new DomainErr (\"${c}.${o}\"); }\n";
	}
    }
    print "/*bp*/  \n";
    for $c (@classes) {
	for $o (@binops2) {
	    print "/*bp*/  public Stackable [] ${o} (${c} x) { return new Stackable [] { new DomainErr (\"${c}.${o}\"), new DomainErr (\"${c}.${o}\")}; }\n";
	}
    }
    print "/*bp*/  \n";
    for $o (@unops) {
	print "/*bp*/  public Stackable ${o} () { return new DomainErr (\"${o}\"); }\n";
    }
    print "/*bp*/  \n";
    for $o (@binops, @binops2) {
	print "/*bp*/  abstract public SFactory ${o}ResultFactory (Stackable y);\n";
    }
    for $o (@unops) {
	print "/*bp*/  abstract public SFactory ${o}ResultFactory ();\n";
    }
    for $c (@classes) {
	for $o (@binops, @binops2) {
	    print "/*bp*/  abstract public SFactory ${o}ResultFactoryWith${c} (Stackable x);\n";
	}
    }
    print "/*bp*/  \n";
    print "/*bp*/  // end boilerplate\n\n";
}

__DATA__
	public SFactory addResultFactory (Stackable y);
	public SFactory addResultFactoryWithScalar (Stackable x);
