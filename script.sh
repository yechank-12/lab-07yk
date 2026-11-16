#!/bin/bash

rm -rf Testcase1Diff Testcase2Diff Testcase3Diff Testcase4Diff

for i in 1 2 3 4; do
    for file1 in Testcase$i/*.1.txt; do
        file2="${file1/.1.txt/.2.txt}"

        name=$(basename "$file1")
        out_name="${name/.1.txt/Diff.txt}"

        if ! diff -u "$file1" "$file2" > /dev/null; then
            mkdir -p "Testcase${i}Diff"
            diff -u "$file1" "$file2" > "Testcase${i}Diff/$out_name"
        fi
    done
done