for i in $(seq 1); do
    f=$(mktemp /tmp/char.XXXX)
    perl halberdsnhelmets.pl get '/random/text/de' > $f
    name=$(grep name: $f | cut -c 7-)
    class=$(grep class: $f | cut -c 8-)
    if curl --head --silent "https://campaignwiki.org/wiki/Greyheim/$name" \
	    | grep --silent "^HTTP/1.1 404"; then
	echo "|[[$name]] | 0| 0| $class 1| – | no player |"
	cat $f
	curl -F ns=MontagInZ%c3%bcrich -F title=$name -F frodo=1 -F username=Alex \
	     -F summary="New character" -F "text=<$f" https://campaignwiki.org/wiki
	sleep 1
    fi
    rm $f
done
