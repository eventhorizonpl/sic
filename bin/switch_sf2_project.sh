#!/bin/sh

PROJECT=$1
PROJECT_DIR=/home/michal/projects/$PROJECT
PR=/home/michal/projects/sf2-project

if [ ! -d $PROJECT_DIR ] || [ "$PROJECT" == "project" ]
then
    echo Zły projekt
    exit 1
fi

if [ -e $PR ]
then
    rm $PR
fi

ln -s $PROJECT_DIR $PR
