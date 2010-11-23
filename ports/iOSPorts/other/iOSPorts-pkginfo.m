/*
 *  iOS Ports Library
 *  Copyright (c) 2010, Bindle Binaries
 *  All rights reserved.
 *
 *  @BINDLE_BINARIES_BSD_LICENSE_START@
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of Bindle Binaries nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 *  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 *  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 *  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL BINDLE BINARIES BE LIABLE FOR
 *  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 *  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 *  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 *  SUCH DAMAGE.
 *
 *  @BINDLE_BINARIES_BSD_LICENSE_END@
 */
/**
 *  @file ports/iOSPorts/other/iOSPorts-pkginfo.m displays package information
 */
/*
 *  Simple Build:
 *     gcc -W -Wall -O2 -c iOSPorts-pkginfo.m
 *     gcc -W -Wall -O2 -o iOSPorts-pkginfo   iOSPorts-pkginfo.o
 *
 *  GNU Libtool Build:
 *     libtool --mode=compile gcc -W -Wall -g -O2 -c iOSPorts-pkginfo.m
 *     libtool --mode=link    gcc -W -Wall -g -O2 -o iOSPorts-pkginfo iOSPorts-pkginfo.lo
 *
 *  GNU Libtool Install:
 *     libtool --mode=install install -c iOSPorts-pkginfo /usr/local/bin/iOSPorts-pkginfo
 *
 *  GNU Libtool Clean:
 *     libtool --mode=clean rm -f iOSPorts-pkginfo.lo iOSPorts-pkginfo
 */
#define _IOSPORTS_SRC_IOSPORTS_PKGINFO_M 1

///////////////
//           //
//  Headers  //
//           //
///////////////

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <iOSPorts/iOSPortsTypes.h>
#include <iOSPorts/iOSPortsCFuncs.h>

//////////////
//          //
//  Macros  //
//          //
//////////////

/*
 * The macro "PARAMS" is taken verbatim from section 7.1 of the
 * Libtool 1.5.14 manual.
 */
/* PARAMS is a macro used to wrap function prototypes, so that
   compilers that don't understand ANSI C prototypes still work,
   and ANSI C compilers can issue warnings about type mismatches. */
#undef PARAMS
#if defined (__STDC__) || defined (_AIX) \
        || (defined (__mips) && defined (_SYSTYPE_SVR4)) \
        || defined(WIN32) || defined (__cplusplus)
# define PARAMS(protos) protos
#else
# define PARAMS(protos) ()
#endif


//////////////////
//              //
//  Prototypes  //
//              //
//////////////////

// main statement
int main PARAMS((int argc, char * argv[]));

/////////////////
//             //
//  Functions  //
//             //
/////////////////

/// main statement
/// @param[in]  argc  number of arguments passed to program
/// @param[in]  argv  array of arguments passed to program
int main(int argc, char * argv[])
{
   const iOSPortsPKGData * datap;

   if (argc != 2)
   {
      fprintf(stderr, "Usage: %s <identifier>\n", argv[0]);
      return(1);
   };

   if (!(datap = iOSPorts_find_pkg_by_id(argv[1])))
   {
      fprintf(stderr, "%s: %s: package not found\n", argv[0], argv[1]);
      return(1);
   };

   printf("Identifier: %s\n", datap->pkg_id      ? datap->pkg_id      : "unknown");
   printf("Name:       %s\n", datap->pkg_name    ? datap->pkg_name    : "unknown");
   printf("Version:    %s\n", datap->pkg_version ? datap->pkg_version : "unknown");
   printf("Website:    %s\n", datap->pkg_website ? datap->pkg_website : "unknown");
   if (strlen(datap->pkg_license) > 0)
      printf("License:\n%s\n", datap->pkg_license);

   return(0);
}

/* end of source file */
