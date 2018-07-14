FROM alpine:latest

RUN apk update \
 && apk add --no-cache busybox-extras ncurses zsh zsh-vcs fortune vim grep git tree htop curl httpie \
 && rm -rf /var/cache/apk/* \
 && sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd

WORKDIR /root

RUN mkdir -p .antigen \
 && curl -L git.io/antigen > .antigen/antigen.zsh \
 && curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ADD dotfiles .dotfiles

RUN ln -s $HOME/.dotfiles/zshrc .zshrc \
 && ln -s $HOME/.dotfiles/vimrc .vimrc \
 && /bin/zsh -c "source .antigen/antigen.zsh && antigen init .dotfiles/antigenrc" \
 && vim --not-a-term +"PlugInstall --sync" +qa

ENTRYPOINT /bin/zsh

