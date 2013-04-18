module UsersHelper
  
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 40} )
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  # If no user-specified avatar, use default image
  # Returns customized avatar from Cloudinary
  def avatar_for(user, options = { size: 40})
    size = options[:size]
    if user.avatar.blank?
      image_tag("blankProfile.png", alt: user.name, class: "gravatar", style: "width:#{size}px;")
    else 
      cloudinary_url = user.avatar.to_s.gsub!(/upload\//,"upload/w_#{size},h_#{size},c_thumb,g_faces,a_exif/")
      image_tag(cloudinary_url, alt: user.name, class: "gravatar")
    end
  end
end