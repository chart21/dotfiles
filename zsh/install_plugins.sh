#!/bin/bash

# Define plugin directories
external_dir="$DOTFILES/zsh/external"
zsh_codex_dir="$external_dir/zsh_codex"
fzf_dir="$external_dir/fzf"
zsh_autosuggestions_dir="$external_dir/zsh-autosuggestions"
zsh_syntax_highlighting_dir="$external_dir/zsh-syntax-highlighting"
you_should_use_dir="$external_dir/you-should-use"

# Create directories if they don't exist
mkdir -p $external_dir
cd $external_dir && find . -type d -exec rm -r {} + && cd $DOTFILES/zsh

# Clone the zsh_codex plugin
if [ ! -d "$zsh_codex_dir" ]; then
  git clone https://github.com/tom-doerr/zsh_codex $zsh_codex_dir
fi

# Clone the fzf plugin
if [ ! -d "$fzf_dir" ]; then
  git clone https://github.com/junegunn/fzf $fzf_dir
fi

# Clone the zsh-autosuggestions plugin
if [ ! -d "$zsh_autosuggestions_dir" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $zsh_autosuggestions_dir
fi

# Clone the zsh-syntax-highlighting plugin
if [ ! -d "$zsh_syntax_highlighting_dir" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $zsh_syntax_highlighting_dir
fi

# Clone the you-should-use plugin
if [ ! -d "$you_should_use_dir" ]; then
  git clone https://github.com/MichaelAquilina/zsh-you-should-use $you_should_use_dir
fi

# Copy fzf completion and key-bindings
if [ -d "$fzf_dir" ]; then
  cp $fzf_dir/shell/completion.zsh $fzf_dir/completion.zsh
  cp $fzf_dir/shell/key-bindings.zsh $fzf_dir/key-bindings.zsh
fi

echo "All plugins have been downloaded and installed in $external_dir."
