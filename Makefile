
ERL=erl
CC=gcc

ERL_LIB=/media/opt/local/lib/erlang
ARCH=-m32
CFLAGS=-g -Wall
CPPFLAGS=-I$(ERL_LIB)/usr/include
#LDFLAGS=-L$(ERL_LIB)/lib -lpcap -lerl_interface -lei -lpthread

TUN_DRV_SO = priv/tun_drv.so
TUNCTL = priv/tunctl


all: erl $(TUN_DRV_SO) $(TUNCTL)

erl:
	@$(ERL) -noinput +B \
		-eval 'case make:all() of up_to_date -> halt(0); error -> halt(1) end.'

$(TUN_DRV_SO): tun_drv.o
	ld -G -o $@ c_src/$<

tun_drv.o: c_src/tun_drv.c
	$(CC) $(CFLAGS) -o c_src/$@ -c -fpic $(CPPFLAGS) $<

$(TUNCTL): c_src/tunctl.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	-rm $(TUN_DRV_SO) $(TUNCTL) c_src/*.o ebin/*.beam

.INTERMEDIATE: tun_drv.o


