#!/bin/bash

# Constants
URL="https://obs.akdeniz.edu.tr/oibs/bologna/progCourses.aspx?lang=en&curSunit=1040"

spanIdBasePrefix="grdBolognaDersler_lbl"
extractedFields=(DersKod DersAd AKTS)

semester1Ids=(3 4 5 6 7 8 9 10)
semester2Ids=(15 16 17 18 19 20 21 22)
semester3Ids=(27 28 29 30 31)
semester4Ids=(39 40 41 42 43 44)
semester5Ids=(52 53 54 55)
semester6Ids=(65 66 67 68 69 70 71)
semester7Ids=(81 82 83 84 85)
semester8Ids=(98 99 100 101)

semester1FileName="Semester1.txt"
semester2FileName="Semester2.txt"
semester3FileName="Semester3.txt"
semester4FileName="Semester4.txt"
semester5FileName="Semester5.txt"
semester6FileName="Semester6.txt"
semester7FileName="Semester7.txt"
semester8FileName="Semester8.txt"

# Functions
function writeSemesterElementToFile() {
  response="$1"
  fileName="$2"
  spanId="$3"
  
  innerHTML=$(echo "$response" | grep -oP "<span id=\"$spanId\">[\s\S]*?</span>" | sed 's/<[^>]*>//g')
  
  if [[ "$innerHTML" =~ ^[0-9]+$ ]]; then
    echo "$innerHTML" >> "$fileName" 
  else
    echo -n "$innerHTML  " >> "$fileName" 
  fi
}

function writeSemesterElementsToFile() {
  response="$1"
  fileName="$2"
  shift
  shift
  ids=("$@")
  
  for id in "${ids[@]}"
    do
    for extractedField in "${extractedFields[@]}"
      do
        spanId="$spanIdBasePrefix${extractedField}_${id}"
        writeSemesterElementToFile "$response" "$fileName" "$spanId"
    done
  done
}

# Main Function
response=$(curl -s $URL)

writeSemesterElementsToFile "$response" "$semester1FileName" "${semester1Ids[@]}"
writeSemesterElementsToFile "$response" "$semester2FileName" "${semester2Ids[@]}"
writeSemesterElementsToFile "$response" "$semester3FileName" "${semester3Ids[@]}"
writeSemesterElementsToFile "$response" "$semester4FileName" "${semester4Ids[@]}"
writeSemesterElementsToFile "$response" "$semester5FileName" "${semester5Ids[@]}"
writeSemesterElementsToFile "$response" "$semester6FileName" "${semester6Ids[@]}"
writeSemesterElementsToFile "$response" "$semester7FileName" "${semester7Ids[@]}"
writeSemesterElementsToFile "$response" "$semester8FileName" "${semester8Ids[@]}"
