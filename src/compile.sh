#!/usr/bin/env bash
typst c main.typ
DATE=$(date +"%d-%m-%Y")
mv main.pdf "${DATE}-heuer-leon-ba.pdf"
