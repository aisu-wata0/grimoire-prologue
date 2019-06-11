import matplotlib.pyplot as plt
import datetime
import string

import argparse

def load_data(pathname):
   dates = []
   values = []
   with open(pathname) as file:
      for line in file:
         line = line.strip().split(' ')
         date = str(line[0])
         value = int(line[1])

         printable = set(string.printable)
         date = ''.join(filter(lambda x: x in printable, date))
         date = datetime.datetime.strptime(
             date, '%Y_%m_%d').date()

         dates.append(date)
         values.append(value)
   return dates, values


if __name__ == "__main__":
   plt.style.use('dark_background')
   # Instantiate the parser
   parser = argparse.ArgumentParser(description='Plots a file of dates and quantities (each line is "2019_4_28 9")')
   parser.add_argument('pathname', help='path to the file')

   args = parser.parse_args()

   dates, values = load_data(pathname=args.pathname)
   plt.plot(dates, values)
   plt.grid(b=True, which='major', linestyle='dashed', alpha=0.2)
   plt.ylabel('quantity')
   plt.xlabel('days')
   plt.show()
