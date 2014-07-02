xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "#{Setting.site_name} RSS Канал"
    xml.link root_url

    for p in @posts
      xml.item do
        xml.title p.feedable.title
        xml.description strip_tags p.feedable.content
        xml.pubDate p.feedable.published_at.in_time_zone("Europe/Moscow").to_s(:rfc822)
        xml.link send("category_#{p.feedable.class.to_s.downcase}_url", p.feedable.category, p.feedable)
        xml.enclosure(url: p.feedable.main_image.url, type: Mime::Type::lookup_by_extension(File.extname(p.feedable.main_image.url)[1,100].to_sym)) unless p.feedable.main_image.nil?
        for video in @videos[p.feedable.id]
          xml.enclosure(url: video, type: Mime::Type::lookup_by_extension(File.extname(video)[1,100].to_sym))
        end
        for image in @images[p.feedable.id]
          xml.enclosure(url: image, type: Mime::Type::lookup_by_extension(File.extname(image)[1,100].to_sym))
        end
      end
    end
  end
end