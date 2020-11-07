#!/bin/bash

FILE=$1
mutt -a "${FILE}" -s $FILE -a "${FILE}" -- hirono2012@gmail.com < "${FILE}"
