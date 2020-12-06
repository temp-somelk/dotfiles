echo '{"text": "'$(playerctl metadata --format "{{ artist }} - {{ title }}")'", "alt": "'$(playerctl status)'", "class": "'$(playerctl status)'"}'
