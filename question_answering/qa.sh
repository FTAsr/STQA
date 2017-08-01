#!/usr/bin/env bash
QFILE=$1

cwd=$(pwd)
root_dir="tests"

load_path="$cwd/$root_dir/$QFILE"

cd bi-att-flow
python qa.py $load_path

