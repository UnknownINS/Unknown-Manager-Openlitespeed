#!/bin/bash
textBlack() {
  echo -e "\e[30m${1}\e[0m"
}
textRed() {
  echo -e "\e[31m${1}\e[0m"
}
textGreen() {
  echo -e "\e[32m${1}\e[0m"
}
textYellow() {
  echo -e "\e[33m${1}\e[0m"
}

textBlue() {
  echo -e "\e[34m${1}\e[0m"
}

textMagenta() {
  echo -e "\e[35m${1}\e[0m"
}

textCyan() {
  echo -e "\e[36m${1}\e[0m"
}

textGray() {
  echo -e "\e[90m${1}\e[0m"
}
