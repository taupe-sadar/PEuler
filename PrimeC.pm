package PrimeC;
use warnings;
use strict;

use Inline C => <<'END_C';

#define MODULO     30
#define PRIME_STOCK_SIZE 4096

int offsets[8] = { 1 , 7 , 11 , 13 , 17 ,19 , 23, 29 };

int ceilLambdaForFirstMultiple [ MODULO ] = {
  0, 0, 1, 1, 1, 1,
  1, 1, 2, 2, 2, 2,
  3, 3, 4, 4, 4, 4,
  5, 5, 6, 6, 6, 6,
  7, 7, 7, 7, 7, 7  
};

unsigned char maskForCrossing[ MODULO ] = {
  0, 0xfe, 0, 0, 0, 0,
  0, 0xfd, 0, 0, 0, 0xfb,
  0, 0xf7, 0, 0, 0, 0xef,
  0, 0xdf, 0, 0, 0, 0xbf,
  0,    0, 0, 0, 0, 0x7f  
};

typedef struct SieveSegment
{
  unsigned char sieve;
} SieveSegment;

typedef struct PrimeStock
{
  int primes[ PRIME_STOCK_SIZE ];
  int num;
  struct PrimeStock* nextStock;
} PrimeStock;

SieveSegment * eratSieveSegment;
int eratSize = 0;

PrimeStock* chainedPrimeStock = NULL;
PrimeStock* lastPrimeStock = NULL;
int numRegisteredPrimes = 0;

int highestSievedValue = 0;
int sieveCurrentIdx = 0;
int bigPrimeOffset = 0;

void initPrimeStock()
{
   Newx( chainedPrimeStock, 1  , PrimeStock );
   chainedPrimeStock->primes[0] = 2;
   chainedPrimeStock->primes[1] = 3;
   chainedPrimeStock->primes[2] = 5;
   numRegisteredPrimes = 3;
   chainedPrimeStock->num = 3;
   chainedPrimeStock->nextStock = NULL;
   
   
   lastPrimeStock = chainedPrimeStock;
}

void pushPrimeInStock( int prime )
{
  if( lastPrimeStock->num == PRIME_STOCK_SIZE )
  {
    Newx( lastPrimeStock->nextStock, 1  , PrimeStock );
    lastPrimeStock = lastPrimeStock->nextStock;
    lastPrimeStock->num = 0;
    lastPrimeStock->nextStock = NULL;
  }
  
  lastPrimeStock->primes[ lastPrimeStock->num ++ ] = prime;
  numRegisteredPrimes ++;
}

void initSieve()
{
  int i;
  sieveCurrentIdx = 0;
  
  for( i = 0; i < eratSize ; i++ )
    eratSieveSegment[ i ].sieve = 0xff;
  
  if( bigPrimeOffset == 0 )
    eratSieveSegment[ 0 ].sieve = 0xfe; //Considering 1 not as a prime

}

int primesInNextSegment( int* primes )
{
  unsigned char sieveSeg = eratSieveSegment[ sieveCurrentIdx ].sieve;
  
  int idx = 0;
  int num = 0;
  while( sieveSeg > 0 ) 
  {
    if( sieveSeg & 0x01 )
    {
      primes[ num ++ ] = bigPrimeOffset + offsets[ idx ];
    }
    sieveSeg >>= 1;
    idx++;
  }
  return num;
}

void calcFirstMultiple( int prime, int* pidxInOffsets, int* plargeModuloOffset  )
{
  int firstLambda = ( highestSievedValue + prime - 1 ) / prime;
  
  if( firstLambda == 1 ) //Keeping init values : idx = 1, largeOffset = 0
    return;
  
  int moduloIdx = firstLambda % MODULO;
  
  *pidxInOffsets = ceilLambdaForFirstMultiple[ moduloIdx ];
  *plargeModuloOffset = firstLambda - moduloIdx ;
}

void crossSieve( int prime )
{
  int idxInOffsets = 1;
  int largeModuloOffset = 0;
  
  if( highestSievedValue > 0 )
    calcFirstMultiple( prime, &idxInOffsets, &largeModuloOffset );
  
  int multiple = ( offsets[ idxInOffsets ] + largeModuloOffset ) * prime;
  int maxMultiple = MODULO * eratSize + highestSievedValue ;
  while( multiple < maxMultiple )
  {
    eratSieveSegment[ (multiple - highestSievedValue )/ MODULO  ].sieve &= maskForCrossing[ multiple % MODULO ] ;
    idxInOffsets ++;
    if( idxInOffsets == 8 )
    {
      idxInOffsets = 0; 
      largeModuloOffset += MODULO;
    }
    multiple = prime*( largeModuloOffset  +  offsets[ idxInOffsets ] );
  }
}

void crossWithKnownPrimes()
{
  PrimeStock* pStock = chainedPrimeStock;
  int idx = 3; //Skipping 2, 3, 5,
  do
  {
    for(; idx < pStock->num ; idx ++ )
    {
      crossSieve( pStock->primes[ idx ] );
    }
    idx = 0;
    pStock = pStock->nextStock;
  }
  while( pStock != NULL );
}

void processSieve( int sieveMax )
{
  if( sieveMax <= highestSievedValue )
    return;
  
  if( chainedPrimeStock == NULL )
    initPrimeStock();

  eratSize = ( sieveMax - highestSievedValue + MODULO - 1 )/MODULO;
  Newx(eratSieveSegment, eratSize , SieveSegment);
  initSieve();
  
  crossWithKnownPrimes();

  
  while( sieveCurrentIdx < eratSize ) 
  {
    int nextPrimes[8];
    int numPrimes = primesInNextSegment( nextPrimes );
    int i;
    
    for( i = 0 ; i < numPrimes; i ++ )
    {
      int p = nextPrimes[ i ];
      pushPrimeInStock( p );
      crossSieve( p );
    }
    
    bigPrimeOffset += MODULO;
    sieveCurrentIdx++;
  }
  
  highestSievedValue = bigPrimeOffset;
  
  Safefree( eratSieveSegment );
}

int getNthPrime( int n )
{
  if( n >= numRegisteredPrimes )
    return 0;
  
  int stockIdx = n / PRIME_STOCK_SIZE;
  int idxInStock = n % PRIME_STOCK_SIZE;
    
  PrimeStock* pStock = chainedPrimeStock;
  
  int stock = 0;
  for( stock = 0 ; stock < stockIdx; stock ++ )
    pStock = pStock->nextStock;
    
  return  pStock->primes[ idxInStock ];
}

int getNumCalculatedPrimes()
{
  return numRegisteredPrimes;
}

int getHighestSievedValue()
{
  return highestSievedValue;
}

void freeStock( PrimeStock* pStock )
{
  if( pStock->nextStock != NULL )
  {
    freeStock( pStock->nextStock  );
    pStock->nextStock = NULL;
  }
  Safefree( pStock );
}

void freeSieve()
{
  freeStock( chainedPrimeStock );
}
END_C
1;
