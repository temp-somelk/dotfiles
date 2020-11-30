eval $(cat variables.json | jq -r 'keys[] as $k | "\($k)=\(.[$k])"')

for i in sway mako swaylock swaynag termite
do
	sed "s/\$accent/$accent/g;s/\$text/$text/g;s/\$texlight/$texlight/g;s/\$background/$background/g;s/\$black0/$black8/g;s/\$red/$red/g;s/\$green/$green/g;s/\$yellow/$yellow/g;s/\$blue/$blue/g;s/\$magenta/$magenta/g;s/\$cyan/$cyan/g;s/\$white/$white/g;s/\$gray/$gray/g;s/\$grey/$grey/g" ../$i/config.main > ../$i/config.$name
done

for i in mako swaylock swaynag termite
do
	ln -sf ../$i/config.$name ../$i/config
done

for i in waybar wofi
do
	sed "s/\$accent/$accent/g;s/\$text/$text/g;s/\$texlight/$texlight/g;s/\$background/$background/g;s/\$black0/$black0/g;s/\$black8/$black8/g;s/\$red/$red/g;s/\$green/$green/g;s/\$yellow/$yellow/g;s/\$blue/$blue/g;s/\$magenta/$magenta/g;s/\$cyan/$cyan/g;s/\$white/$white/g;s/\$gray/$gray/g;s/\$grey/$grey/g" ../$i/style.css.main > ../$i/style.css.$name
	ln -sf ../$i/style.css.$name ../$i/style.css
done
