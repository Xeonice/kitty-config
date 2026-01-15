# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a kitty terminal configuration with Warp-style aesthetics and a global hotkey system using Hammerspoon.

## Configuration Files

- `kitty.conf` - Main kitty config (includes theme and warp-style)
- `warp-style.conf` - Custom styling: fonts, transparency, tabs, shortcuts
- `current-theme.conf` - Color theme (moonlight)
- `toggle-kitty.sh` - Shell script for toggling kitty (legacy, uses yabai)
- `hammerspoon-init.lua` - Hammerspoon config for Option+/ global hotkey

## Installation

### Dependencies
```bash
brew install --cask font-jetbrains-mono
brew install --cask hammerspoon
brew install koekeishiya/formulae/yabai  # optional
```

### Setup
1. Clone to `~/.config/kitty/`
2. Copy `hammerspoon-init.lua` to `~/.hammerspoon/init.lua`
3. Grant accessibility permissions to Hammerspoon in System Settings

## Key Shortcuts

| Shortcut | Action |
|----------|--------|
| Option + / | Global toggle kitty (via Hammerspoon) |
| Cmd + Return | Toggle fullscreen |
| Cmd + D | Vertical split |
| Cmd + Shift + D | Horizontal split |
| Cmd + 1-9 | Switch to tab |
| Ctrl + Shift + +/- | Adjust opacity |

## Architecture

The global hotkey system uses **Hammerspoon** (not skhd) because it can:
- Move kitty window to current space (including fullscreen app spaces)
- Remember and restore previous app focus on hide
- Handle errors gracefully with pcall

Tab titles use Python expressions in `tab_title_template` to show `~` for home directory or the current folder name.
