# Установка cron-заданий через процедуру деплоя
every 1.day, at: '4:00 am' do
  # Окончательно удаляем удаленные записи
  rake "remove:deleted"
end
every 1.day, at: '4:30 am' do
  # Индексация базы данных Sphinx
  rake "ts:index"
  # Агрегация статистики за сутки
  rake "stat:aggr"
end