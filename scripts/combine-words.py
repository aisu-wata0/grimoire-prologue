
import itertools

# the file has words on each line, the last line is an empty line, e.g.
# word1
# wordn
# 

comb_size = 2
filename = 'wordslite.txt'

words = []

with open(filename) as file:
   for line in file:
      if len(line) > 1:
         words.append(line[:-1])

for name in itertools.permutations(words, comb_size):
   comb = ''
   for i in range(comb_size -1):
      comb += name[i]
      comb += '.'
   comb += name[comb_size-1]
   print(comb)

