/* compile and run:
 *    gcc -framework Foundation ldapTest.m ldapTestMain.m -lldap -llber
 *    ./a.out
 */

#include <Foundation/Foundation.h>
#include <stdio.h>
#include <ldap.h>
#include "ldapTest.h"

int main(int argc, char * argv[]);

int main(int argc, char * argv[])
{
   int i;
   test_all_ldap(NULL);
   for(i = 1; i < argc; i++)
      test_all_ldap(argv[i]);
   return(0);
}
