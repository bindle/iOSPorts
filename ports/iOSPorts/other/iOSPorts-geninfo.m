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
 *  @file ports/iOSPorts/other/iOSPorts-geninfo.m Utility for generating iOS Ports information from Makefiles
 */
/*
 *  Simple Build:
 *     gcc -W -Wall -O2 -c iOSPorts-geninfo.m
 *     gcc -W -Wall -O2 -o iOSPorts-geninfo   iOSPorts-geninfo.o
 *
 *  GNU Libtool Build:
 *     libtool --mode=compile gcc -W -Wall -g -O2 -c iOSPorts-geninfo.m
 *     libtool --mode=link    gcc -W -Wall -g -O2 -o iOSPorts-geninfo iOSPorts-geninfo.lo
 *
 *  GNU Libtool Install:
 *     libtool --mode=install install -c iOSPorts-geninfo /usr/local/bin/iOSPorts-geninfo
 *
 *  GNU Libtool Clean:
 *     libtool --mode=clean rm -f iOSPorts-geninfo.lo iOSPorts-geninfo
 */
#define _IOSPORTS_SRC_IOSPORTSINFO_M 1

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
#define PROGRAM_NAME "iOSPorts-geninfo"
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
   const char      * pkg_name;           ///< name of package
   const char      * pkg_version;        ///< current package version
   const char      * pkg_website;        ///< package's website
   const char      * pkg_license_file;   ///< name of file containing license text
   char            * pkg_license;        ///< package's license text
   char            * pkg_id;             ///< package's identifier
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

   if (cnfp->pkg_id)
   {
      free(cnfp->pkg_id);
      cnfp->pkg_id = NULL;
   };

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
         "  -i file                   license input file\n"
         "  -I string                 identifier of package being processed\n"
         "  -N name                   name of package being processed\n"
         "  -o file                   output file\n"
         "  -R version                packag version string\n"
         "  -q, --quiet, --silent     do not print messages\n"
         "  -t, --test                show what would be done\n"
         "  -v, --verbose             print verbose messages\n"
         "  -V, --version             print version number and exit\n"
         "  -w url                    URL of package's website\n"
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
   char     * ptr;
   char       buff[512];
   char       datebuff[512];
   size_t     count;
   size_t     len;
   size_t     pos;
   time_t     now;
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
         case 'i':
            cnf.pkg_license_file = optarg;
            break;
         case 'I':
            if (!(cnf.pkg_id = strdup(optarg)))
            {
               perror(PROGRAM_NAME ": strdup()");
               return(1);
            };
            break;
         case 'N':
            cnf.pkg_name = optarg;
            break;
         case 'o':
            cnf.output = optarg;
            break;
         case 'q':
            cnf.quiet   = 1;
            cnf.verbose = 0;
            break;
         case 'R':
            cnf.pkg_version = optarg;
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
         case 'w':
            cnf.pkg_website = optarg;
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

   if (!(cnf.pkg_name))
   {
      fprintf(stderr, ("%s: missing required argument `-n'\n"
              "Try `%s --help' for more information.\n"
         ), PROGRAM_NAME, PROGRAM_NAME
      );
      return(iosports_free(&cnf, 1));
   };

   if (!(cnf.pkg_id))
   {
      if (!(cnf.pkg_id = strdup(cnf.pkg_name)))
      {
         perror(PROGRAM_NAME ": strdup()");
         return(iosports_free(&cnf, 1));
      };
   };
   for(u = 0; u < strlen(cnf.pkg_id); u++)
   {
      if ( ((cnf.pkg_id[u] < 'A') || (cnf.pkg_id[u] > 'Z')) &&
           ((cnf.pkg_id[u] < 'a') || (cnf.pkg_id[u] > 'z')) &&
           ((cnf.pkg_id[u] < '0') || (cnf.pkg_id[u] > '9')) )
         cnf.pkg_id[u] = '_';
   };

   if (cnf.pkg_license_file)
   {
      if ((fd = open(cnf.pkg_license_file, O_RDONLY)) == -1)
      {
         perror(PROGRAM_NAME ": open()");
         return(iosports_free(&cnf, 1));
      };
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
   snprintf(datebuff, 512, "%s", ctime(&now));
   if ((ptr = index(datebuff, '\n')))
      ptr[0] = '\0';

   if (cnf.verbose)
      fprintf(stderr, "writing data...\n");
   fprintf(cnf.fs, "/* Package information for %s */\n", cnf.pkg_name);
   fprintf(cnf.fs, "/* license imported from %s */\n", cnf.pkg_license_file ? cnf.pkg_license_file : "dreamland");
   fprintf(cnf.fs, "/* generated with %s */\n", PROGRAM_NAME);
   fprintf(cnf.fs, "/* generated on %s */\n", datebuff);
   fprintf(cnf.fs, "#import <iOSPorts/iOSPorts.h>\n");
   fprintf(cnf.fs, "const iOSPortsPKGData iOSPorts_pkgdata_%s =\n", cnf.pkg_id);
   fprintf(cnf.fs, "{\n   ");
   if ((cnf.pkg_id))
   {
      fprintf(cnf.fs, "\"%s\", // pkg_id\n   ", cnf.pkg_id);
   } else {
      fprintf(cnf.fs, "NULL, // pkg_id\n   ");
   };
   if ((cnf.pkg_name))
   {
      fprintf(cnf.fs, "\"%s\", // pkg_name\n   ", cnf.pkg_name);
   } else {
      fprintf(cnf.fs, "NULL, // pkg_name\n   ");
   };
   if ((cnf.pkg_version))
   {
      fprintf(cnf.fs, "\"%s\", // pkg_version\n   ", cnf.pkg_version);
   } else {
      fprintf(cnf.fs, "NULL, // pkg_version\n   ");
   };
   if ((cnf.pkg_website))
   {
      fprintf(cnf.fs, "\"%s\", // pkg_website\n   ", cnf.pkg_website);
   } else {
      fprintf(cnf.fs, "NULL, // pkg_website\n   ");
   };
   fprintf(cnf.fs, ((fd == -1) ? "{ 0x00 };" : "{")); fprintf(cnf.fs, "  // pkg_license\n     ");
   if (fd != -1)
   {
      count = 0;
      while((len = read(fd, buff, 512L)) > 0)
      {
         for(pos = 0; pos < len; pos++)
         {
            fprintf(cnf.fs, " 0x%02X,", buff[pos]);
            if (((count % 12)) == 11)
               fprintf(cnf.fs, "\n");
            count++;
            if (((count % 12)) == 0)
               fprintf(cnf.fs, "     ");
         };
      };
      fprintf(cnf.fs, " 0x00\n   }\n");
   }; 
   fprintf(cnf.fs, "};\n");
   fprintf(cnf.fs, "/* end of %s */\n\n", cnf.pkg_name);

   iosports_free(&cnf, 0);

   return(0);
}

/* end of source file */

