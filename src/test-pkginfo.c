/*
 * Quick example to test dlsym()
 * build: gcc -W -Wall -Werror -o test-dlsym test-dlsym.c
 * Usage: ./test-dlsym openldap
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <iOSPorts.h>

int main(int argc, char * argv[])
{
   char symbol_name[512];
   unsigned u;
   const iOSPortsPKGData * datap;

   if (argc != 2)
   {
      fprintf(stderr, "Usage: %s <identifier>\n", argv[0]);
      return(1);
   };

   for(u = 0; u < strlen(argv[1]); u++)
   {
      if ((argv[1][u] >= 'A') && (argv[1][u] <= 'Z'))
         argv[1][u] = argv[1][u] - 'A' +'a';
      else if ( ((argv[1][u] < 'a') || (argv[1][u] > 'z')) &&
                ((argv[1][u] < '0') || (argv[1][u] > '9')) )
         argv[1][u] = '_';
   };
   snprintf(symbol_name, 512, "iOSPorts_pkgdata_%s", argv[1]);

   if (!(datap = (const iOSPortsPKGData *) dlsym(RTLD_SELF, symbol_name)))
   {
      fprintf(stderr, "%s: dlsym(%s): %s\n", argv[0], symbol_name, dlerror());
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
