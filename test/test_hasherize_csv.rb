require 'test/unit'
require 'hasherize_csv'

class HasherizeCsvTest < Test::Unit::TestCase
  def setup 
    @f = File.new(File.join(File.expand_path(File.dirname(__FILE__)),"sample_csv.csv"))
    @csv = HasherizeCsv::Csv.new(@f, HasherizeCsv::DefaultOpts::SALESFORCE)

    @g = File.new(File.join(File.expand_path(File.dirname(__FILE__)),"default_sample_csv.csv"))
    @default_csv = HasherizeCsv::Csv.new(@g)
  end

  def teardown
    @f.close
    @g.close
  end

  def test_default_csv
    @default_csv.each { |hash|
      assert_equal({"Heading1"=>"Item1", "Heading2"=>"Item2 & Item2.5", "Heading3"=>" Item3"}, hash) 
    }
  end

  def test_keys
    assert_equal ["Heading1", "Heading2", "H_EA_3__c"], @csv.keys
  end

  def test_hash_file_enumerator
    result = []
    enumerator = @csv.each

    assert_equal({"Heading1"=>"Item1", "Heading2"=>"Item2", "H_EA_3__c"=>"Item3"}, enumerator.next)
  end

  def test_hash_file
    result = []
    @csv.each { |hash|
      result << hash
    }
    assert_equal [{"Heading1"=>"Item1", "Heading2"=>"Item2", "H_EA_3__c"=>"Item3"}, 
      {"Heading1"=>"Email", 
        "Heading2"=>"SUP MAN\n\nWE HAVE LOTS OF MULTILINE EMAILS IN CAPS\n\nTHEY ALSO HAVE LINEBREAKS IN THEM",
        "H_EA_3__c"=>"FinalField"},
        {"Heading1"=>"Blank1", "Heading2"=>"", "H_EA_3__c"=>""}], result
  end

end
