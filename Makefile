VLOG	= ncverilog
SRC		= header.v \
		  lzc.v \
		  lzc_t.v
WORD	= 0
WIDTH	= 0
VLOGARG	= +access+r +define+WORD=${WORD} +define+WIDTH=${WIDTH}
TMPFILE	= *.log \
		  verilog.key \
		  nWaveLog
DBFILE	= *.fsdb *.vcd *.bak
RM		= -rm -rf
ifneq ($(strip $(fsdbfile)), )
	VLOGARG += +fsdbfile=$(fsdbfile)
endif
ifneq ($(strip $(pattern)), )
	VLOGARG += +pattern=$(pattern)
endif
ifneq ($(strip $(golden)), )
	VLOGARG += +golden=$(golden)
endif
ifneq ($(strip ${DEBUG}), )
	VLOGARG += +DEBUG=${DEBUG}
endif

all::sim

sim:
	$(VLOG) $(SRC) $(VLOGARG)
check:
	$(VLOG) -c $(SRC)
clean:
	$(RM) $(TMPFILE)
veryclean:
	$(RM) $(TMPFILE) $(DBFILE)
