#!/usr/bin/env bash
# base-speed.sh — Base conversion speed drill 
# (decimal <--> base-N)
set -euo pipefail IFS=$'\n\t' usage() { echo 
    "Usage: $0 <base (2–16)> [--reverse] 
    [--hard]" exit 1
}
# Check base
[[ $# -ge 1 ]] || usage base="$1" shift [[ 
"$base" =~ ^[0-9]+$ ]] || usage (( base >= 2 && 
base <= 16 )) || usage
# Flags
reverse_mode=0 hard_mode=0 for arg in "$@"; do 
    case "$arg" in
        --reverse) reverse_mode=1 ;; --hard) 
        hard_mode=1 ;; *) usage ;;
    esac done
# Config
digits=(0 1 2 3 4 5 6 7 8 9 A B C D E F) score=0 
total=0 time_limit=5 max_val=$((hard_mode ? 4095 
: 255))
echo "Base-$base Speed Drill" if (( reverse_mode 
)); then
    echo "Mode: Decimal → Base-$base" else echo 
    "Mode: Base-$base → Decimal"
fi [[ "$hard_mode" -eq 1 ]] && echo "Difficulty: 
HARD (0–4095)" || echo "Difficulty: EASY 
(0–255)" echo "You have ${time_limit}s per 
question. Press Ctrl+C to quit." echo
# Convert decimal to base-N string
to_base_n() { local num=$1 local base=$2 local 
    out="" while (( num > 0 )); do
        out="${digits[num % base]}$out" (( num 
        /= base ))
    done printf "%s\n" "${out:-0}"
}
# Normalize input (upper-case, strip spaces)
normalize() { echo "$1" | tr '[:lower:]' 
    '[:upper:]' | tr -d ' '
}
while true; do num=$((RANDOM % (max_val + 1))) 
    total=$((total + 1)) if (( reverse_mode )); 
    then
        echo -n "Decimal: $num → Base-$base: " 
        correct=$(to_base_n "$num" "$base")
    else input=$(to_base_n "$num" "$base") echo 
        -n "Base-$base: $input → Decimal: " 
        correct="$num"
    fi read -t "$time_limit" answer || 
    answer="timeout" answer=$(normalize 
    "$answer") if [[ "$answer" == "$(normalize 
    "$correct")" ]]; then
        echo "✔ Correct" score=$((score + 1)) 
    elif [[ "$answer" == "timeout" ]]; then
        echo "✖ Timeout (Answer: $correct)" else 
        echo "✖ Incorrect (Answer: $correct)"
    fi echo "Score: $score / $total" echo
done
