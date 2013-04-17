module UsersHelper
  
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 40} )
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  # Returns the user-uploaded avatar from Amazon S3
  def avatar_for(user, options = { size: 40})
    size = options[:size]
    if user.avatar.blank?
      avatar_url = "blankProfile.png"
      image_tag(avatar_url, alt: user.name, class: "gravatar", style: "width:#{size}px;")
    else
      avatar_url = user.avatar.to_s
      cl_image_tag(avatar_url, alt: user.name, class: "gravatar", width: "#{size}", height: "#{size}", :crop => :scale, :gravity => :face)
    end
  end
end