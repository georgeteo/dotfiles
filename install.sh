#!/bin/bash

DIR=$(pwd)

function yes_or_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Aborted" ; return  1 ;;
        esac
    done
}

# Install or update rust toolchain
if ! command -v cargo &> /dev/null
then
  echo "Running: curl https://sh.rustup.rs -sSf | sh"
  curl https://sh.rustup.rs -sSf | sh
else
  echo "Running: rustup update stable"
  rustup update stable
fi
echo "Installed Rust"

# Compile nushell from source since we want dev features.
git submodule init
pushd nushell
git pull origin main # nushell uses "main" as "master
echo "cargo build --release --workspace --features=extra"
cargo build --release --workspace --features=extra
echo "cp target/release/nu $HOME/bin/nu"
cp "target/release/nu" "$HOME/bin/nu"
popd
echo "Installed Nushell"

# Install starship prompt
if ! command -v cargo &> /dev/ null
then
  cargo install starship
fi
echo "Installed Starship"

# Symlink alacritty config
if test -f "$HOME/.alacritty.yml"
then
  echo "$HOME/.alacritty.yml exists. Override it?"
  yes_or_no 
  rm "$HOME/.alacritty.yml"
fi
echo "Running: ln -s $DIR.alacritty.yml $HOME/.alacritty.yml"
ln -s "$DIR.alacritty.yml" "$HOME/.alacritty.yml"
echo "Symlinked alacritty.yml"

# Symlink tmux conf
if test -f "$HOME/.tmux.conf"
then
  echo "$HOME/.tmux.conf exists. Override it?"
  yes_or_no 
  rm "$HOME/.tmux.conf"
fi
echo "Running: ln -s $DIR.tmux.conf $HOME/.tmux.conf"
ln -s "$DIR.tmux.conf" "$HOME/.tmux.conf"
echo "Symlinked tmux.conf"

# Install neovim
if ! command -v nvim &> /dev/null
then
  curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
  tar xzf nvim-macos.tar.gz
  ./nvim-osx64/bin/nvim
  echo "Installed Neovim"
fi

if test -f "$HOME/.SpaceVim.d/init.toml"
then
  echo "$HOME/.SpaceVim.d/init.toml exists. Override it?"
  yes_or_no
  rm "$HOME/.SpaceVim.d/init.toml"
fi
mkdir "$HOME/.SpaceVim.d"
echo "Running: ln -s $DIR.SpaceVim.d_init.toml $HOME/.SpaceVim.d/init.toml"
ln -s "$DIR.SpaceVim.d_init.toml" "$HOME/.SpaceVim.d/init.toml"


