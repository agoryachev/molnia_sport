# encoding: utf-8
module Backend::CountriesHelper

  def formatted_categories(categories)
    raw categories.map(&method(:make_link)).to_sentence
  end

  def make_link(object)
    content_tag :span, class: "badge #{object.color}" do
      link_to object.title, polymorphic_path([:edit, :backend, object]), class: 'white-text'
    end
  end
end