# coding: utf-8
Delayed::Worker.sleep_delay = 60
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.max_attempts = 2
Delayed::Worker.max_run_time = 1.hours
Delayed::Worker.delay_jobs = !Rails.env.test?

DJ_STATUSES = {wait: 'Ожидает',run: 'Выполняется', repeat: 'Выполняется повторно', fail: 'Провалена', success: 'Успешно'}