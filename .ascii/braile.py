
braille_start = 0x2800  # Unicode code point for Braille Pattern Blank

for i in range(256):
  codepoint = braille_start + i
  braille_char = chr(codepoint)
  print(braille_char, end="")  # Print with space separation
