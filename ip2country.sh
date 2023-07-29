#!/bin/bash

input_file="input_ips.txt"
output_file="ip_countries.txt"

num_threads=1

if [ ! -f "$input_file" ]; then
  echo "Error: Input file '$input_file' not found."
  exit 1
fi

echo -n "" > "$output_file"

get_country() {
  local ip="$1"
  local country=$(curl -s "http://ipwho.is/${ip}" | jq -r '.country')
  echo "$ip:$country"
}

export -f get_country

cat "$input_file" | parallel -j "$num_threads" get_country | tee -a "$output_file"

echo "IP:Country information written to '$output_file'."
