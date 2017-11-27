UNAME := $(shell uname -s)

ifeq ($(UNAME),Darwin)
PHPSTORM_LAST_VERSION := $(shell ls -a ${HOME}/Library/Preferences/ | grep PhpStorm\\d\\+ | tail -n 1 | sed s/PhpStorm//)
PHPSTORMDIR := ${HOME}/Library/Preferences/PhpStorm${PHPSTORM_LAST_VERSION}
endif

ifeq ($(UNAME),Linux)
PHPSTORM_LAST_VERSION := $(shell ls -a $(HOME) | grep PhpStorm | tail -n 1 | sed s/\.PhpStorm//)
WEBSTORM_LAST_VERSION := $(shell ls -a $(HOME) | grep WebStorm | tail -n 1 | sed s/\.WebStorm//)
PHPSTORMDIR := ${HOME}/.PhpStorm${PHPSTORM_LAST_VERSION}/config
WEBSTORMDIR := ${HOME}/.WebStorm${WEBSTORM_LAST_VERSION}/config
endif

home: ## install dotfiles
	ln -vsf ${PWD}/home/.dircolors   ${HOME}/.dircolors
	ln -vsf ${PWD}/home/.ideavimrc   ${HOME}/.ideavimrc
	ln -vsf ${PWD}/home/.gitconfig   ${HOME}/.gitconfig
	ln -vsf ${PWD}/home/.gitignore   ${HOME}/.gitignore

zsh: ## install oh-my-zsh
	test -d ${HOME}/.oh-my-zsh || git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
	test -d ${HOME}/.oh-my-zsh/plugins/zsh-autosuggestions || git clone git://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/plugins/zsh-autosuggestions
	ln -vsf ${PWD}/home/.zshrc   ${HOME}/.zshrc
	ln -vsf ${PWD}/ohmyzsh/config.zsh  ${HOME}/.oh-my-zsh/custom/config.zsh

etc: ## install etc
ifeq ($(UNAME),Darwin)
	ln -vsf ${PWD}/etc/vhosts.conf /usr/local/etc/nginx/conf.d/vhosts.conf
	ln -vsf ${PWD}/etc/local.conf /usr/local/etc/dovecot/local.conf
endif
ifeq ($(UNAME),Linux)
	sudo ln -vsf ${PWD}/etc/vhosts.conf /etc/nginx/conf.d/vhosts.conf
	sudo ln -vsf ${PWD}/etc/local.conf /etc/dovecot/local.conf
endif

vim: ## install vim configuration
	test -d ${HOME}/.vim || git clone https://github.com/ezprit/vimconfig.git ~/.vim
	mkdir -p ~/.vim/bundle
	test -d ${HOME}/.vim/bundle/neobundle.vim || git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
	vim +NeoBundleInstall +qall
	ln -vsf ${PWD}/home/.vimrc ${HOME}/.vimrc
	mkdir -p ${HOME}/.config/nvim
	ln -vsf ${HOME}/.vim/init.vim   ${HOME}/.config/nvim/init.vim
	ln -vsf ${HOME}/.vim/colors   ${HOME}/.config/nvim/colors

clean: ## cleanup system
ifeq ($(UNAME),Darwin)
	rm -rf ${HOME}/Library/Caches
	rm -rf "${HOME}/Library/Application Support/MobileSync/Backup/*"
	sudo rm -rf /Library/Caches
	sudo rm -rf /System/Library/Caches
	test -x "$(shell command -v brew)" || brew cleanup
endif
	test -x "$(shell command -v npm)" || npm cache clean
ifeq ($(UNAME),Linux)
	# Remove obsolete configuration files
	# http://ccm.net/faq/8269-ubuntu-cleaning-up-configuration-residue-packages
	# sudo dpkg --purge $(COLUMNS=200 dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2)
	# https://askubuntu.com/questions/104126/can-i-purge-configuration-files-after-ive-removed-the-package
	dpkg --purge `dpkg --get-selections | grep deinstall | cut -f1`
endif
	
tmux: ## tmux plugin and configuration
	test -d ${HOME}/.tmux/plugins/tpm || git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
	ln -vsf ${PWD}/home/.tmux.conf   ${HOME}/.tmux.conf

phpstorm: ## install phpStorm colors and keymaps
	rm -rf ${PHPSTORMDIR}/colors && ln -vsf ${PWD}/phpstorm/colors ${PHPSTORMDIR}/colors
	rm -rf ${PHPSTORMDIR}/keymaps && ln -vsf ${PWD}/phpstorm/keymaps ${PHPSTORMDIR}/keymaps
ifeq ($(UNAME),Linux)
	rm -rf ${WEBSTORMDIR}/colors && ln -vsf ${PWD}/phpstorm/colors ${WEBSTORMDIR}/colors
	rm -rf ${WEBSTORMDIR}/keymaps && ln -vsf ${PWD}/phpstorm/keymaps ${WEBSTORMDIR}/keymaps
endif

all: home zsh vim etc tmux phpstorm

.PHONY: all home vim etc zsh phpstorm clean

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
