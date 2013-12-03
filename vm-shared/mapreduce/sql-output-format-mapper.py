#!/usr/bin/python

import sys

# input comes from STDIN (standard input)
for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()
    tokens = line.split('\t')
    user_id = tokens[0]
    profile_id_with_scores = tokens[1].strip('[]\n').split(',')
    for profile_id_score in profile_id_with_scores:
      recommendations = profile_id_score.split(':')
      profile_id = recommendations[0]
      score = recommendations[1]
      key = user_id + '_' + profile_id
      print '%s\t%s' % (key, score)
