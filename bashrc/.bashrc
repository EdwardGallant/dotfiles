function reload_dotfiles {
    ( cd ~/dotfiles && git checkout -b nyaotmp && git branch -D main && git fetch && git checkout main && git branch -D nyaotmp )
    bash ~/dotfiles/install
    source ~/.bashrc
}

function nginx {
    sudo /etc/init.d/nginx $1
}

function copy_nginx {
    erb .spin/nginx.conf.erb > /etc/nginx/conf.d/nginx.conf
}
