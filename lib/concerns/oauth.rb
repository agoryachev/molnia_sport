module Oauth
  module ClassMethods

    # Аутентифицирует или создает и аутентифицирует нового пользователя
    # с помощью oauth провайдера
    # 
    # * *Args*    :
    #   - +auth+ -> объект oauth провайдера, Object
    #   - +signed_in_resource+ -> 
    # * *Returns* :
    #   - Object - User instance
    #
    def find_for_provider_oauth(auth, signed_in_resource=nil)
      user = self.where(auth.slice(:provider, :uid)).first

      return user if user
      return signed_in_resource if signed_in_resource

      params = case auth.provider
        when "facebook"  then Oauth::facebook(auth)
        when "vkontakte" then Oauth::vkontakte(auth)
        when "twitter"   then Oauth::twitter(auth)
      end
      file = picture_square(params[:image_url])
      user = self.new(params.except(:image_url))
      user.skip_confirmation!
      user.put_image file
      user.save
      user
    end

    def picture_square(url)
      raw_url, binary_img = url, ''
      open(raw_url, allow_redirections: :safe){|f| binary_img = f.read}
      encoded_img = Base64.encode64(binary_img)
      return "data:image/jpg;base64,#{encoded_img.to_s}"
    end
  end

  def self.facebook(auth)
    nickname = auth.extra.raw_info.username || auth.uid.to_s
    { email: auth.info.email,
      password: Devise.friendly_token[0,20],
      nickname: nickname,
      provider: auth.provider,
      uid: auth.uid,
      name_first: auth.info.first_name,
      name_last: auth.info.last_name,
      image_url: auth.info.image.gsub('type=square', 'width=720&height=720')
    }
  end

  def self.twitter(auth)
    nickname = auth.info.nickname || auth.uid.to_s
    { email: "#{auth.uid.to_s}@twitter.com",
      password: Devise.friendly_token[0,20],
      nickname: nickname,
      provider: auth.provider,
      uid: auth.uid,
      name_first: auth.info.name,
      name_last: auth.info.name,
      image_url: auth.info.image
    }
  end

  def self.vkontakte(auth)
    nickname = auth.extra.raw_info.domain || auth.uid.to_s
    return { email: "#{nickname}@vk.com",
      password: Devise.friendly_token[0,20],
      nickname: nickname,
      provider: auth.provider,
      uid: auth.uid,
      name_first: auth.extra.raw_info.first_name,
      name_last: auth.extra.raw_info.last_name,
      image_url: auth.extra.raw_info.photo_200_orig
    }
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
  end
end