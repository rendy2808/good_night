module ClockInUseCase
  class RecordBuilder
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def perform
      records = ::ClockInRepository.clock_ins_from_following_list(user_id)

      result = []
      on_events = {}

      records.each do |record|
        user_name = record.name
        created_at = record.created_at

        case record.clock_in_type
        when 'good_night'
          on_events[user_name] = created_at
        when 'wake_up'
          if on_events[user_name]
            result << { user_name => created_at - on_events[user_name] }
            on_events.delete(user_name)
          end
        end
      end

      result.sort_by { |hash| hash.values.first }
    end
  end
end
