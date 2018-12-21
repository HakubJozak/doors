require_relative 'test_helper'


class Doors::Commands::StartTest < Minitest::Test

  def test_project
    Doors::Commands::Start.new
  end

end
