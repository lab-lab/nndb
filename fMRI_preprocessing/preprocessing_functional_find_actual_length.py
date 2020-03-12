g# Author: Flomeister
# Best analysis in the entire universe
import sys
import numpy as np
import json

def open_file(path):
    content=[]
    with open(path, 'r') as open_file:
        for i, line in enumerate(open_file):
            content.append(line.strip())
    return content


# returns periods, their duration and details to later add timepoints to them
def construct_periods(landmarks):
    periods = []
    c=1
    for i, timepoint in enumerate(landmarks):
        # the line with a starting time point will always end in a t
        # take the difference in seconds from the next pause till this starting point
        # update the difference with the ms and put everything in ms
        if timepoint[-1] =='t':
            seconds = int(landmarks[i+1][:10]) - int(timepoint[:10])
            full_duration = seconds *1000 - (1000-int(timepoint[10:13])) + int(landmarks[i+1][10:13])
            periods.append({'period': c, 'duration': full_duration, 'start_sec': int(timepoint[:10]), 'start_ms': timepoint[10:13], 'stop_sec': int(landmarks[i+1][:10]),'stop_ms': int(landmarks[i+1][10:13]) ,'content': []})
            c+=1
    print('Final periods--------------------------')
    for period in periods:
        print('period: %d' % period['period'])
        print('duration in ms: %d' % period['duration'])
        print('--------------')
    return periods


def main(args):
    current_time = open_file(args[0])
    current_time = current_time[1:]
    landmarks = open_file(args[1])
    landmarks = landmarks[1:]
    periods = construct_periods(landmarks)

    
if __name__ == '__main__':
    main(sys.argv[1:])
