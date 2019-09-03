#!/bin/bash
# 2019, by ichthyosaurus (https://github.com/ichthyosaurus)

app="harbour-dictionary"

for i in 86 108 128 172 256; do
    mkdir -p "../icons/${i}x$i"
    inkscape -z -e "../icons/${i}x$i/$app.png" -w "$i" -h "$i" "$app.svg"
done

mkdir -p "../images"
inkscape -z -e "../images/${app#harbour-}.png" -w "860" -h "860" "$app.svg"
inkscape -z -e "../images/background.png" -w "860" -h "860" "$app.svg"
