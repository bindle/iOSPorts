
LIBTOOL = glibtool
CC      = gcc

CFLAGS  = -W -Wall -Werror 
LDFLAGS = -framework Foundation

all: ldapTest
	./ldapTest

ldapTest: Makefile ldapTest.o ldapTestMain.o
	$(LIBTOOL) --mode=link --tag=objc $(CC) $(LDFLAGS) -o ldapTest ldapTest.o ldapTestMain.o -lldap

ldapTest.o: Makefile ldapTest.m
	$(LIBTOOL) --mode=compile --tag=objc $(CC) $(CFLAGS) -o ldapTest.lo -c ldapTest.m

ldapTestMain.o: Makefile ldapTestMain.m
	$(LIBTOOL) --mode=compile --tag=objc $(CC) $(CFLAGS) -c ldapTestMain.m

clean:
	$(LIBTOOL) --mode=clean rm -f ldapTest
	$(LIBTOOL) --mode=clean rm -f ldapTest.lo
	$(LIBTOOL) --mode=clean rm -f ldapTestMain.lo
	rm -f *.o ldapTest

