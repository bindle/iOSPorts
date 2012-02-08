/*
 *  iOS Ports Library
 *  Copyright (c) 2012 Bindle Binaries
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
 *  @file ports/iOSPorts/other/iOSPorts-genlist.m generates array of package pointers
 */
/*
 *  Simple Build:
 *     gcc -W -Wall -O2 -c iOSPorts-genlist.m
 *     gcc -W -Wall -O2 -o iOSPorts-genlist   iOSPorts-genlist.o
 *
 *  GNU Libtool Build:
 *     libtool --mode=compile gcc -W -Wall -g -O2 -c iOSPorts-genlist.m
 *     libtool --mode=link    gcc -W -Wall -g -O2 -o iOSPorts-genlist iOSPorts-genlist.lo
 *
 *  GNU Libtool Install:
 *     libtool --mode=install install -c iOSPorts-genlist /usr/local/bin/iOSPorts-genlist
 *
 *  GNU Libtool Clean:
 *     libtool --mode=clean rm -f iOSPorts-genlist.lo iOSPorts-genlist
 */
#define _IOSPORTS_SRC_IOSPORTS_GENLIST_M 1

///////////////
//           //
//  Headers  //
//           //
///////////////

#import <time.h>
#import <stdio.h>
#import <stdlib.h>
#import <getopt.h>
#import <fcntl.h>
#import <string.h>
#import <unistd.h>

#define _IOSPORTS_CLI_TOOL 1
#import <iOSPorts/iOSPorts.h>


///////////////////
//               //
//  Definitions  //
//               //
///////////////////

#ifndef PROGRAM_NAME
#define PROGRAM_NAME "iOSPorts-genlist"
#endif
#ifndef PACKAGE_BUGREPORT
#define PACKAGE_BUGREPORT "development@bindlebinaries.com"
#endif
#ifndef PACKAGE_COPYRIGHT
#define PACKAGE_COPYRIGHT "Copyright (c) 2010, Bindle Binaries"
#endif
#ifndef PACKAGE_NAME
#define PACKAGE_NAME "iOS Ports Library"
#endif
#ifndef PACKAGE_VERSION
#define PACKAGE_VERSION "0.1"
#endif


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


/// config data
typedef struct iosports_config iOSPorts;
struct iosports_config
{
   unsigned          force;              ///< force writing of output file
   unsigned          verbose;            ///< enable verbose output
   unsigned          quiet;              ///< enable quiet output
   unsigned          test;               ///< perform test run
   int               fd;                 ///< output file handle
   FILE            * fs;                 ///< file stream derived from fd
   const char      * output;             ///< name of output file
};


//////////////////
//              //
//  Prototypes  //
//              //
//////////////////

/// frees resources
int iosports_free PARAMS((iOSPorts * cnfp, int code));

// displays usage
void iosports_usage PARAMS((void));

// displays version information
void iosports_version PARAMS((void));

// main statement
int main PARAMS((int argc, char * argv[]));


/////////////////
//             //
//  Functions  //
//             //
/////////////////

/// frees resources
/// @param[in]  cnf  configuration for iOSPorts Info
/// @param[in]  code return code to use
int iosports_free(iOSPorts * cnfp, int code)
{
   if (!(cnfp))
      return(code);

   // frees file handle
   cnfp->fd = (cnfp->fd == -1) ? STDOUT_FILENO : cnfp->fd;
   if (cnfp->fd == STDOUT_FILENO)
      return(code);
   if (cnfp->verbose)
      fprintf(stderr, "closing file...\n");
   fclose(cnfp->fs);
   cnfp->fd = STDOUT_FILENO;
   cnfp->fs = stdout;

   return(code);
}


/// displays usage
void iosports_usage(void)
{
   printf(("Usage: %s [OPTIONS] files\n"
         "  -f                        force writes\n"
         "  -h, --help                print this help and exit\n"
         "  -o file                   output file\n"
         "  -q, --quiet, --silent     do not print messages\n"
         "  -t, --test                show what would be done\n"
         "  -v, --verbose             print verbose messages\n"
         "  -V, --version             print version number and exit\n"
         "\n"
         "Report bugs to <%s>.\n"
      ), PROGRAM_NAME, PACKAGE_BUGREPORT
   );
   return;
}


/// displays version information
void iosports_version(void)
{
   printf(("%s (%s) %s\n"
         "Written by David M. Syzdek.\n"
         "\n"
         "%s\n"
         "This is free software; see the source for copying conditions.  There is NO\n"
         "warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n"
      ), PROGRAM_NAME, PACKAGE_NAME, PACKAGE_VERSION, PACKAGE_COPYRIGHT
   );
   return;
}


/// main statement
/// @param[in]  argc  number of arguments passed to program
/// @param[in]  argv  array of arguments passed to program
int main(int argc, char * argv[])
{
   int        c;
   int        fd;
   int        opts;
   int        opt_index;
   time_t     now;
   char     * cptr;
   char    ** list;
   size_t     lsize;
   size_t     pos;
   unsigned   u;
   iOSPorts   cnf;

   static char   short_opt[] = "fhi:I:N:o:qR:tvVw:";
   static struct option long_opt[] =
   {
      {"help",          no_argument, 0, 'h'},
      {"silent",        no_argument, 0, 'q'},
      {"quiet",         no_argument, 0, 'q'},
      {"test",          no_argument, 0, 't'},
      {"verbose",       no_argument, 0, 'v'},
      {"version",       no_argument, 0, 'V'},
      {NULL,            0,           0, 0  }
   };

   memset(&cnf, 0, sizeof(iOSPorts));
   fd     = -1;
   cnf.fd = STDOUT_FILENO;
   cnf.fs = stdout;

   while((c = getopt_long(argc, argv, short_opt, long_opt, &opt_index)) != -1)
   {
      switch(c)
      {
         case -1:	// no more arguments
         case 0:	// long options toggles
            break;
         case 'f':
            cnf.force = 1;
            break;
         case 'h':
            iosports_usage();
            return(0);
         case 'o':
            cnf.output = optarg;
            break;
         case 'q':
            cnf.quiet   = 1;
            cnf.verbose = 0;
            break;
         case 't':
            cnf.test = 1;
            break;
         case 'V':
            iosports_version();
            return(0);
         case 'v':
            cnf.quiet   = 0;
            cnf.verbose = 1;
            break;
         case '?':
            fprintf(stderr, ("Try `%s --help' for more information.\n"), PROGRAM_NAME);
            return(1);
         default:
            fprintf(stderr, ("%s: unrecognized option `--%c'\n"
                  "Try `%s --help' for more information.\n"
               ), PROGRAM_NAME, c, PROGRAM_NAME
            );
            return(iosports_free(&cnf, 1));
      };
   };

   if (optind == argc)
   {
      fprintf(stderr, "%s: missing required arguments\n", PROGRAM_NAME);
      fprintf(stderr, "Try `%s --help' for more information.\n", PROGRAM_NAME);
      return(iosports_free(&cnf, 1));
   };

   // opens output file for writing
   if ((cnf.output))
   {
      if (cnf.verbose)
         fprintf(stderr, "opening \"%s\" for writing...\n", cnf.output);
      opts  = O_WRONLY | O_CREAT;
      opts |= cnf.force ? O_TRUNC : O_EXCL;
      if ((cnf.fd = open(cnf.output, opts, 0644)) == -1)
      {
         if (!(cnf.quiet))
            perror(PROGRAM_NAME ": open()");
         return(iosports_free(&cnf, 1));
      };
      if (!(cnf.fs = fdopen(cnf.fd, "w")))
      {
         if (!(cnf.quiet))
            perror(PROGRAM_NAME ": fdopen()");
         return(iosports_free(&cnf, 1));
      };
   };

   now = time(NULL);
   fprintf(cnf.fs, "// generated with %s\n", PROGRAM_NAME);
   fprintf(cnf.fs, "// generated on %s\n", ctime(&now));
   fprintf(cnf.fs, "#import <stdio.h>\n");
   fprintf(cnf.fs, "#import <iOSPorts/iOSPorts.h>\n");
   fprintf(cnf.fs, "\n");

   lsize = 0;
   if (!(list = malloc(sizeof(char *) * (argc - optind))))
   {
      fprintf(stderr, "%s: out of virtual memory\n", PROGRAM_NAME);
      return(iosports_free(&cnf, 1));
   };

   while (optind < argc)
   {
      if (cnf.verbose)
         fprintf(stderr, "processing \"%s\"...\n", argv[optind]);

      if (!(cptr = rindex(argv[optind], '/')))
      {
         fprintf(stderr, PROGRAM_NAME ": invalid input file name: %s\n", list[pos]);
         return(iosports_free(&cnf, 1));
      };
      if (strlen(cptr) < 10)
      {
         fprintf(stderr, PROGRAM_NAME ": invalid input file name: %s\n", list[pos]);
         return(iosports_free(&cnf, 1));
      };
      list[lsize] = &cptr[9];

      if ((cptr = rindex(list[lsize], '.')))
         cptr[0] = '\0';

      for(u = 0; u < strlen(list[lsize]); u++)
      {
         if ( ((list[lsize][u] < 'A') || (list[lsize][u] > 'Z')) &&
              ((list[lsize][u] < 'a') || (list[lsize][u] > 'z')) &&
              ((list[lsize][u] < '0') || (list[lsize][u] > '9')) )
            list[lsize][u] = '_';
      };

      for(pos = 0; pos < lsize; pos++)
         if (!(strcasecmp(list[pos], list[lsize])))
            lsize--;

      lsize++;
      optind++;
   };

   for(pos = 0; pos < lsize; pos++)
      fprintf(cnf.fs, "extern const iOSPortsPKGData iOSPorts_pkgdata_%s;\n", list[pos]);
   fprintf(cnf.fs, "\n");

   fprintf(cnf.fs, "iOSPortsPKGListData iOSPortsPKGList[] =\n");
   fprintf(cnf.fs, "{\n");
   for(pos = 0; pos < lsize; pos++)
      fprintf(cnf.fs, "   { \"%s\", &iOSPorts_pkgdata_%s },\n", list[pos], list[pos]);
   fprintf(cnf.fs, "   { NULL, NULL }\n");
   fprintf(cnf.fs, "};\n");

   fprintf(cnf.fs, "\n");
   fprintf(cnf.fs, "/* end of source */\n");

   iosports_free(&cnf, 0);

   return(0);
}

/* end of source file */

