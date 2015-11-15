VLOG	= ncverilog
SRC		= header.v \
		  lzc.v \
		  lzc_t.v
WORD	= 0
WIDTH	= 0
VLOGARG	= +access+r +WORD=${WORD} +WIFTH=${WIDTH}
TMPFILE	= *.log \
		  verilog.key \
		  nWaveLog
DBFILE	= *.fsdb *.vcd *.bak
RM		= -rm -rf
ifneq ($(fsdbfile), '')
	VLOGARG += +fsdbfile=$(fsdbfile)
endif
ifneq ($(test_input), '')
	VLOGARG += +pattern=$(test_input)
endif
ifneq ($(test_golden), '')
	VLOGARG += +golden=$(test_golden)
endif

all::sim

sim:
ifndef WIDTH
	@echo 'Using default width.'
	$(VLOG) $(SRC) $(VLOGARG)
else
	@echo 'Counter width: $(WIDTH)'
	$(VLOG) $(SRC) $(VLOGARG) +define+WIDTH=$(WIDTH)
endif
check:
	$(VLOG) -c $(SRC)
clean:
	$(RM) $(TMPFILE)
veryclean:
	$(RM) $(TMPFILE) $(DBFILE)
