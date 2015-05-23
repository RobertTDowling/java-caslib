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

@binops = qw(add sub mul div mod power colon hm md and or xor ee gcd lcm);
@binops2 = qw(divMod);
@unops = qw(log2 pow2 not floor addinv multinv exp ln sin cos tan arcsin arccos
	    arctan d2r r2d sqrt squared ceil ceillog2 ceilpow2 times2 divide2
	    round factor expand);

sub firstCap ($) {
    local $_ = shift;
    s/^(.)/chr(ord($1)-32)/e;
    $_;
}

for $o (@binops) {
    $O = firstCap ($o);
    $eo = "binOp";
    $Eo = firstCap ($eo);
    open FOUT, ">${O}.java" || die;
    print FOUT "// bp from $0\n";
    open FIN, "../LICENSE" || die;
    print FOUT $_ while (<FIN>);
    close FIN;
    print FOUT "package com.rtdti.cas;\n";
    print FOUT "\n";
    print FOUT "public class ${O} extends ${Eo} {\n";
    print FOUT "    	public ${O} () { }\n";
    print FOUT "	public Stackable ${eo} (SFactory f) {\n";
    print FOUT "		Stackable aa = f.makeFrom (f.args[0]);\n";
    print FOUT "		Stackable bb = f.makeFrom (f.args[1]);\n";
    print FOUT "		return bb.${o}To(aa);\n";
    print FOUT "	}\n";
    print FOUT "	public SFactory ${eo}ResultFactory (Stackable x, Stackable y) {\n";
    print FOUT "		SFactory f = x.${o}ResultFactory (y);\n";
    print FOUT "		// args = new Stackable [] { x, y };\n";
    print FOUT "		return f;\n";
    print FOUT "	}\n";
    print FOUT "}\n";
    close FOUT;
}
for $o (@unops) {
    $O = firstCap ($o);
    $eo = "unOp";
    $Eo = firstCap ($eo);
    open FOUT, ">${O}.java" || die;
    print FOUT "// bp from $0\n";
    open FIN, "../LICENSE" || die;
    print FOUT $_ while (<FIN>);
    close FIN;
    print FOUT "package com.rtdti.cas;\n";
    print FOUT "\n";
    print FOUT "public class ${O} extends ${Eo} {\n";
    print FOUT "    	public ${O} () { }\n";
    print FOUT "	public Stackable ${eo} (SFactory f) {\n";
    print FOUT "		Stackable aa = f.makeFrom (f.args[0]);\n";
    print FOUT "		return aa.${o} ();\n";
    print FOUT "	}\n";
    print FOUT "	public SFactory ${eo}ResultFactory (Stackable x) {\n";
    print FOUT "		SFactory f = x.${o}ResultFactory ();\n";
    print FOUT "		// args = new Stackable [] { x, x };\n";
    print FOUT "		return f;\n";
    print FOUT "	}\n";
    print FOUT "}\n";
    close FOUT;
}
