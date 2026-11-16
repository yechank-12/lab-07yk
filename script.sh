#!/bin/bash

# 기존 결과 폴더 지우기
rm -rf Testcase1Diff Testcase2Diff Testcase3Diff Testcase4Diff

# Testcase1 ~ 4 반복
for i in 1 2 3 4; do
    # 폴더 안의 모든 .1.txt 파일 하나씩 꺼내기
    for file1 in Testcase$i/*.1.txt; do
        # 1. 비교할 두 번째 파일 이름 지정 (글자만 바꿈, 파일 생성 X)
        file2="${file1/.1.txt/.2.txt}"

        # 2. 저장할 결과 파일 이름 지정 (예: Version1.1.txt -> Version1Diff.txt)
        name=$(basename "$file1")
        out_name="${name/.1.txt/Diff.txt}"

        # 3. 두 파일 비교해서 다르면(!) Diff 폴더 만들고 결과 저장
        if ! diff -u "$file1" "$file2" > /dev/null; then
            mkdir -p "Testcase${i}Diff"
            diff -u "$file1" "$file2" > "Testcase${i}Diff/$out_name"
        fi
    done
done