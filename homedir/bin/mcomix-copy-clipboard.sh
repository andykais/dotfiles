#!/bin/bash

# do it without escaping like bash
# echo -n "$1" | xsel --clipboard

# do it like bash does <tabbed> filenames
printf '%q' "$1" | xsel --clipboard
