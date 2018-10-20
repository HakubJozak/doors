require_relative 'test_helper'


class StoreTest < Minitest::Test

  def test_to_hash
    store = Doors::Store.new('test/files/store')
    assert_equal store.to_hash, {
      2018=>
      {"october"=>
       {"01_monday"=>["11:51:33 - 13:00:14", "13:46:28 - 16:13:00", "16:24:11 - 17:17:26"],
        "03_wednesday"=>[{"duration"=>"02:08:00"}, "16:15:55 - 17:10:00"],
        "04_thursday"=>["10:02:00 - 11:22:00", "11:29:48 - 14:22:24"],
        "05_friday"=>["10:49:52 - 11:06:57", "13:18:43 - 13:29:40", "16:02:11 - 18:35:17"],
        "08_monday"=>["11:45:00 - 12:45:00"],
        "09_tuesday"=>["12:44:55 - 12:45:51", "13:21:25 - 15:03:11"]
       },
       "september"=>{"01_saturday"=>["11:51:33 - 13:00:14"] }
      }
    }
  end



end
