# encoding: utf-8
module Backend::PostsHelper
  
  # превью для новостей
  def main_image_backend post
    if post.try(:main_image).try(:file)
      image_tag post.main_image.file.url(:_90x90), width: 50, height: 50, class: :thumbnail
    else
      image_tag "missing/#{post.class.name.downcase}/_90x90.jpg", width: 50, height: 50, class: :thumbnail
    end
  end

  # хелпер класса фильтров
  def muted_class(param, state)
    'active' if param && param.to_i == state
  end



  def link_to_add_dynamic_object(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize+'_fields', f: builder)
    end
    link_to(name, '#', class: "add_#{association} btn btn-info pull-right", data: {id: id, fields: fields.gsub('\n','') })
  end
end