#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

# The equation a^2 + b^2 = c^2 can be solved introducing p > q both being odd
#    a = p * q
#    b = (p^2 - q^2)/2
#    c = (p^2 + q^2)/2
# Consider now that c is a square : c = d^2. Then we have
#      (p^2 + q^2)/2 = d^2
#  or  ((p+q)/2)^2 + ((p-q)/2)^2 = d^2
#      e^2 + f^2 = d^2 (with p = e + f, q = |e - f|)
# It is the same pythagorician equation and solution can be found : with i > j both being odd
#    e = i * j
#    f = (i^2 - j^2)/2
#    d = (i^2 + j^2)/2
# Finally the area of the triangle is : 
#    A = a * b / 2 
#    A = p * q *( p^2 - q^2 ) / 4
#    A = |e^2 - f^2| * e * f
#    A = 1/8 * | j^7*i -i^7*j + 7*i^5*j^3 - 7 * i^3*j^5 |
# If we look at the divisibility, by 3, 4, 7
# - Modulo 7 : j^7 = j [7], so A = 0 [7]
# - Modulo 3 : j^3 = j [3], so A = 0 [3]
# - Modulo 4 : 
#     A = (i^2 - j^2) * ( i^2 + 6*i^2*j^2 + j^2 ) / 8
#     i and j are both odd, (i^2 - j^2) is multiple of 4, 
#     and ( i^2 + 6*i^2*j^2 + j^2 ) is multiple of 8,
#     so A = 0 [4]
# And there is no such triangle with area not multiple of 6 or 28

print 0;