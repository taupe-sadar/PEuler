package ChinoisC;
use warnings;
use strict;

use Inline C => <<'END_C';

// --- TO BE REMOVED BY MAKEFILE ---
#include "stdio.h"
#include "stdlib.h"
// --- END OF TO BE REMOVED ---
unsigned long long moduloMult( unsigned long long a, unsigned long long b, unsigned long long p) 
{
  unsigned long long res = 0;
  //printf( "%d %d",(int)a,(int)b );
  while( a > 0 )
  {
    if( a & 1 )
      res = (res + b)%p;
    b = (b<<1)%p;
    
    a >>= 1;
  }
  
  return res;
}

int chinoisTest( unsigned long long p )
{
  unsigned long long pn=2;
  unsigned long long p_decomposed = p-1;
  unsigned long long prod= 1;
  
  while( p_decomposed > 0 )
  {
    if( p_decomposed & 0x1 )
      prod = moduloMult(prod , pn, p) ;
    p_decomposed >>= 1;
    
    pn = moduloMult(pn , pn, p);
  }
  return (( prod == 1 )?1:0);
}

int longChinoisTest( unsigned int p1, unsigned int p2 )
{
  unsigned long long p = p1;
  unsigned long long b = 1ULL<<32;
  return chinoisTest(p*b + p2);
}
END_C
1;
