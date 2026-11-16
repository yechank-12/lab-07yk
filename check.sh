#!/bin/bash

count_fail=0

for i in 1 2 3 4; do
    tc_fail=0
    is_diff=0
    diff_dir="Testcase${i}Diff"

    for file1 in Testcase$i/*.1.txt; do
        file2="${file1/.1.txt/.2.txt}"
        name=$(basename "$file1")
        out_file="$diff_dir/${name/.1.txt/Diff.txt}"

        if ! diff -u "$file1" "$file2" > /dev/null; then
            is_diff=1
            if [ ! -f "$out_file" ] || ! diff -q <(diff -u "$file1" "$file2" | tail -n +3) <(tail -n +3 "$out_file") > /dev/null; then
                tc_fail=1
            fi
        else
            if [ -f "$out_file" ]; then
                tc_fail=1
            fi
        fi
    done

    if [ $is_diff -eq 1 ] && [ ! -d "$diff_dir" ]; then
        tc_fail=1
    fi
    if [ $is_diff -eq 0 ] && [ -d "$diff_dir" ]; then
        tc_fail=1
    fi

    if [ $tc_fail -eq 0 ]; then
        echo "Testcase$i: PASS"
    else
        echo "Testcase$i: FAIL"
        count_fail=1
    fi
done

exit $count_fail