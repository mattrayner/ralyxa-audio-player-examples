# A simple class to manage communications with the
# database and decide whether ot not we should play our jingle
class JingleHelper
  def self.play?(user_id)
    user = User.first(user_id: user_id)

    return true if user.nil?

    user.played_at < (Time.new - (60 * 3)) # 3 minute limit
  end

  def self.update_timestamp(user_id)
    user = User.first_or_create(user_id: user_id)

    user.played_at = Time.new
    user.save
  end
end
