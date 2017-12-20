#!/bin/bash


# install needed software
yum install -y tmux python34 python34-pip python34-virtualenv

# virtualenv project manager
pip3 install virtualenvwrapper
mkdir .venv && cat >> ~/.bashrc <<EOF

# alias area
alias la="ls -alh"
alias ta="tmux attach"
alias c="clear"

# enable virtualenvwrapper
export WORKON_HOME="~/.venv"
VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/bin/virtualenvwrapper.sh
export PROJECT_HOME="$HOME/proj"

EOF

# configure the tmux
cat >> ~/.tmux.conf <<EOF

# 将r 设置为加载配置文件，并显示"reloaded!"信息
bind r source-file ~/.tmux.conf \; display "Reloaded!"

is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
bind-key -n C-\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"

# 改变面板的大小
bind -r C-h resize-pane -L 5
bind -r C-j resize-pane -D 5
bind -r C-k resize-pane -U 5
bind -r C-l resize-pane -R 5

# 鼠标相关的设置
# setw -g mode-mouse on
# set -g mouse-select-pane on
# set -g mouse-resize-pane on
# set -g mouse-select-window on

# 让tmux支持256色
set -g default-terminal "screen-256color"

# 设置底部状态条的颜色
set -g status-fg white
set -g status-bg black
setw -g window-status-fg cyan
setw -g window-status-bg default
setw -g window-status-attr dim
setw -g window-status-current-fg white
setw -g window-status-current-bg red
setw -g window-status-current-attr bright

# 设置面板间分割线的颜色
set -g pane-border-fg green
set -g pane-border-bg black
set -g pane-active-border-fg red
set -g pane-active-border-bg black

# 窗口的编号从1开始（默认是0）
set -g base-index 1
setw -g pane-base-index 1

# 状态栏左侧的长度和文字颜色
set -g status-left-length 20
set -g status-left "#[fg=green]Session: #S #[fg=yellow]#I #[fg=cyan]#P"
# set -g status-left "#[fg=green]Session: #[fg=yellow]#I"
# right
set -g status-right "#[fg=cyan]%d %b %R"

set -g status-utf8 on

# 每60秒更新一次显示的时间。默认是15秒
set -g status-interval 60

# 非当前窗口中有事件发生时（比如一个耗时的命令跑完了），状态栏上会有高亮提醒
setw -g monitor-activity on
set -g visual-activity on

# 编辑模式使用vi快捷键
setw -g mode-keys vi

EOF
