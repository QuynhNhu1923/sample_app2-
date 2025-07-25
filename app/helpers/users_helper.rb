module UsersHelper
  GRAVATAR_SIZE = 80
  def gravatar_for user, options = {size: GRAVATAR_SIZE}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gavatar_url = "#{Settings.gravatar_base_url}/#{gravatar_id}?s=#{size}"
    image_tag(gavatar_url, alt: user.name, class: "gravatar")
  end
end
