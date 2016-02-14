#include <math.h>
#include <map>
#include <libtbut/fastStrStream.h>
#include <libtbut/gtimer.h>
#include <iostream>

static int one()
{
  int sum(0);
  for (int i = 0; i < 1000; ++i) {
    if ((!(i % 3)) || (!(i % 5))) sum += i;
  }
  assert(sum == 233168);
  return sum;
}

static int two()
{
  std::vector<int> fibs(1000);
  fibs[0] = 1;
  fibs[1] = 2;
  int sum(fibs[1]);
  for(int i = 2; i < fibs.size(); ++i) {
    fibs[i] = fibs[i-1] + fibs[i-2];

    if (fibs[i]>4000000) break;

    if (!(fibs[i] % 2)) {
      sum += fibs[i];
    }
  }
  assert(sum == 4613732);
  return sum;
}

static bool isPalindromic(int number)
{
  FixedStrStream<16> stringVersion;
  stringVersion << number;
  const char *start = stringVersion.c_str();
  const char *end = start + stringVersion.size() - 1;
  for(;start < end; start++, end--) {
    if (*start != *end) return false;
  }
  return true;
}

static int four()
{
  int maxSoFar(0);
  for(int i = 1; i < 1000; ++i) {
    for(int j = 1; j < 1000; ++j) {
      const int product = i * j;
      if (isPalindromic(product)) {
	maxSoFar = std::max(maxSoFar, product);
      }
    }
  }
  assert(maxSoFar == 906609);
  return maxSoFar;
}

static int six()
{
  int sumOfSquares(0);
  for(int i = 1; i <= 100; ++i) {
    sumOfSquares += (i*i);
  }
  int sum(0);
  for(int i = 1; i <= 100; ++i) {
    sum += i;
  }
  const int squareOfSums(sum*sum);
  const int difference(squareOfSums - sumOfSquares);
  assert(difference == 25164150);
  return difference;
}

static int seven()
{
  std::vector<bool> ints(200000);
  for(int i = 0; i < ints.size(); ++i) { ints[i] = true; }
  for(int i = 2; i < sqrt(ints.size()); ++i) {
    if (ints[i]) {
      for(int j = i*2; j < ints.size(); j += i) {
	ints[j] = false;
      }
    }
  }
  int primeCount(0);
  for(int i = 1; i < ints.size(); i++) {
    if (ints[i]) primeCount++;
    if (primeCount == 10002) {
      assert(i == 104743);
      return i;
    }
  }
  return 0;
}

static int product5(const char *number)
{
  return 
    (number[0]-'0') *
    (number[1]-'0') *
    (number[2]-'0') *
    (number[3]-'0') *
    (number[4]-'0');
}

static int eight()
{
  const char number[] = 
    "73167176531330624919225119674426574742355349194934"
    "96983520312774506326239578318016984801869478851843"
    "85861560789112949495459501737958331952853208805511"
    "12540698747158523863050715693290963295227443043557"
    "66896648950445244523161731856403098711121722383113"
    "62229893423380308135336276614282806444486645238749"
    "30358907296290491560440772390713810515859307960866"
    "70172427121883998797908792274921901699720888093776"
    "65727333001053367881220235421809751254540594752243"
    "52584907711670556013604839586446706324415722155397"
    "53697817977846174064955149290862569321978468622482"
    "83972241375657056057490261407972968652414535100474"
    "82166370484403199890008895243450658541227588666881"
    "16427171479924442928230863465674813919123162824586"
    "17866458359124566529476545682848912883142607690042"
    "24219022671055626321111109370544217506941658960408"
    "07198403850962455444362981230987879927244284909188"
    "84580156166097919133875499200524063689912560717606"
    "05886116467109405077541002256983155200055935729725"
    "71636269561882670428252483600823257530420752963450";

  int maxSoFar(0);
  for(int i = 0; i < sizeof(number)-5; i++) {
    const int product(product5(number + i));
    maxSoFar = std::max(maxSoFar, product);
  }
  assert(maxSoFar == 40824);
  return maxSoFar;
}


int main()
{
  std::map<int, int> times;
  long long sum(0);
  const int count = 100;
  for(int i = 0; i < count; ++i) {
    GTimer iteration;
    sum += eight();
    times[iteration.elapsedNanoSec()]++;
  }
  for(auto &p : times) {
    std::cout << p.first << ' ' << p.second << std::endl;
  }
  std::cout << "Answer: " << sum/count << std::endl;
}
