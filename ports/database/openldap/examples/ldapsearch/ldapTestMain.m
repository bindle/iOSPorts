/* compile and run:
 *    gcc -framework Foundation ldapTest.m ldapTestMain.m -lldap -llber
 *    ./a.out
 */

#include <Foundation/Foundation.h>
#include <stdio.h>
#include <ldap.h>
#include "ldapTest.h"

int main(void);

int main(void)
{
   test_all_ldap();

   return(0);
}
