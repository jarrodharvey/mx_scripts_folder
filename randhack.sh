
countdown() {
  secs=$1
  shift
  msg=$@
  while [ $secs -gt 0 ]
  do
    printf "\r\033[KWaiting %.d seconds $msg" $((secs--))
    sleep 1
  done
  echo
}

randhack() {
	game_letters="opvelxdghbakuyinfz"
	selected_letter="${game_letters:$(( RANDOM % ${#game_letters} )):1}" # pick a 1 char substring starting at a random position
	selected_letter=$( echo $selected_letter | tr -d '\n' )
	echo $selected_letter | xclip -selection c
	echo "A random letter is now in the clipboard, use this to launch a random nethack variant!"
	countdown 10 "until I launch."
	ssh nethack@au.hardfought.org
}

randhack
