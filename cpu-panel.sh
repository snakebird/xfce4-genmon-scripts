#!/usr/bin/env bash

# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional icon to display before the text
# Insert the absolute path of the icon
# Recommended size is 24x24 px
readonly ICON="${DIR}/icons/chart-bar.png"

declare -a CPU_ARRAY=($(awk '/MHz/{print $4}' /proc/cpuinfo | cut -f1 -d"."))
NUM_OF_CPUS="${#CPU_ARRAY[@]}"

#CPU0=$(awk '/MHz/{print $4}' /proc/cpuinfo | cut -f1 -d"." | sed -n 1p)

# Tooltip
MORE_INFO="<tool>"
MORE_INFO+="┌ $(grep "model name" /proc/cpuinfo | cut -f2 -d ":" | sed -n 1p | sed -e 's/^[ \t]*//')\n"
STEP=0
for CPU in "${CPU_ARRAY[@]}"; do
  STDOUT=$(( STDOUT + CPU ))
  MORE_INFO+="├─ CPU ${STEP}: ${CPU}\n"
  let STEP+=1
done
MORE_INFO+="└─ Temperature: $(sensors | awk '/[Pp]ackage/{print $4}')"
MORE_INFO+="</tool>"
STDOUT=$(( STDOUT / NUM_OF_CPUS ))
STDOUT=$(awk '{$1 = $1 / 1024; printf "%.2f%s", $1, " GHz"}' <<< "${STDOUT}")

# Uncomment to activate cpu0 calculation.
#STDOUT=$(awk '{$1 = $1 / 1024; printf "%.2f%s", $1, " GHz"}' <<< "${CPU_ARRAY[0]}")

# Panel
if [ -f "${ICON}" ]; then
  INFO="<img>${ICON}</img>"
  INFO+="<txt>"
else
  INFO="<txt>"
fi
INFO+="${STDOUT}"
INFO+="</txt>"

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"
