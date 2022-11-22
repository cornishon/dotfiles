function tree --wraps='lsd --tree --color=always' --description 'alias tree=lsd --tree --color=always'
  lsd --tree --color=always $argv; 
end
