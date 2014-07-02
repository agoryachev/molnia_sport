# -*- coding: utf-8 -*-
module BackendHelper  
  #======================================================
  # Error messages & notices
  #======================================================
   def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="alert alert-error fade in">
      <a class="close" data-dismiss="alert" href="#">×</a>
      <h4 class="alert-heading">#{sentence}</h4>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def flash_error_messages!
    messages = flash.each.map{|type,msg| msg if type == :alert}.join
    return if messages.empty?
    html = <<-HTML
    <div class="alert alert-error fade in">
      <a class="close" data-dismiss="alert" href="#">×</a>
      <ul>#{messages}</ul>
    </div>
    HTML
    html.html_safe
  end

  def flash_success_messages
    messages = flash.each.map{|type,msg| msg if type == :notice}.join
    return if messages.empty?
    html = <<-HTML
    <div class="alert alert-success fade in">
      <a class="close" data-dismiss="alert" href="#">×</a>
      <ul>#{messages}</ul>
    </div>
    HTML
    html.html_safe
  end

  #======================================================
  # Дата и время
  #======================================================
  def dt(t)
    Russian::strftime(t, "%d.%m.%Y в %H:%M") if t
  end

  def d(t)
    Russian::strftime(t, "%d.%m.%Y") if t
  end
  
  def datepicker_dt(t)
    t.strftime("%d/%m/%Y %H:%M") if t
  end

  #======================================================
  # Фильтры
  #======================================================
  # хэлпер 'Показывать: Сброс Все Опубликованные Черновики'
  def is_published_filter path
    html = <<-HTML
      <li> Показывать:</li>
      <li> #{link_to 'Сброс', path} </li>
      <li> #{link_to 'Все', url_for(path.merge filter: params[:filter]), class: params[:is_published] ? "" : "muted"}</li>
      <li> #{link_to 'Опубликованные', url_for(path.merge is_published: 1, filter: params[:filter]), class: params[:is_published].to_i == 1 ? "muted" : ""}</li>
      <li> #{link_to 'Черновики', url_for(path.merge is_published: 0, filter: params[:filter]), class: params[:is_published] && params[:is_published].to_i == 0 ? "muted" : ""}</li>
    HTML
    html.html_safe  
  end

  def avatar_for_user obj, dim=:_50x50
    w,h = *dim.to_s.gsub(/_/,"").split("x")
    unless obj.avatar.nil?
      image_tag obj.avatar.file(dim), alt: "", class: "thumbnail"
    else
      image_tag "missing/employee_#{dim}.png", width: w, alt: "", class: "thumbnail"
    end
  end

  #======================================================
  # Файлы
  #======================================================
  def available_video_files obj
    mp4 = @video.clip.with_ext("mp4")
    webm = @video.clip.with_ext("webm")
    
    html = ["Файл в формате .MP4:"]
    unless mp4.nil?
      html << link_to(mp4, mp4)
    else
      html << "Не существует"
    end

    html << "Файл в формате .WEBM:"
    unless webm.nil?
      html << link_to(webm, webm)
    else
      html << "Не существует"
    end
    html.join("<br />").html_safe
  end

  def publication_options obj
    opt = []
    opt << '<span class="label label-important">Отложенная</span>' if obj.deferred?
    unless opt.blank?
      "#{opt.join(" | ")}<br />".html_safe
    else
      nil
    end
  end

  def publication_stories obj
    obj.stories.map(&:title).join(", ")
  end

  def publication_polymorphic_edit_path obj
    if obj.class.to_s == "BlogPost"
      edit_backend_blog_blog_post_path(obj.blog, obj)
    else
      File.join("/backend/",polymorphic_path(obj),"edit").to_s
    end
  end
end