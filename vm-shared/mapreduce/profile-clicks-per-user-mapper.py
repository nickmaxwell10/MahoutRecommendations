#!/usr/bin/python

import sys

# input comes from STDIN (standard input)
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    # split the line into words
    words = line.split(',')
    url = words[0]
    paths = url.split('/')
    profile_id = paths[3]
    user_id = words[1]
    key = profile_id + '_' + user_id
    # increase counters
    print '%s\t%s' % (key, 1)
