#!/bin/bash

sudo du --all --human-readable --max-depth=1 -L $1 | sort -h -r
