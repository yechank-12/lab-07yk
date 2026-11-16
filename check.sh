#!/bin/bash

count_fail=0

# Testcase1 ~ 4 모두 검사 (중간에 실패해도 끝까지 진행)
for i in 1 2 3 4; do
    tc_fail=0
    is_diff=0
    diff_dir="Testcase${i}Diff"

    # 1. 해당 Testcase 안의 모든 파일 쌍 검사
    for file1 in Testcase$i/*.1.txt; do
        file2="${file1/.1.txt/.2.txt}"
        name=$(basename "$file1")
        out_file="$diff_dir/${name/.1.txt/Diff.txt}"

        # 두 파일 내용이 다른 경우
        if ! diff -u "$file1" "$file2" > /dev/null; then
            is_diff=1
            # 결과 파일이 없거나, 3번째 줄부터 비교한 내용이 실제 diff -u와 다르면 FAIL
            if [ ! -f "$out_file" ] || ! diff -q <(diff -u "$file1" "$file2" | tail -n +3) <(tail -n +3 "$out_file") > /dev/null; then
                tc_fail=1
            fi
        # 두 파일 내용이 같은 경우
        else
            # 결과 파일이 존재하면 안 됨
            if [ -f "$out_file" ]; then
                tc_fail=1
            fi
        fi
    done

    # 2. 폴더 존재 여부 검사
    if [ $is_diff -eq 1 ] && [ ! -d "$diff_dir" ]; then
        tc_fail=1
    fi
    if [ $is_diff -eq 0 ] && [ -d "$diff_dir" ]; then
        tc_fail=1
    fi

    # 3. 정확한 형식으로 PASS / FAIL 출력
    if [ $tc_fail -eq 0 ]; then
        echo "Testcase$i: PASS"
    else
        echo "Testcase$i: FAIL"
        count_fail=1
    fi
done

exit $count_fail