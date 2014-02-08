require_relative 'helper'


class TestSearchingLocations < LocationTest

# to run a single line test
#$ ruby test/test_entering_purchases --name test_valid_purchase_gets_saved

  @@sample_inputs_write_1 = ['1','Wilmington','DE','2','computer and IT professionals','77','my wife loves it','5']
  @@sample_inputs_write_2 = ['1','Easton','de','1','factory and farming major industries','32','my uncle lives there','5']
  @@sample_inputs_write_3 = ['1','Plymouth','MA','1','ship building, masonry','93','near the ocean','5']
  @@sample_inputs_write_4 = ['1','Ocean city','NJ','2','shipping and fishing','12','many of my friends live there','5']
  @@sample_inputs_write_5 = ['1','Helena','MT','1','forestry and mining','25','lots of fresh air','5']
  @@sample_inputs_search = ['2','2','5']


  def test_search_by_state_code
    pipe_it @@sample_inputs_write_1
    pipe_it @@sample_inputs_write_2
    pipe_it @@sample_inputs_write_3
    pipe_it @@sample_inputs_write_4
    pipe_it @@sample_inputs_write_5
    options = {:state_code => 'DE'}
    locations = Location.search(options)
    result = []
    locations.each do |location|
      result << [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    end
    expected = [['Wilmington','DE','Temperate','computer and IT professionals',77,'my wife loves it'],['Easton','DE','Cool','factory and farming major industries',32,'my uncle lives there']]
    assert_equal expected, result
  end

  def test_search_by_climate
    pipe_it @@sample_inputs_write_1
    pipe_it @@sample_inputs_write_2
    pipe_it @@sample_inputs_write_3
    pipe_it @@sample_inputs_write_4
    pipe_it @@sample_inputs_write_5
    options = {:climate => 'Cool'}
    locations = Location.search(options)
    result = []
    locations.each do |location|
      result << [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    end
    expected = [['Easton','DE','Cool','factory and farming major industries',32,'my uncle lives there'],['Plymouth','MA','Cool','ship building, masonry',93,'near the ocean'],['Helena','MT','Cool','forestry and mining',25,'lots of fresh air']]
    assert_equal expected, result
  end

  def test_search_by_employment_outlook
    pipe_it @@sample_inputs_write_1
    pipe_it @@sample_inputs_write_2
    pipe_it @@sample_inputs_write_3
    pipe_it @@sample_inputs_write_4
    pipe_it @@sample_inputs_write_5
    options = {:employment_outlook => 'ship'}
    locations = Location.search(options)
    result = []
    locations.each do |location|
      result << [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    end
    expected = [['Plymouth','MA','Cool','ship building, masonry',93,'near the ocean'],['Ocean city','NJ','Temperate','shipping and fishing',12,'many of my friends live there']]
    assert_equal expected, result
  end

  def test_search_by_cost_of_living
    pipe_it @@sample_inputs_write_1
    pipe_it @@sample_inputs_write_2
    pipe_it @@sample_inputs_write_3
    pipe_it @@sample_inputs_write_4
    pipe_it @@sample_inputs_write_5
    options = {:greater_than => 90}
    locations = Location.search(options)
    result = []
    locations.each do |location|
      result << [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    end
    expected = [['Plymouth','MA','Cool','ship building, masonry',93,'near the ocean']]
    assert_equal expected, result
  end

  def test_range_by_cost_of_living
    pipe_it @@sample_inputs_write_1
    pipe_it @@sample_inputs_write_2
    pipe_it @@sample_inputs_write_3
    pipe_it @@sample_inputs_write_4
    pipe_it @@sample_inputs_write_5
    options = {:greater_than => 20, :less_than => 30}
    locations = Location.search(options)
    result = []
    locations.each do |location|
      result << [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    end
    expected = [['Helena','MT','Cool','forestry and mining',25,'lots of fresh air']]
    assert_equal expected, result
  end

  def test_search_by_notes
    pipe_it @@sample_inputs_write_1
    pipe_it @@sample_inputs_write_2
    pipe_it @@sample_inputs_write_3
    pipe_it @@sample_inputs_write_4
    pipe_it @@sample_inputs_write_5
    options = {:notes => 'UNCLE'}
    locations = Location.search(options)
    result = []
    locations.each do |location|
      result << [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    end
    expected = [['Easton','DE','Cool','factory and farming major industries',32,'my uncle lives there']]
    assert_equal expected, result
  end

  def test_search_by_all_parameters
    pipe_it @@sample_inputs_write_1
    pipe_it @@sample_inputs_write_2
    pipe_it @@sample_inputs_write_3
    pipe_it @@sample_inputs_write_4
    pipe_it @@sample_inputs_write_5
    options = {:state_code => 'DE', :climate => 'Temperate', :employment_outlook => 'IT', :greater_than => 75, :less_than => 80, :notes => 'wife'}
    locations = Location.search(options)
    result = []
    locations.each do |location|
      result << [location.city, location.state_code, location.climate, location.employment_outlook, location.cost_of_living, location.notes]
    end
    expected = [['Wilmington','DE','Temperate','computer and IT professionals',77,'my wife loves it']]
    assert_equal expected, result
  end
end