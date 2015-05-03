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

JS=$(wildcard *.j)
JAVAS=$(subst .j,.java,$(JS))
KS=$(wildcard *.k)
KAVAS=$(subst .k,.java,$(KS))
OPS=Add.java Addinv.java And.java Arccos.java Arcsin.java Arctan.java \
    Ceil.java Ceillog2.java Ceilpow2.java Colon.java \
    Cos.java D2r.java Div.java Divide2.java Ee.java Exp.java \
    Factor.java Floor.java Gcd.java Hm.java Lcm.java Ln.java Log2.java \
    Md.java Mod.java Mul.java Multinv.java Not.java \
    Or.java Pow2.java Power.java R2d.java Round.java Sin.java \
    Sqrt.java Squared.java Sub.java Tan.java Times2.java Xor.java

all: $(JAVAS) $(KAVAS)
	./boilerplate-ops.pl

clean:
	rm -f $(JAVAS) $(KAVAS) $(OPS) *~
	cd ../cas; rm -f $(JAVAS) $(KAVAS) $(OPS) *~

%.java: %.j
	echo ./boilerplate.pl "$*" "$<" > "$@"
	./boilerplate.pl "$*" "$<" > "$@"

%.java: %.k
	echo ./boilerplate-stackable.pl "$*" "$<" > "$@"
	./boilerplate-stackable.pl "$*" "$<" > "$@"
