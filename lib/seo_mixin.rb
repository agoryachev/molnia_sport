module SeoMixin
  extend ActiveSupport::Concern

  included do
    attr_accessible :seo_attributes
    has_one :seo, as: :seoable, dependent: :destroy
    accepts_nested_attributes_for :seo, allow_destroy: true
    before_save ->(){ self.seo.slug = make_title if self.seo.present? }
  end

  # Формирует заголовок детали страницы модели
  #
  # @param self [Class] класс для которого формируется заголовок
  # @return [String] заголовок в транслите
  #
  def make_title
    if self.respond_to?(:title)
      title.downcase.strip.to_ascii.gsub(' ', '_').gsub(/[^\w-]/, '')
    elsif self.respond_to?(:full_name)
      full_name.downcase.strip.to_ascii.gsub(' ', '_').gsub(/[^\w-]/, '')
    end
  end

  # Преобразование параметров в SEO-URL
  # 
  # @return [String] "10-category"
  #
  def to_param
    self.seo && "#{id}-#{self.seo.slug}".parameterize || super
  end
end