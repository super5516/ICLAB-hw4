#!/bin/sh
make WORD=16 WIDTH=16 pattern=lzc_w16c16.dat golden=lzc_w16c16gold.dat \
make WORD=4 WIDTH=16 pattern=lzc_w16c4.dat golden=lzc_w16c4gold.dat \
make WORD=8 WIDTH=16 pattern=lzc_w16c8.dat golden=lzc_w16c8gold.dat \
make WORD=16 WIDTH=4 pattern=lzc_w4c16.dat golden=lzc_w4c16gold.dat \
make WORD=4 WIDTH=4 pattern=lzc_w4c4.dat golden=lzc_w4c4gold.dat \
make WORD=8 WIDTH=4 pattern=lzc_w4c8.dat golden=lzc_w4c8gold.dat \
make WORD=4 WIDTH=8 pattern=lzc_w8c4.dat golden=lzc_w8c4gold.dat \
make WORD=8 WIDTH=8 pattern=lzc_w8c8.dat golden=lzc_w8c8gold.dat