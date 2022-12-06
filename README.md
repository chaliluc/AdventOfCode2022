# AdventOfCode2022
This is my take on the Advent of Code challenge 2022 https://adventofcode.com/

Being an ABAPer, this is of course in ABAP.

Enjoy!



## Files:
**zcl_lc_adv2022.abap** -> Helper class for daily challenges.

**zlc_advent22_day1.abap** -> Day 1 challenge.
In this report I leveraged ABAP internal tables and let them do the work. The working table is a sorted table with the unique key being an elf number that is incremented on every empty line in the puzzle input. The number of calories is simply aggregated using the COLLECT ABAP statement. 
The resulting aggregated data is then sorted by calories to identify the one(s) with the most calories.

**zlc_advent22_day2.abap** -> Day 2 challenge.
Don't look for a clever solution in this one. I approached this challenge pragmatically with basic string parsing, case statements and a few ternary operators. 

**zlc_advent22_day3.abap** -> Day 3 challenge.
Some more basic string processing to solve this one. 

**zlc_advent22_day4.abap** -> Day 4 challenge.
For the first part of this challenge I wanted to use the OVERLAY keyword in ABAP that I stumbled accross while looking for something else. To make use of OVERLAY I built very visual string representations of the ranges and overlayed one on top of the other. If the resulting string is the same with the overlay as it was before, the second string is fully contained in the first one. 
For the second part (partial overlap) I simply inserted in an internal table with a unique key all numbers of the first range. With that done, I inserted the numbers of the second range. As soon as inserting a number of the second range raises an error, there is an overlap.

**zlc_advent22_day5.abap** -> Day 5 challenge.
That one was also achieved with simple internal tables manipulations. The biggest challenge was the parsing of the input. It would have been probably easier with other languages, but my goal is to complete as much challenges as possible with ABAP. 

**zlc_advent22_day6.abap** -> Day 6 challenge.
Yet another one achieved with the use of an internal table with a unique key. As soon as one of the characters in the sequence is not unique (SY-SUBRC = 4 after inserting the character) the loop is stoped, and we move on to the next input character.
