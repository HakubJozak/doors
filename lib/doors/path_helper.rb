module Doors
  module PathHelper
    # Example:
    #
    #  ~/time/kdm/october_2018.yml
    #
    def path_for(project, d = Date.today)
      d.strftime("#{@root}/#{project}/%Y_%B.yml").downcase
    end
  end
end
