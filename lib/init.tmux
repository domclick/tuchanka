new-session -d -s "${tmux_session}" -n "${tmux_window}" -x "${COLUMNS}" -y "${LINES}"
set-option mouse on
set-option set-titles on
set-option set-titles-string '#{session_name}'
set-option status off
set-option display-time 0
set-option -w remain-on-exit on
display-message -p '#{pane_id}'
