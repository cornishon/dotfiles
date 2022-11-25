function ls --wraps=lsd --wraps='lsd --color=always' --description 'alias ls=lsd --color=auto'
  lsd --color=auto $argv; 
end
