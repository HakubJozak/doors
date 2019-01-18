module Doors::Naming

  # Example:
  #
  #  ~/time/kdm/october_2018.yml
  #
  def path_for(project, date: Date.today)
    d = if date
          date
        elsif
          Date.new(year, month, 1)
        else
          fail ArgumentError.new("month and year or date must be set")
        end

    d
      .strftime("#{@root}/#{project}/%Y_%B.yml")
      .downcase
  end


end
