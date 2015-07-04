class Visit < ActiveRecord::Base

  validates_presence_of  :mobile_no, :friend_mobile_no
  validates_length_of :mobile_no,    :is => 10
  validates_length_of :friend_mobile_no,    :is => 10
  validates_format_of :mobile_no, :with => /\A[0-9]+\Z/, :message => " : Please enter correct Mobile No", :allow_blank => true
  validates_format_of :friend_mobile_no, :with => /\A[0-9]+\Z/, :message => " : Please enter correct Mobile No", :allow_blank => true

  # Callbacks
  before_create :check_for_only_five_attempts_per_minutes
  before_create :check_for_mobile_score
  before_create :check_for_mobile_start_digit
  before_create :check_for_same_mobile
  before_create :set_visit_time

  def check_for_only_five_attempts_per_minutes
    visit = Visit.where('mobile_no = ? and friend_mobile_no = ? and created_at > ?', self.mobile_no, self.friend_mobile_no ,(Time.now - 1.minute))
    if visit.count >= 5
      self.errors.add(:only, " Five attempts permitted per minutes for same user")
      return false
    else
      return true
    end
  end

  def set_visit_time
    v_time = get_visited_time
    self.visited_time = v_time
    if v_time.present?
      self.visited_flag = true
    else
      self.visited_flag = false
    end
    return true
  end

  def get_visited_time
    t_search = Visit.where('mobile_no = ? and friend_mobile_no = ?', self.mobile_no, self.friend_mobile_no).order('id desc').limit(10)
    t_search_count = t_search.count
    # rt_search = Visit.where('mobile_no = ? and friend_mobile_no = ?', self.friend_mobile_no, self.mobile_no).order('id desc').limit(10)
    rt_search_count = Visit.where('mobile_no = ? and friend_mobile_no = ?', self.friend_mobile_no, self.mobile_no).order('id desc').limit(10).count
    p "........ #{t_search} ........... #{t_search_count}  ........... #{rt_search_count}"
    if (t_search_count == 0) and (rt_search_count == 0)
      get_time_type_one
    elsif (t_search_count == 0) and (rt_search_count > 0)
      get_time_type_two(rt_search_count)
    elsif (t_search_count > 0) and (rt_search_count == 0)
      get_time_type_three(t_search[0])
    else
      get_time_type_four(t_search[0])
    end
  end

  def get_time_type_one
    if rand(100) > 75
      get_random_time
    else
      return nil
    end
  end

  def get_time_type_two(rt_search_count)
    if rand(100) > (rt_search_count*10 - rand(50))
      get_random_time
    else
      return nil
    end 
  end

  def get_time_type_three(last_data)
    if last_data.visited_time.blank?
      if rand(100) > 50
        if rand(100) > 50
          Time.now - rand(5).minutes
        else
          last_data.visited_time
        end
      else
        return nil
      end
    else
      if rand(100) > 50 and (last_data.created_at < (Time.now - 5.minutes))
        Time.now - rand(5).minutes
      else
        last_data.visited_time
      end
    end
  end

  def get_time_type_four(last_data)
    if last_data.visited_time.blank?
      if rand(100) > 50
        if rand(100) > 50
          Time.now - rand(5).minutes
        else
          last_data.visited_time
        end
      else
        return nil
      end
    else
      if rand(100) > 50 and (last_data.created_at < (Time.now - 5.minutes))
        Time.now - rand(5).minutes
      else
        last_data.visited_time
      end
    end
  end

  def get_random_time
    rand_min = rand(100)
    if rand_min > -1 and rand_min <= 25
      return Time.now - rand(60).minutes
    elsif rand_min > 25 and rand_min <= 50
      return Time.now - rand(500).minutes
    elsif rand_min > 50 and rand_min <= 75
      return Time.now - rand(1000).minutes
    else
      return Time.now - rand(1500).minutes
    end
  end

  def check_for_mobile_score
    mobile_no_score = mobile_score(self.mobile_no)
    friend_mobile_no_score = mobile_score(self.friend_mobile_no)
    if mobile_no_score.in?(4..8) and friend_mobile_no_score.in?(4..8)
      return true
    else
      if !mobile_no_score.in?(4..8)
        self.errors.add(:please, " enter correct Mobile Number")
      else
        self.errors.add(:please, " enter correct Friend Mobile Number")
      end
      return false
    end
  end

  def check_for_mobile_start_digit
    if self.mobile_no[0].to_i.in?(7..9) and self.friend_mobile_no[0].to_i.in?(7..9)
      return true
    else
      if !self.mobile_no[0].to_i.in?(7..9)
        self.errors.add(:please, " enter correct Mobile Number")
      else
        self.errors.add(:please, " enter correct Friend Mobile Number")
      end
      return false
    end
  end

  def check_for_same_mobile
    if self.mobile_no == self.friend_mobile_no
      self.errors.add(:error, " Same Mobile Number Not allowed")
      return false
    else
      return true
    end
  end

  def mobile_score(mobile)
    mobile.split(//).uniq.count
  end
end
