#!/usr/bin/env bash

ln tmux.conf ~/.tmux.conf

gh cp tmux-plugins/tmux-sensible     sensible.tmux .
gh cp tmux-plugins/tmux-pain-control pain_control.tmux .