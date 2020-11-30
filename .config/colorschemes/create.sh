eval $(cat variables.json | jq -r 'keys[] as $k | "\($k)=\(.[$k])"')


