# Параметры портала
APP             = YAML.load_file(Rails.root.join('config', 'app.yml'))[Rails.env]
# Параметры социальных сетей
OAUTH           = YAML.load_file(Rails.root.join('config','oauth.yml'))[Rails.env]
# Параметры доступа к контент-серверу
FILE_STORAGE    = YAML.load_file(Rails.root.join('config', 'file_storage.yml'))[Rails.env]