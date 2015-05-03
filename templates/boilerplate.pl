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

$scalarish{Scalar}++;
$scalarish{PrimeFactored}++;

$class = shift;
if ($class eq '-c') { print join (' ', @classes),"\n";  exit 0;
} elsif ($class eq '-b') { print join (' ', @binops),"\n";  exit 0;
} elsif ($class eq '-b2') { print join (' ', @binops2),"\n";  exit 0;
} elsif ($class eq '-u') { print join (' ', @unops),"\n";  exit 0;
}
$input = shift;

for $o (@binops, @binops2, @unops) {
    $LUT{$o}{Scalar}{Scalar} = "Scalar";
    $LUT{$o}{Scalar}{PrimeFactored} = "Scalar";
    $LUT{$o}{PrimeFactored}{Scalar} = "Scalar";
    $LUT{$o}{PrimeFactored}{PrimeFactored} = "Scalar";
}

# add/sub                Scalar             PrimeFactored      Polynomial         FactoredPolynomial
$X{Scalar}="             Scalar             Scalar             Polynomial         Polynomial";
$X{PrimeFactored}="      Scalar             Scalar             Polynomial         Polynomial";
$X{Polynomial}="         Polynomial         Polynomial         Polynomial         Polynomial";
$X{FactoredPolynomial}=" Polynomial         Polynomial         Polynomial         Polynomial";

$LUT{add} = $LUT{sub} = { mklut() };

# mul/div/divMod         Scalar             PrimeFactored      Polynomial         FactoredPolynomial
$X{Scalar}="             Scalar             PrimeFactored      Polynomial         FactoredPolynomial";
$X{PrimeFactored}="      PrimeFactored      PrimeFactored      Polynomial         FactoredPolynomial";
$X{Polynomial}="         Polynomial         Polynomial         Polynomial         FactoredPolynomial";
$X{FactoredPolynomial}=" FactoredPolynomial FactoredPolynomial FactoredPolynomial FactoredPolynomial";

$LUT{mul} = $LUT{div} = $LUT{divMod} = { mklut() };

# power                  Scalar             PrimeFactored      Polynomial         FactoredPolynomial
$X{Scalar}="             Scalar             PrimeFactored      Error              Error";
$X{PrimeFactored}="      PrimeFactored      PrimeFactored      Error              Error";
$X{Polynomial}="         Polynomial         Polynomial         Error              Error";
$X{FactoredPolynomial}=" FactoredPolynomial FactoredPolynomial Error              Error";

$LUT{power} = { mklut() };

$LUT{factor}{Scalar} = "PrimeFactored";
$LUT{factor}{PrimeFactored} = "PrimeFactored";
$LUT{factor}{Polynomial} = "FactoredPolynomial";
$LUT{factor}{FactoredPolynomial} = "FactoredPolynomial";
$LUT{factor}{DomainErr} = "DomainErr";

$LUT{expand}{Scalar} = "Scalar";
$LUT{expand}{PrimeFactored} = "Scalar";
$LUT{expand}{Polynomial} = "Polynomial";
$LUT{expand}{FactoredPolynomial} = "Polynomial";
$LUT{expand}{DomainErr} = "DomainErr";

sub mklut() {
    my %LUT;
    for $lc (@classes) {
	my $s = $X{$lc};
	my @s = split " ", $s;
	for $rc (@classes) {
	    $LUT{$lc}{$rc} = shift @s;
	}
    }
    # for $lc (@classes) {
    # 	for $rc (@classes) {
    # 	    printf " (%s)", $LUT{$lc}{$rc};
    # 	}
    # 	print "\n";
    # }
    return %LUT;
}

sub mklutScalar() {
    my %LUT;
    for $lc (@classes) {
	for $rc (@classes) {
	    $LUT{$lc}{$rc} = ($scalarish{$lc} && $scalarish{$rc}) ? "Scalar" : "DomainErr";
	}
    }
    # for $lc (@classes) {
    # 	for $rc (@classes) {
    # 	    printf " (%s)", $LUT{$lc}{$rc};
    # 	}
    # 	print "\n";
    # }
    return %LUT;
}

##############################################################################

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
    for $o (@binops) {
	print "/*bp*/  public Stackable ${o}To (Stackable x) { return x.${o}(this); }\n";
    }
    for $o (@binops2) {
	print "/*bp*/  public Stackable [] ${o}To (Stackable x) { return x.${o}(this); }\n";
    }
    print "/*bp*/  \n";
    for $c (@classes) {
	print "/*bp*/  public Stackable make${c}From () { return new ${c} (this); }\n";
    }
    print "/*bp*/  \n";
    for $o (@binops, @binops2) {
	print "/*bp*/  public SFactory ${o}ResultFactory (Stackable y) { return y.${o}ResultFactoryWith${class} (this); }\n";
    }
    print "/*bp*/  \n";
    for $o (@unops) {
	print "/*bp*/  public SFactory ${o}ResultFactory () { return new ${class}Factory(this, this); }\n";
    }
    for $c (@classes) {
	print "/*bp*/  \n";
	for $o (@binops, @binops2) {
	    $l = $LUT{$o}{$c}{$class} || "DomainErr";
	    # print "// $class op $c\n";
	    print "/*bp*/  public SFactory ${o}ResultFactoryWith${c} (Stackable x) { return new ${l}Factory (x, this); }\n";
	}
    }
    print "/*bp*/  \n";
    print "/*bp*/  // end boilerplate\n\n";
}

__DATA__
B* public Stackable ${BINOP}To (Stackable x) { return x.${BINOP}(this); }
B2* public Stackable [] ${BINOP2}To (Stackable x) { return x.${BINOP2}(this); }
# U* public Stackable [] ${UNOP}To (Stackable x) { return x.${UNOP}(this); }
C* public Stackable make${CLASS}From () { return new ${CLASS} (this); }
C*B* public SFactory ${BINOP}ResultFactory (Stackable y) {
		return y.${BINOP}ResultFactoryWith${LUCLASS} (this); }
C*B2* public SFactory ${BINOP}ResultFactory (Stackable y) {
		return y.${BINOP}ResultFactoryWith${LUCLASS} (this); }
C*U* public SFactory ${UNOP}ResultFactory (Stackable x){
		return new ${LUCLASS}Factory(x, null); }
 public Stackable copy () { return new ${CLASS} (this); }

__END__

	public Stackable addTo (Stackable x) { return x.add(this); }
	public Stackable subTo (Stackable x) { return x.sub(this); }
	public Stackable mulTo (Stackable x) { return x.mul(this); }
	public Stackable divTo (Stackable x) { return x.div(this); }
	public Stackable [] divModTo (Stackable x) { return x.divMod(this); }
	public Stackable powerTo (Stackable x) { return x.power(this); }

	public Stackable makeFactoredFrom () { return new Factored (this); }
	public Stackable makePolynomialFrom () { return new Polynomial (this); }
	public Stackable makeScalarFrom () { return new Scalar (scalar()); }

	public SFactory addResultFactory (Stackable y) {		return y.addResultFactoryWithFactored (this); }
	public SFactory subResultFactory (Stackable y) {		return y.subResultFactoryWithFactored (this); }
	public SFactory mulResultFactory (Stackable y) {		return y.mulResultFactoryWithFactored (this); }
	public SFactory divResultFactory (Stackable y) {		return y.divResultFactoryWithFactored (this); }
	public SFactory divModResultFactory (Stackable y) {		return y.divModResultFactoryWithFactored (this); }
	public SFactory powerResultFactory (Stackable y) {		return y.powerResultFactoryWithFactored (this); }

	public SFactory addResultFactoryWithFactored (Stackable x){		return new PolynomialFactory(x, this); }
	public SFactory subResultFactoryWithFactored (Stackable x){		return new PolynomialFactory(x, this); }
	public SFactory mulResultFactoryWithFactored (Stackable x){		return new FactoredFactory(x, this); }
	public SFactory divResultFactoryWithFactored (Stackable x){		return new FactoredFactory(x, this); }
	public SFactory divModResultFactoryWithFactored (Stackable x){		return new FactoredFactory(x, this); }
	// This is (Factored.exp).pResultFactoryWithT(Factored.base)
	// It should never be called!
	public SFactory powerResultFactoryWithFactored (Stackable x){		System.out.print ("Can't compute Factored^Factored");
		return new FactoredFactory(x, this); }

	public SFactory addResultFactoryWithPolynomial (Stackable x){		return new PolynomialFactory(x, this); }
	public SFactory subResultFactoryWithPolynomial (Stackable x){		return new PolynomialFactory(x, this); }
	public SFactory mulResultFactoryWithPolynomial (Stackable x){		return new FactoredFactory(x, this); }
	public SFactory divResultFactoryWithPolynomial (Stackable x){		return new FactoredFactory(x, this); }
	public SFactory divModResultFactoryWithPolynomial (Stackable x){		return new FactoredFactory(x, this); }
	// This is (Factored.exp).pResultFactoryWithT(Polynomial.base)
	// It should never be called!
	public SFactory powerResultFactoryWithPolynomial (Stackable x){		System.out.print ("Can't compute Polynomial^Factored");
		return new FactoredFactory(x, this); }

	public SFactory addResultFactoryWithScalar (Stackable x){		return new PolynomialFactory(x, this); }
	public SFactory subResultFactoryWithScalar (Stackable x){		return new PolynomialFactory(x, this); }
	public SFactory mulResultFactoryWithScalar (Stackable x){		return new FactoredFactory(x, this); }
	public SFactory divResultFactoryWithScalar (Stackable x){		return new FactoredFactory(x, this); }
	public SFactory divModResultFactoryWithScalar (Stackable x){		return new FactoredFactory(x, this); }
	// This is (Factored.exp).pResultFactoryWithT(Scalar.base)
	// It should never be called!
	public SFactory powerResultFactoryWithScalar (Stackable x){		System.out.print ("Can't compute Scalar^Factored");
		return new FactoredFactory(x, this); }

	public SFactory factorResultFactory (Stackable x){		return new FactoredFactory(x, null);	}

	public Stackable copy () { return new Factored (this); }
