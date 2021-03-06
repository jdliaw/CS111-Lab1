#!/bin/bash

function createFiles () {
    touch a
    printf "Hello, World!\ncat\napple\nbrandon" > a
    touch b
    touch c
    #printf "apple\nbrandon\ncat\nHello, World!" > c
    touch d
    touch e
    touch f
    touch g
    printf "Alex\nJennifer\nBrandon\nKoh\nJames\nDayanara" > g
    touch h
    printf "appendMe" > h
    touch i
    touch j
    touch v
    echo "--wronly b" > v
}

function deleteFiles () {
    rm -rf a
    rm -rf b
    rm -rf c
    rm -rf d
    rm -rf e
    rm -rf f
    rm -rf v
    rm -rf g
    rm -rf h
    rm -rf i
    rm -rf j
}

createFiles

# Test case 1:
./simpsh --rdonly a --wronly b --wronly c --command 0 1 2 cat
cmp --silent a b || echo "Test case 1 didn't work"

sort a > c
# Test case 2:
./simpsh --rdonly a --wronly b --wronly c --command 0 1 2 sort
cmp --silent c b || echo "Test case 2 didn't work"

# Test case 3:
./simpsh --rdonly a --verbose --wronly b > d
cmp --silent d v || echo "Test case 3 didn't work"

printf "abcdefghijklmnop" > e
# Test case 4:
./simpsh --rdonly e --wronly f --rdonly a --command 0 1 2 tr abc ABC
tr abc ABC < e > v
cmp --silent f v || echo "Test case 4 didn't work"

# Test case 5:
./simpsh --rdonly a b 2> /dev/null
if [ $? -ne 1 ]
then
    echo "Test case 5 didn't work"
fi

# Test case 6:
./simpsh --rdonly a --command 0 1 2 2> /dev/null
if [ $? -ne 1 ]
then
    echo "Test case 6 didn't work"
fi

# Test case 7:
./simpsh --verbose a --rdonly b 2> /dev/null
if [ $? -ne 1 ]
then
    echo "Test case 7 didn't work"
fi

# Test case 8:
./simpsh --command 0 b 2 echo hi 2> /dev/null
if [ $? -ne 1 ]
then
    echo "Test case 8 didn't work"
fi

# Test case 9:
./simpsh --rdonly a --wronly b --rdwr t --command 0 1 1 cat --command 0 1 1 tr A-Z a-z --wait
if [ $? -ne 1 ]
then
    echo "Test case 9 didn't work"
fi

# Test case 10:
./simpsh \
  --rdonly g \
  --pipe \
  --pipe \
  --creat --trunc --wronly i \
  --creat --append --wronly j \
  --command 3 5 6 tr A-Z a-z \
  --command 0 2 6 sort \
  --command 1 4 6 cat h - \
  --wait
if [ $? -ne 0 ]
then
    echo "Test case 10 didn't work"
fi

# Test case 11: testing --catch
./simpsh --rdonly a --wronly b --wronly c --command 0 1 2 cat a --catch 11 --abort
if [ $? -ne 11 ]
then
    echo "Test case 11 for --catch didn't work"
fi

# Test case 12: testing --ignore
./simpsh --rdonly a --wronly b --wronly c --command 0 1 2 cat a --ignore 11 --abort
if [ $? -ne 0 ]
then
    echo "Test case 12 for --ignore didn't work"
fi
    
deleteFiles
