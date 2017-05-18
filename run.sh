#!/bin/sh

# update our shrubs
shrubbery_update taijitu
shrubbery_update magnolia
shrubbery_update hmdif

# jupyter
jupyter notebook --debug --NotebookApp.base_url=/analysis --NotebookApp.token=''