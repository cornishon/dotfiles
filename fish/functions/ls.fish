function ls --wraps=lsd --wraps='lsd --color=always' --description 'alias ls=lsd --color=always'
  lsd --color=always $argv; 
end
