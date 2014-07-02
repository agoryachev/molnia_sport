# encoding: utf-8
class InitDatabase < ActiveRecord::Migration
  def change

    ###################################################
    # Персоналия (игрок, тренер, владелец клуба и т.п.)
    ###################################################

    create_table :persons, force: true, comment: "Персоналии (игрок, тренер, владелец клуба и т.п.)" do |t|

      t.string    :name_first, null: false, default: "", comment: "Имя"
      t.string    :name_last, null: false, default: "", comment: "Фамилия"
      t.string    :name_v, null: true, comment: "Отчество"
      t.text      :content, null: false, comment: "Описание"

      t.boolean   :is_published, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.boolean   :is_deleted, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
      t.boolean   :is_comments_enabled, unsigned: true, null: false, default: true, comment: "1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии"

    end

    ###################################################
    # Команда
    ###################################################

    create_table :teams, comment: "Команды (в рамках групповых видов спорта)" do |t|

      t.string    :title, null: false, default: "", comment: "Название команды"
      t.text      :content, null: false, comment: "Описание команды"

      t.boolean   :is_published, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.boolean   :is_deleted, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
      t.boolean   :is_comments_enabled, unsigned: true, null: false, default: true, comment: "1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии"

      t.integer   :category_id, unsigned: true, null: false, comment: "Внешний ключ для связи с категорией"

    end

    create_table :teams_persons, comment: "Связующая таблица команд (teams) с персоналиями (persons)" do |t|

      t.integer   :team_id, unsigned: true, null: false, comment: "Внешний ключ для связи с командой"
      t.integer   :person_id, unsigned: true, null: false, comment: "Внешний ключ для связи с персоной"

    end

    ###################################################
    # Трансферы
    ###################################################

    create_table :transfers, comment: "Трансферы - переходы игроков" do |t|

      t.integer   :person_id, unsigned: true, null: false, comment: "Внешний ключ для связи с персоной"
      t.integer   :team_from_id, unsigned: true, null: true, comment: "Внешний ключ для связи с командой, которую игрок покидает"
      t.integer   :team_to_id, unsigned: true, null: true, comment: "Внешний ключ для связи с командой, в которую игрок приходит"

      t.text      :content, null: true, default: "", comment: "Описание трансфера"

      t.boolean   :is_published, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.boolean   :is_deleted, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
      t.boolean   :is_comments_enabled, unsigned: true, null: false, default: true, comment: "1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии"

      t.integer   :state, unsigned: true, null: false, default: 0, comment: "Статус трансфера: 0 - начавшийся трансфер, 1 - завершившийся трансфер"

      t.datetime  :start_at, unsigned: true, null: true, comment: "Дата и время начала трансфера"
      t.datetime  :finish_at, unsigned: true, null: true, comment: "Дата и время завершения трансфера"

      t.timestamps

    end

    ###################################################
    # Матчи
    ###################################################

    create_table :matches, comment: "Матчи" do |t|

      t.integer   :team_home_id, unsigned: true, null: true, comment: "Внешний ключ для связи с принимающей командой"
      t.integer   :team_guest_id, unsigned: true, null: true, comment: "Внешний ключ для связи с гостевой командой"

      t.text      :content, null: true, default: "", comment: "Описание матча"

      t.boolean   :is_published, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.boolean   :is_deleted, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
      t.boolean   :is_comments_enabled, unsigned: true, null: false, default: true, comment: "1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии"

      t.integer   :count_home, unsigned: true, null: true, comment: "Очки принимащей команды (сколько забили голов/шайб гостевой команде)"
      t.integer   :count_guest, unsigned: true, null: true, comment: "Очки гостевой команды (сколько забили голов/шайб принимающей команде)"

      t.datetime  :start_at, unsigned: true, null: true, comment: "Дата и время начала матча"
      t.datetime  :finish_at, unsigned: true, null: true, comment: "Дата и время завершения матча"

      t.timestamps

    end

    ###################################################
    # Лиги
    ###################################################

    create_table :leagues, comment: "Лиги, чемпионаты" do |t|

      t.string    :title, null: false, default: "", comment: "Название лиги"
      t.text      :content, null: true, default: "", comment: "Описание лиги"

      t.boolean   :is_published, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.boolean   :is_deleted, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
      t.boolean   :is_comments_enabled, unsigned: true, null: false, default: true, comment: "1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии"

    end

    ###################################################
    # Группы в рамках лиги
    ###################################################

    create_table :leagues_groups, comment: "Группы в рамках лиги, группы" do |t|

      t.string    :title, null: false, default: "", comment: "Название группы"
      t.date      :date_at, unsigned: true, null: true, comment: "Дата старта игр в рамках группы"
      t.references :league, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей лиг"

    end

    ###################################################
    # Матчи в рамках группы
    ###################################################

    create_table :leagues_groups_matches, comment: "Матчи в рамках группы" do |t|

      t.references :leagues_group, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей групп в рамках лиги"
      t.references :match, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей матчей"

    end

    ###################################################
    # Категории
    ###################################################

    create_table :categories, comment: "Категории (Футбол, Хокей)" do |t|

      t.string    :title, null: false, default: "", comment: "Заголовок категории"

      t.boolean   :is_published, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"

      t.integer   :placement_index, unsigned: true, null: false, default: 0, comment: "Поле для задания порядка следования категорий на одном уровне относительно друг друга"
      t.integer   :nested_set_left, unsigned: true, null: false, default: 0, comment: "Левый индекс Nested Set для дерева категорий"
      t.integer   :nested_set_right, unsigned: true, null: false, default: 0, comment: "Правый индекс Nested Set для дерева категорий"
      t.integer   :nested_set_level, unsigned: true, null: false, default: 0, comment: "Глубина в рамках дерева категорий Nested Set"

    end

    ###################################################
    # Файлы
    ###################################################

    create_table :media_files, comment: "Медиа-файлы (фото-, видео-файлы)" do |t|

      t.integer  :attachable_id, unsigned: true, null: false, comment: "Идентификатор таблицы связанной модели (Post, Video, GalleryPhoto)"
      t.string   :class_name, default: "", null: false, comment: "Название метода обработчика комментария GalleryPhoto::File Video::Clip Video::Frame"
      t.string   :file_file_name, null: false, comment: "Путь к файлу (paperclip)"
      t.string   :file_content_type, comment: "MEDIA-тип файла (paperclip)"
      t.integer  :file_file_size, unsigned: true, comment: "Размер файла в байтах (paperclip)"

      t.timestamps

    end

    ###################################################
    # Авторы публикаций (новости, видео, галлереи)
    ###################################################

    create_table :authors, comment: "Авторы статей (могут быть связанны с сотрудниками по полю employee_id)" do |t|

      t.string    :name, null: false, comment: "Имя автора(или псевдоним)"

      t.integer   :employee_id, unsigned: true, comment: "Идентификатор сотрудника, аккаунта автора в системе администрирования"

      t.integer   :posts_count, unsigned: true, default: 0, null: false, comment: "Количество новостей, принадлежащих автору"
      t.integer   :videos_count, unsigned: true, default: 0, null: false, comment: "Количество видео-сюжетов, принадлежащих автору"
      t.integer   :galleries_count, unsigned: true, default: 0, null: false, comment: "Количество фотогалерей, принадлежащих автору"
      t.integer   :media_count, default: 0, null: false, comment: "Количество файлов в медиабиблиотеке, принадлежащих автору"

    end

    create_table :authors_publications, comment: "Связующая таблица авторов с публикациями (Галерея, Видео, Новость)" do |t|

      t.integer   :author_id, unsigned: true, null: false, comment: "Внешний ключ для связи с автором"
      t.string    :publication_type, null: false, comment: "Тип связанной публикации (Post, Video, Gallery)"
      t.integer   :publication_id, unsigned: true, null: false, comment: "Внешний ключ для связи с публикацией (Post, Video, Gallery)"

    end

    ###################################################
    # Тэги
    ###################################################
    create_table :tags, comment: "Тэги" do |t|

      t.string    :name, comment: "Тэг"

    end

    create_table :taggings, comment: "Связующая таблица тэгов и тэгитируемого материала (Post, Video, Gallery)" do |t|

      t.references :tag, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей тэгов"
      t.references :taggable, unsigned: true, null: false, polymorphic: true, comment: "Внешний ключ для связи с тэгитируемым материалом"
      t.references :tagger, polymorphic: true, comment: "Связь с тэгирующим сотрудником"
      t.string :context, null: false, limit: 128, comment: "Контекст поиска, всегда принимает значение tags"

      t.timestamps

    end
    
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]

    ###################################################
    # Новости
    ###################################################

    create_table :posts, comment: "Новости" do |t|

      t.string   :title, null: false, comment: "Заголовок новости"
      t.string   :subtitle, null: true, comment: "Подзаголовок новости"
      t.text     :content, null: false, comment: "Содержимое новости"

      t.integer  :category_id, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей разделов"
      t.integer  :author_id, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей авторов"

      t.boolean  :is_published, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.boolean  :is_deleted, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
      t.boolean  :is_comments_enabled, unsigned: true, null: false, default: true, comment: "1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии"

      t.boolean  :delta, default: true, null: false, comment: "Индекс для полнотекстового поиска (Sphinks)"

      t.integer  :comments_count, unsigned: true, default: 0, null: false, comment: "Количество комментариев к новости"

      t.datetime  :published_at, unsigned: true, null: false, comment: "Дата и время публикации"

      t.timestamps

    end

    ###################################################
    # Фоторепортажи
    ###################################################

    create_table :galleries, comment: "Фотогалереи" do |t|

      t.string   :title, null: false, comment: "Заголовок фотогалереи"
      t.string   :content, comment: "Описание фотогалереи"

      t.integer  :category_id, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей рубрик"
      t.integer  :author_id, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей авторов"

      t.boolean  :is_published, unsigned: true, default: false, null: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.boolean  :is_deleted, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
      t.boolean  :is_comments_enabled, unsigned: true, default: true, null: false, comment: "1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии"

      t.boolean  :delta, default: true, null: false, comment: "Индекс для полнотекстового поиска (Sphinks)"

      t.integer  :gallery_photos_count, unsigned: true, default: 0, null: false, comment: "Количество изображений в фотогаллереи"
      t.integer  :comments_count, unsigned: true, default: 0, null: false, comment: "Количество комментариев к фотогаллереи"

      t.datetime  :published_at, unsigned: true, null: false, comment: "Дата и время публикации"

      t.timestamps

    end

    create_table :gallery_files, comment: "Связующая таблица фотогалереи с медиабиблиотекой" do |t|

      t.integer  :gallery_id, unsigned: true, null: false, comment: "Внешний ключ для связи с фотогалерей"
      t.string   :description, null: true, comment: "Описание изображения"
      t.integer  :placement_index, unsigned: true, null: false, default: 0, comment: "Поле для задания порядка следования изображений относительно друг друга"
      t.boolean  :is_published, unsigned: true, null: false, default: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"

      t.timestamps

    end

    ###################################################
    # Видео
    ###################################################

    create_table :videos, comment: "Видеозаписи" do |t|

      t.string   :title, null: false, comment: "Заголовок видео-новости" 

      t.integer  :category_id, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей категорий"
      t.integer  :author_id, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей авторов"

      t.boolean  :is_published, unsigned: true, default: false, null: false, comment: "1 - опубликовано (отображается), 0 - не опубликовано (не отображается)"
      t.boolean  :is_deleted, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
      t.boolean  :is_comments_enabled, unsigned: true, default: true, null: false, comment: "1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии"

      t.integer  :comments_count, unsigned: true, default: 0, null: false, comment: "Количество комментариев к новости"

      t.datetime  :published_at, unsigned: true, null: false, comment: "Дата и время публикации"

      t.timestamps

    end

    ###################################################
    # Страницы сайта
    ###################################################

    create_table :pages, comment: "Страницы сайта" do |t|

      t.string   :title, default: 0, null: false, comment: "Заголовок страницы"
      t.text     :content, null: false, default: "", comment: "Содержимое страницы"

      t.boolean  :is_published, unsigned: true, default: true, comment: "1 - страница доступна для просмотра, 0 - страница не доступна для просмотра"
      t.boolean  :is_deleted, unsigned: true, null: false, default: false, comment: "1 - удалено (фактически скрыто без возможности отображения), 0 - обычная запись"
      t.boolean  :is_comments_enabled, unsigned: true, default: true, null: false, comment: "1 - допускается размещение пользовательских комментариев, 0 - не разрешено оставлять комментарии"

      t.timestamps

    end

    ###################################################
    # SEO-параметры
    ###################################################

    create_table :seos, comment: "SEO-информация" do |t|

      t.references :seoable, unsigned: true, null: false, polymorphic: true, comment: "Внешний ключ для материала, снабжаемого SEO-параметрами"
      t.string     :alias, default: "", null: false, comment: "Каноническое имя (canonical) для URL"
      t.string     :keywords, default: "", null: false, comment: "Ключевые слова для META-тэга keywords"
      t.string     :description, default: "", null: false, comment: "Описание для META-тэга description"

    end

    ###################################################
    # Настройки
    ###################################################

    create_table :settings, comment: "Таблица с настройками, расширяющая app.yml" do |t|

      t.string     :name, comment: "Имя параметра"
      t.string     :content, limit: "256", comment: "Содержание"

    end

    ###################################################
    # Backend-сотрудники (редакторы, администраторы)
    ###################################################

    create_table :employees, comment: "Backend-сотрудники (администраторы, редакторы)" do |t|

      t.string     :nickname,           null: false, default: "", comment: "Никнейм пользователя"
      t.string     :email,              null: false, default: "", comment: "Электронная почта пользователя (обязательно)"
      t.string     :encrypted_password, null: false, default: "", comment: "Хэш пароля пользователя"
      t.integer    :group_id,           null: false, unsigned: true, comment: "Связь сотрудника с группой"
      t.string     :name_first, comment: "Имя сотрудника (не обязательно)"
      t.string     :name_last, comment: "Фамилия сотрудника (не обязательно)"

      t.string     :reset_password_token, comment: "Токен восстановления пароля"
      t.datetime   :reset_password_sent_at, comment: "Время, когда токен восстановления был выслан"

      t.integer    :sign_in_count, default: 0, comment: "Количество удачных попыток входа"
      t.datetime   :current_sign_in_at, comment: "Текущее вход в"
      t.datetime   :last_sign_in_at, comment: "Последний вход в"
      t.string     :current_sign_in_ip, comment: "ip-адрес текущей сессии"
      t.string     :last_sign_in_ip, comment: "ip-адрес последней сессии"

      t.datetime   :remember_created_at, comment: "Запомнить меня"

      t.boolean    :is_active, unsigned: true, null: false, default: false, comment: "1 - редактор допущен в систему, 0 - редактор не имеет возможность входа"

      t.timestamps

    end

    add_index :employees, :email,                unique: true
    add_index :employees, :reset_password_token, unique: true

    ###################################################
    # Права доступа
    ###################################################

    create_table :groups, comment: "Группы администраторов, редакторов" do |t|

      t.string     :title, default: "", null: false, comment: "Название группы"
      t.string     :permissions, limit: 21300, default: "", null: false, comment: "Права доступа для группы"
      t.string     :description, default: "", null: false, comment: "Описание группы(короткое)"
      t.integer    :employees_count, unsigned: true, default: 0, null: false, comment: "Количество участников"        

    end

    create_table :abilities, comment: "Список экшенов для прав доступа" do |t|

      t.string     :context,      null: false, comment: "Контекст возможности доступа, например controllers.posts.index или models.posts.is_published"
      t.string     :ability_type, null: false, commetn: "Тип возможности доступа - controllers, models, partials"

    end

    add_index :abilities, [:ability_type, :context], length: {ability_type: 20, context: 50}

    create_table :group_abilities, comment: "Связующая таблица групп и экшенов для прав доступа" do |t|

      t.integer    :group_id,   null: false, unsigned: true, comment: "Внешний ключ для связи с группой"
      t.integer    :ability_id, null: false, unsigned: true, comment: "Внешний ключ для связи с экшеном (abilities)"

    end

    add_index :group_abilities, [:ability_id]
    add_index :group_abilities, [:group_id]

    ############################################################
    # Frontend-пользователи (комментарии, обратная связь)
    ############################################################

    create_table :users, comment: "Frontend-пользователи" do |t|

      ## Database authenticatable
      t.string     :email,              null: false, default: "", comment: "Электронная почта пользователя (обязательно)"
      t.string     :encrypted_password, null: false, default: "", comment: "Хэш пароля пользователя"

      ## Recoverable
      t.string     :reset_password_token, comment: "Токен восстановления пароля"
      t.datetime   :reset_password_sent_at, comment: "Время, когда токен восстановления был выслан"

      ## Rememberable
      t.datetime   :remember_created_at, comment: "Запомнить меня"

      ## Trackable
      t.integer    :sign_in_count, default: 0, comment: "Количество удачных попыток входа"
      t.datetime   :current_sign_in_at, comment: "Текущее вход в"
      t.datetime   :last_sign_in_at, comment: "Последний вход в"
      t.string     :current_sign_in_ip, comment: "ip-адрес текущей сессии"
      t.string     :last_sign_in_ip, comment: "ip-адрес последней сессии"

      ## Confirmable
      t.string     :confirmation_token, comment: "Токен активации пользователя"
      t.datetime   :confirmed_at, comment: "Время подтверждения активации"
      t.datetime   :confirmation_sent_at, comment: "Время, когда токен активации был выслан"

      t.string     :name_first, null: false, comment: "Имя пользователя (обязательно)"
      t.string     :name_last, null: false, comment: "Фамилия пользователя (обязательно)"
      t.string     :name_v, null: true, comment: "Отчество пользователя (не обязательно)"

      t.boolean    :is_active, unsigned: true, null: false, default: true, comment: "1 - пользователь допущен в систему, 0 - пользователь не имеет возможность входа"

      t.timestamps

    end

    # ############################################################
    # # Комментарии
    # ############################################################

    create_table :comments, comment: "Комментарии пользователей" do |t|

      t.string     :title, limit: 50, default: "", null: false, comment: "Заголовок комментария"
      t.text       :content, null: false, comment: "Тело комментария"
      t.references :commentable, unsigned: true, null: false, polymorphic: true, comment: "Внешний ключ для комментируемого материала"
      t.references :user, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей frontend-пользователей user"

      t.boolean    :is_published, unsigned: true, default: false, comment: "1 - комментарий доступен для просмотра, 0 - комментарий скрыт"
      t.boolean    :is_deleted, unsigned: true, null: false, default: false, comment: "1 - комментарий удален (фактически скрыт без возможности отображения), 0 - обычный комментарий"

      t.timestamps

    end

    ############################################################
    # Обратная связь
    ############################################################

    create_table :feedbacks, comment: "Отзывы/пожелания пользователей" do |t|

      t.references :user, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей frontend-пользователей user"
      t.string     :title, null: false, comment: "Заголовок сообщения"
      t.text       :content, null: false, comment: "Содержимое сообщения"

      t.boolean    :is_replied, unsigned: true, null: false, default: false, comment: "0 - на сообщение не был дан ответ, 1 - ответ был отправлен посетителю"

      t.timestamps

    end

    ############################################################
    # Голоса, оценка
    ############################################################

    create_table :votes, comment: "Голоса за комментарии, команды, игроков и т.п." do |t|

      t.integer :user_id, unsigned: true, null: false, comment: "Внешний ключ для связи с таблицей пользователей (id того, кто голосует)"
      t.integer :votable_id, unsigned: true, null: false, comment: "Идентификатор предложения, за который отдается голос"
      t.string  :votable_type, null: false, comment: "Класс предложения, за который отдается голос"
      t.integer :total, null: false, comment: "1 - голос за, -1 - голос против, 10 - десять голосов за"

      t.timestamps

    end

  end
end