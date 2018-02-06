class GroupBuilder
  delegate :previous_lunch, to: :lunch

  def initialize(lunch)
    @lunch  = lunch
  end

  def build!
    ActiveRecord::Base.transaction do
      1.upto(group_count) { |i| lunch.groups.create!(name: "#{i}group") }
      groups = lunch.groups.order(:name)
      # if previous_lunch
      #   # noop
      # else
      index = 0
      lunch.users.shuffle.each do |user|
        groups[index].group_members.create!(user: user)
        if index == group_count - 1
          index = 0
        else
          index += 1
        end
      end
      # end
      lunch.update!(shuffled_at: Time.current)
    end
    true
  end

  def to_json
    {
      "text": "Shuffle lunch group of today\n#{lunch.groups.map(&:text).join("\n")}",
      "response_type": "in_channel",
    }.to_json
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
