variables=$(cat variables.json)
num_elements=$(($(cat variables.json | jq length) - 1))

echo $num_elements

for i in $(seq 0 $num_elements)
do
	echo "$i"
done
