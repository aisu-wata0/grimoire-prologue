
import itertools


def combineWords(filepath, combination_sz=2):
   """
   the file in filepath has words on each line, e.g.
   $ cat words.txt
   word1
   wordn

   returns a generator of lists (of size 'combination_sz') of words (in the file)
   with the all the combinations of the words in the file
   e.g. for combination_sz=2:
   [[word00,word01], ..., [wordN0,wordN1]]
   """
   words = []
   with open(filepath) as file:
      for line in file:
         if len(line) > 1:
            words.append(line[:-1])

   return itertools.permutations(words, combination_sz)


def printCombinedWords(filepath, combination_sz=2, sep='.'):
   for name in combineWords(filepath):
      comb = ''
      for i in range(combination_sz - 1):
         comb += name[i]
         comb += '.'
      comb += name[-1]
      print(comb)
