SRC=dst_addr.c
CPP=g++
LIBCXXFLAGS= -I/usr/local/include
LDFLAGS=-L/usr/local/lib
all: dst_addr

dst_addr: $(SRC) Makefile 
	$(CPP) $(LIBCXXFLAGS) -std=c++0x $(SRC) $(LDFLAGS) -ltrace -lm -o $@


clean:
	rm  -rf dst_addr
