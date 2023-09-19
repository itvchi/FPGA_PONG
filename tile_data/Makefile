SRCS = $(wildcard *.v)
TBSRCS = $(filter %_tb.v, $(SRCS))
VVPS = $(patsubst %_tb.v, %.vvp, $(TBSRCS))
VCDS = $(patsubst %_tb.v, %.vcd, $(TBSRCS))

all: $(VCDS)

$(VVPS): %.vvp: %_tb.v
	iverilog -o $@ $^

$(VCDS): %.vcd: %.vvp
	vvp $<

clean: 
	rm -rf $(VVPS) $(VCDS)