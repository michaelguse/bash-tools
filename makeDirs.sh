#!/bin/bash
for file in *.gz 
do
    mkdir -v -p ${file:0:10}
    mv -v ${file} ${file:0:10}/${file}
done