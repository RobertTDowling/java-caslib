GVS=$(wildcard *.gv)
PNGS=$(subst .gv,.png,$(GVS))
RES=$(wildcard *.tex)
PDFS=$(subst .tex,.pdf,$(RES))

CMD=fdp
CMD=neato
CMD=dot

all: $(PNGS) $(PDFS)

clean:
	rm -f $(PNGS) *~

%.png: %.gv
	$(CMD) -Tpng -o $@ $<

%.eps: %.gv
	dot -Teps -o $@ $<

%.eps: %.m
	octave $<

%.pdf: %.tex
	./tops $<

%.txt: %.tex
	./tex2txt $< > $@
	./tex2txt -r $< > $@

# brainstorm.png: brainstorm.gv Makefile
# 	neato -Tpng -o $@ $<

# float-frac-flow.png: float-frac-flow.gv Makefile
#	neato -Tpng -o $@ $<
