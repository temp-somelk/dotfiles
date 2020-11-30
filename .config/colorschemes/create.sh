echo "name:" && read filename
data="$(cat $filename.json)"
num_elements=$(($(echo "$data" | jq length)-1))

for i in mako sway swaynag swaylock termite
do
	for j in $(seq 1 $num_elements)
	do
		key=\$$(echo $data | jq -r "keys_unsorted[$j]")
		val=$(echo $data | jq -r ".[keys_unsorted[$j]]")
		sed "s/$key/$val/g" ../$i/config.main
	done
done
