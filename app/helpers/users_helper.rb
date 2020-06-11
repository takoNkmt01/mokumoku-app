module UsersHelper
  # fetch profile image from active storage
  # if user uploaded image
  def get_profile_image(user_profile_image)
    if user_profile_image.attached?
      user_profile_image
    else
      'no-user.png'
    end
  end
end
