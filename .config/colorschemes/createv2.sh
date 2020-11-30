name=$(cat colors.json | jq -r '.name')
data=$(cat colors.json | jq -jr 'keys[] as $k | "s/\\$\($k)/\(.[$k])/g; "')

for i in sway mako swaylock swaynag termite
do
	sed "$data" ../$i/config.main > ../$i/config.$name
done
for i in waybar wofi
do
	sed "$data" ../$i/style.css.main > ../$i/style.css.$name
done
