#!/bin/bash

# ===== CONFIGURABLE PARAMETERS =====
NUM_WORDS=4
NUM_SPECIALS=2
NUM_DIGITS=2
ALLOWED_SPECIALS='!@#%&*'
SEPARATORS='-_:.'

# ===== FUNCTION: Get random characters from a set =====
rand_chars() {
    local set="$1"
    local count="$2"
    local output=""
    for ((i = 0; i < count; i++)); do
        rand_index=$(( RANDOM % ${#set} ))
        output+="${set:$rand_index:1}"
    done
    echo "$output"
}

# ===== GET RANDOM WORDS =====
WORDS=$(curl -s "https://random-word-api.vercel.app/api?words=$NUM_WORDS" | jq -r '.[]')

# Convert to array
readarray -t WORD_ARRAY <<< "$WORDS"

# ===== CHOOSE RANDOM SEPARATOR =====
SEP_INDEX=$(( RANDOM % ${#SEPARATORS} ))
SEP="${SEPARATORS:$SEP_INDEX:1}"

# ===== JOIN WORDS WITH SEPARATOR =====
JOINED_WORDS=$(IFS="$SEP"; echo "${WORD_ARRAY[*]}")

# ===== BUILD PASSPHRASE =====
PREFIX_SPECIALS=$(rand_chars "$ALLOWED_SPECIALS" "$NUM_SPECIALS")
PREFIX_DIGITS=$(rand_chars "0123456789" "$NUM_DIGITS")
SUFFIX_DIGITS=$(rand_chars "0123456789" "$NUM_DIGITS")
SUFFIX_SPECIALS=$(rand_chars "$ALLOWED_SPECIALS" "$NUM_SPECIALS")

PASSPHRASE="${PREFIX_SPECIALS}${PREFIX_DIGITS}${JOINED_WORDS}${SUFFIX_DIGITS}${SUFFIX_SPECIALS}"

# ===== OUTPUT =====
echo "Generated passphrase:"
echo "$PASSPHRASE"
