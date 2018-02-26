class LunchShuffler
  delegate :previous_lunch, to: :lunch

  def initialize(lunch)
    @lunch  = lunch
  end

  def reshuffle!
    ActiveRecord::Base.transaction do
      lunch.groups.destroy_all
      shuffle!
    end
  end

  def shuffle!
    ActiveRecord::Base.transaction do
      1.upto(group_count) { |i| lunch.groups.create!(name: "#{i}group") }
      groups = lunch.groups.order(:name)
      user_ids = lunch.users.pluck(:id)
      if previous_lunch
        previous_user_ids = previous_lunch.groups.order(:name).flat_map { |group| group.group_members.pluck(:user_id) }
        user_ids = (previous_user_ids & user_ids) + (user_ids - previous_user_ids)
      else
        user_ids = user_ids.shuffle
      end
      index = 0
      user_ids.shuffle.each do |user_id|
        groups[index].group_members.create!(user_id: user_id)
        if index == group_count - 1
          index = 0
        else
          index += 1
        end
      end
      lunch.update!(shuffled_at: Time.current)
    end
    true
  end

  private

  attr_reader :lunch

  def group_count
    quotient, remainder = member_count.divmod(4)
    return 1 if quotient.zero?
    case remainder
    when 0 then quotient
    when 1 then quotient == 2 ? 3 : quotient
    when 2 then quotient < 3 ? quotient + 1 : quotient
    when 3..4 then quotient + 1
    end
  end

  def member_count
    @member_count ||= lunch.participations.count
  end
end
