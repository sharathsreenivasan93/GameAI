# -*- coding: utf-8 -*-
"""
Created on Sat Mar 19 14:42:40 2016

@author: sharathsreenivasan
"""
from random import randint

with open('/Users/sharathsreenivasan/Documents/workspace/GameAIHW2/src/BigGraph_copy.txt', 'r') as f:
    file_lines = [''.join([x.strip(), ",", '\n']) for x in f.readlines()]

with open("/Users/sharathsreenivasan/Documents/workspace/GameAIHW2/src/BigGraph_Final_test.txt", 'w') as f:
    f.writelines(file_lines) 

with open('/Users/sharathsreenivasan/Documents/workspace/GameAIHW2/src/BigGraph_Final_test.txt', 'r') as f:
    file_lines = [''.join([x.strip(), str(randint(1,500)), '\n']) for x in f.readlines()]

with open("/Users/sharathsreenivasan/Documents/workspace/GameAIHW2/src/BigGraph_Final.txt", 'w') as f:
    f.writelines(file_lines) 