#!/bin/bash

sudo du --all --human-readable --max-depth=1 $1 | sort -h -r
