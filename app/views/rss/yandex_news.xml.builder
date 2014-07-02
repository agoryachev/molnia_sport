xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.rss xmlns: "http://backend.userland.com/rss2", version: "2.0", "xmlns:yandex"=>"http://news.yandex.ru", "xmlns:media"=>"http://search.yahoo.com/mrss/" do
  xml.channel do
    xml.title Setting.site_name
    xml.link root_url    
    xml.description Setting.site_description      
    xml.image do |i|
      i.url "#{root_url}assets/images/logo-sport.png"
      i.title Setting.site_name
      i.link root_url    
    end
    for p in @posts
      xml.item do
        xml.title p.feedable.title
        xml.link send("category_#{p.feedable.class.to_s.downcase}_url", p.feedable.category, p.feedable)
        xml.description %Q(#{strip_tags p.feedable.subtitle} ...) if p.feedable.respond_to? :subtitle
        xml.category p.feedable.category.title
        xml.tag!("yandex:genre", "article")
        xml.tag!("yandex:full-text", sanitize(p.feedable.content, tags: %w(p b), attributes: %w()))
        xml.pubDate p.feedable.published_at.to_s(:rfc822)
        xml.enclosure(url: p.feedable.main_image.url, type: Mime::Type::lookup_by_extension(File.extname(p.feedable.main_image.url)[1,100].to_sym)) unless p.feedable.main_image.nil?
      end
    end
  end
end