class ClockInRepository
  class << self
    def create(user_id, clock_in_type)
      ClockIn.create!(user_id: user_id, clock_in_type: clock_in_type.to_sym)
    end

    def where_user_id_last(user_id)
      ClockIn.where(user_id: user_id).order(created_at: :desc).first
    end

    def where_user_id(user_id)
      ClockIn.where(user_id: user_id).order(created_at: :desc)
    end

    def clock_ins_from_following_list(user_id)
      start_date = 1.week.ago.beginning_of_day
      end_date = Time.current.end_of_day

      ClockIn
      .select('clock_ins.user_id, users.name, clock_ins.clock_in_type, clock_ins.created_at')
      .joins('INNER JOIN follows ON follows.followed_user_id = clock_ins.user_id')
      .joins('INNER JOIN users ON users.id = follows.followed_user_id')
      .where('follows.user_id = ?', user_id)
      .where(created_at: start_date..end_date)
      .order('clock_ins.created_at ASC')
    end
  end
end
