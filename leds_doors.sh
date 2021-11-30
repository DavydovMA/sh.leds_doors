#!/bin/sh
# DavydovMA~mAdavydov 2013040600 {
SOFT_FILE="leds_doors.sh"
SOFT_NAME="sh.leds_doors"
SOFT_VERSION="21.11"
SOFT_COPYRIGHT="Copyright (C) 1990-2021"
SOFT_AUTHOR="DavydovMA~mAdavydov"
SOFT_URL="http://domain"
SOFT_EMAIL="dev-sh@domain"
SOFT_LICENSE="GPLv3+"

############# #### ######
# preset:               #
#
# time wait interval :
time_pb="" # prefix begin
time_pb="0." # prefix begin
time_pe=""   # prefix end
time_ta="${time_pb}1${time_pe}"  # [1] (.) to4ka
time_ti="${time_pb}3${time_pe}"  # [3] (-) tire
time_wi="${time_pb}1${time_pe}"  # [1] in
time_wc="${time_pb}3${time_pe}"  # [3] char (-time_wi)
time_ww="${time_pb}7${time_pe}"  # [7] word (-time_wi -time_wc)
# default char :
string_ta="."  # (.) to4ka
string_ti="-"  # (.) tire
space_max="7"  # length space code max (need +1)
# table format :
#  1 - char
#  | - delimiter
#  2 - code
#  | - delimiter future
table_morse_allat="
A|.-    |
B|-...  |
C|-.-.  |
D|-..   |
E|.     |
F|..-.  |
G|--.   |
H|....  |
I|..    |
J|.---  |
K|-.-   |
L|.-..  |
M|--    |
N|-.    |
O|---   |
P|.--.  |
Q|--.-  |
R|.-.   |
S|...   |
T|-     |
U|..-   |
V|...-  |
W|.--   |
X|-..-  |
Y|-.--  |
Z|--..  |
"
table_morse_digit="
1|.---- |
2|..--- |
3|...-- |
4|....- |
5|..... |
6|-.... |
7|--... |
8|---.. |
9|----. |
0|----- |
"
table_morse_punct="
_  |......|
,  |.-.-.-|
!  |--..--|
?  |..--..|
;  |-.-.-.|
:  |---...|
~  |-....-|
+  |.-.-. |
() |-.--.-|
\" |.-..-.|
'  |.----.|
#  |-..-. |
/  |-..-. |
"
table_morse_alrus="
А |.-    |
Б |-...  |
В |.--   |
Г |--.   |
Д |-..   |
ЕЁ|.     |
Ж |...-  |
З |--..  |
И |..    |
Й |.---  |
К |-.-   |
Л |.-..  |
М |--    |
Н |-.    |
О |---   |
П |.--.  |
Р |.-.   |
С |...   |
Т |-     |
У |..-   |
Ф |..-.  |
Х |....  |
Ц |-.-.  |
Ч |---.  |
Ш |----  |
Щ |--.-  |
Ъ |.--.-.|
Ы |-.--  |
Ь |-..-  |
Э |..-.. |
Ю |..--  |
Я |.-.-  |
"
#ЪЬ|-..-  |
#Ъ |.--.-.|
#ЫЬ|-.--  |
#Э |...-...|
# FIXME {
#table_morse_algerke="
#"
#table_morse_alveylamorse="
#"
#table_morse_other="
#  |-.-.-     |Общий вызов
#  |..--.     |Знак военного свода
#  |-..-..-   |Начало передачи/Знак шифра
#  |-...-     |Знак разделительный
#  |......    |Знак ошибки
#  |----------|Знак молчания
#  |.-.-.     |Знак окончания
#  |---.-     |Не могу читать вашей передачи
#  |-.---     |Принял ясно, но не могу расшифровать
#  |.-...     |Ждать
#  |...-.     |Понял
#  |.--.---   |Готовность к приему
#  |.-.-.-.-.-|Начало действия
#  ||
#"
# } FIXME
#
############# #### ######

############# #### ######
# Function: func_copy { #
#
func_copy(){
  echo ""
  echo "${SOFT_NAME} version ${SOFT_VERSION}, ${SOFT_COPYRIGHT} Free Software ${SOFT_AUTHOR}"
  echo "URL\t: ${SOFT_URL}"
  echo "e-mail\t: ${SOFT_EMAIL}"
  echo ""
}
#
# } Function: func_copy #
############# #### ######
#
############# #### ######
# Function: func_help { #
#
func_help(){
  echo ""
  echo "Usage:\t\t${0} <file|string>"
  echo "Options:"
  echo "\tfile   : path to file [charcter|text|binary]"
  echo "\tstring : string with text"
  echo ""
}
#
# } Function: func_help #
############# #### ######
#
############# #### ######
# Function: func_led {  #
# in:
#  ${1}  : led - 1 (+|-)
#  ${2}  : led - 2 (+|-)
#  ${3}  : led - 3 (+|-)
#
func_led(){
  for line_tty in /dev/tty[1-8]; do  # loop tty on {
    setleds -D "${1}num" < $line_tty
    setleds -D "${2}caps" < $line_tty
    setleds -D "${3}scroll" < $line_tty
  done  # } loop tty on
}
#
# } Function: func_led  #
############# #### ######
#
############# #### ######
# Function: func_rs {   #
#
func_rs(){
  func_led - - -
  sleep ${time_wi}  # wait tita
}
#
# } Function: func_ta   #
############# #### ######
#
############# #### ######
# Function: func_ta {   #
#
func_ta(){
  func_led - + -
  sleep ${time_ta}  # wait ta
  func_rs  # reset led & wait tita
}
#
# } Function: func_ta   #
############# #### ######
#
############# #### ######
# Function: func_ti {   #
#
func_ti(){
  func_led + + +
  sleep ${time_ti}  # wait ti
  func_rs  # reset led & wait tita
}
# } Function: func_ti   #
############# #### ######
#
############# #### ######
# Function: func_mc {   #
# in:
#  ${1}  : string of morse code
#
func_mc(){
  mc_string_code=`echo "${1}" | tr -d [:blank:]`
  mc_string_length=`echo "${mc_string_code}" | wc -c`  # +1 null
  mc_string_pos="1"
  while [ "${mc_string_length}" != "${mc_string_pos}" ] ; do  # loop code {
    mc_string_tati=`echo "${mc_string_code}" | cut -c ${mc_string_pos}`
    echo -n "${mc_string_tati}"  # print tati
    if [ "${mc_string_tati}" = "." ] ; then  # code to4ka
      func_ta
    fi
    if [ "${mc_string_tati}" = "-" ] ; then  # code tire
      func_ti
    fi
    mc_string_pos=`expr ${mc_string_pos} + 1`
  done  # } loop code
  while [ ${mc_string_length} -lt ${space_max} ] ; do  # loop space {
    echo -n " "
    mc_string_length=`expr ${mc_string_length} + 1`
  done  # } loop space
# OFF #  echo -n "] "
  sleep ${time_wc}  # wait char interval + time_wi
}
#
# } Function: func_mc   #
############# #### ######
#
############# #### ######
# Function: func_tc {   #
# in:
#  ${1}  : char
#
func_tc(){
  if [ "${1}" = " " ] ; then  # in { [space]
    echo "[${1}|_|~ sp ~] "
    sleep ${time_ww}  # wait word interval _ time_wc + time_wi
  else  # ~ in [other]
    tc_char_code=""
    tc_char_in=`echo "${1}" | tr -s ".-" "_~"  | tr -s [:lower:] [:upper:] `  # . as _; - as ~
    tc_char_code=`echo "${table_morse_allat}" | grep "${tc_char_in}" | cut -d \| -f 2`  # all letters
    if [ "${tc_char_code}" = "" ] ; then  # all digits
      tc_char_code=`echo "${table_morse_digit}" | grep "${tc_char_in}" | cut -d \| -f 2`
    fi
    if [ "${tc_char_code}" = "" ] ; then  # all control
      tc_char_code=`echo "${table_morse_punct}" | grep "${tc_char_in}" | cut -d \| -f 2`
    fi
    if [ "${tc_char_code}" = "" ] ; then  # ru_RU:UTF-8
      tc_char_in=`echo "${tc_char_in}" | tr -s "абвгдеёжзийклмнопрстуфхцчшщъыьэюя" "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ" `
      tc_char_code=`echo "${table_morse_alrus}" | grep "${tc_char_in}" | cut -d \| -f 2`
    fi
# OFF #    if [ "${tc_char_code}" = "" ] ; then  # special for sh {
# OFF #      if [ "${tc_char_in}" = "\"" ] ; then  # \" {
# OFF #      tc_char_in="\""
# OFF #      tc_char_code=".-..-."
# OFF #     fi  # } \"
# OFF #    fi  # } special for sh {
    if [ "${tc_char_code}" != "" ] ; then  # tc_char_code {
      echo -n "[${1}|${tc_char_in}|"
      func_mc "${tc_char_code}"
      echo -n "] "
    else  # ~ tc_char_code - skip
      echo -n "[*|*|~skip~] "
      sleep ${time_wc}  # wait char interval + time_wi
    fi  # } tc_char_code {
  fi  # } in
}
#
# } Function: func_tc   #
############# #### ######
#
############# #### ######
# Function: func_ts {   #
# in:
#  ${1}  : string
#
func_ts(){
  ts_tring_length=`echo "${1}" | wc -c`  # +1 null
  ts_tring_pos="1"
  while [ "${ts_tring_length}" != "${ts_tring_pos}" ] ; do  # loop string {
    ts_char=`echo "${1}" | cut -c ${ts_tring_pos}`
    func_tc "${ts_char}"
    ts_tring_pos=`expr ${ts_tring_pos} + 1`
  done  # } loop string
}
#
# } Function: func_ts   #
############# #### ######

############# #### ######
# main {                #
#
func_copy

if [ "${#}" != "1" ] ; then  # need help
  func_help
else  # OK : select type file
  func_rs  # leds reset
  if [ -c "${1}" ] ; then
#  True if file exists and is a character special file.
#  File is character print as char or hex
    echo "found	: [file] [character]"
     from_file_byte="ganoxyu"  # for init loop
    while [ "${from_file_byte}" != "" ] ; do  # loop byte {
      from_file_byte=`cat "${1}" | od - -A n -N 1 -t x1z`  # char or code
      from_file_char=`echo "${from_file_byte}" | cut -d ">" -f 2 | cut -d "<" -f 1 `
      from_file_hex=`echo "${from_file_byte}" | tr -d "[:space:]" | cut -d ">" -f 1 | tr -t "[:lower:]" "[:upper:]"`
      if [ "${from_file_char}" != "." -o "${from_file_hex}" = "2E" ] ; then
        func_tc "${from_file_char}"
      else
        from_file_byte="${from_file_hex}"
        func_ts "${from_file_hex} "  # end space as wait word
      fi
    done  # } loop byte
  elif [ -r "${1}" -a -f "${1}"  ] ; then
#  True if file exists and is readable.
    status_text=`file -i -e text "${1}" | grep -E "ascii|utf"`
    if [ "${status_text}" != "" ] ; then  # text
#  File is text print as string
      echo "found	: [file] [text]"
      cat "${1}" | while read from_file_string ; do  # loop string {
        func_ts "${from_file_string} "  # end space as wait word
      done  # } loop string
    else  # binary
#  File as binary print as hex dump
      echo "found	: [file] [binary]"
      od "${1}" -A x -t x1 | while read from_file_string ; do  # loop string {
        func_ts "${from_file_string} "  # end space as wait word
      done  # } loop string
    fi
  else
#  Other print as single string
    echo "found	: [string]"
    func_ts "${1} "  # end space as wait word
  fi
  func_rs  # leds reset
  echo
fi

echo "------------- ---- ------"

# } main                #
############# #### ######


# } DavydovMA~mAdavydov 2021113000
#

# ------------- ---- ------
#
# Copyright (C) 1990-2021 Free Software DavydovMA~mAdavydov
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
