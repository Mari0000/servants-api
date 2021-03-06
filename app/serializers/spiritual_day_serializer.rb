class SpiritualDaySerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :place, :price, :start_date, :end_date, :no_of_servants

  attribute :spiritual_day_servants do |object|
    object.spiritual_day_servants.map do |s|
      {
        id: s.id,
        name: s.user.name
      }
    end
  end
end
