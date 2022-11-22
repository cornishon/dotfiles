function ll --wraps=ls --wraps='lsd -l' --wraps='lsd -l --color=always' --description 'alias ll=lsd -l --color=always'
  lsd -l --color=always $argv; 
end
