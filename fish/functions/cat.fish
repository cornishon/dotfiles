function cat --wraps=bat --wraps='bat --style=header,grid' --description 'alias cat=bat --style=header,grid'
  bat --style=header,grid $argv; 
end
