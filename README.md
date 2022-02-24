Зависимости:  
```
pip install poetry flake8 pyright yapf toml
sudo dnf install clangd
```
Для Python
Так же нужно добавить файл pyrightconfig.json в директорию проекта с содержанием:
```
{
    "venvPath": "путь до виртуального питона",
    "venv": "."
}
```
