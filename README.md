Зависимости:  
```
pip install poetry flake8 pyright yapf toml autopep8 neovim
sudo dnf install clangd g++
npm install vscode-html-languageservic
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
Для Python
Так же нужно добавить файл pyrightconfig.json в директорию проекта с содержанием:
```
{
    "venvPath": "путь до виртуального питона",
    "venv": "."
}
```
