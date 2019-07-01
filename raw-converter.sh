#! /bin/bash

while :
do
    th Training/raw_converter.lua 4
    ls /home/colonel/DeepHoldem/Data/TrainSamples/NoLimit/moved-files/ | wc -l
done