module CheckAbilities
  extend ActiveSupport::Concern

  included do
    before_filter :check_employee_abilities!
    # Проверка права работника вызывать экшены контроллера
    def check_employee_abilities!
      unless current_employee.action_abilities.exists?(context: "controllers.#{controller_name}.#{action_name}")
        forbidden
      end
    end

    # Рендерит страницу forbidden если не найдны нужные abilities в базе
    #
    # @return [Html] страница forbidden
    #
    def forbidden
      render "backend/backend/forbidden"
    end
  end
end