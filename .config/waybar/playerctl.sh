echo '{"text": "'$(playerctl metadata --format "{{ title }} — {{ artist }}")'", "alt": "'$(playerctl status)'", "class": "'$(playerctl status)'"}'
