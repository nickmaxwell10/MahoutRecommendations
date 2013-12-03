#!/usr/bin/python

from operator import itemgetter
import sys

# input comes from STDIN
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()

    # parse the input we got from mapper.py
    word, score = line.split('\t', 1)
    user_id, profile_id = word.split('_', 1)
    print '%s,%s,%s' % (user_id, profile_id, score)
