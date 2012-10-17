require 'test/unit'
require 'hasherize_csv'

class HasherizeCsvTest < Test::Unit::TestCase
  def setup 
    @f = File.new(File.join(File.expand_path(File.dirname(__FILE__)),"sample_csv.csv"))
    @csv = HasherizeCsv::Csv.new(@f, HasherizeCsv::DefaultOpts::SALESFORCE)
  end

  def teardown
    @f.close
  end

  def test_keys
        assert_equal ["Heading1", "Heading2", "H_EA_3__c"], @csv.keys
  end

  def test_hash_file
       @csv.next { |hash|
         assert_equal({"Heading1"=>"Item1", "Heading2"=>"Item2", "H_EA_3__c"=>"Item3"}, hash) 
       }
   
       @csv.next { |hash|
         assert_equal({"Heading1"=>"Email",
                       "Heading2"=> "SUP MAN\n\nWE HAVE LOTS OF MULTILINE EMAILS IN CAPS\n\nTHEY ALSO HAVE LINEBREAKS IN THEM",
                       "H_EA_3__c"=>"FinalField"}, hash)
       }

       @csv.next { |hash| 
	 assert_equal nil, hash 
       }
  end

  def test_hash_file
       result = []
       @csv.each { |hash|
	 result << hash
       }
       assert_equal [{"Heading1"=>"Item1", "Heading2"=>"Item2", "H_EA_3__c"=>"Item3"}, 
                     {"Heading1"=>"Email", 
                      "Heading2"=>"SUP MAN\n\nWE HAVE LOTS OF MULTILINE EMAILS IN CAPS\n\nTHEY ALSO HAVE LINEBREAKS IN THEM",
                      "H_EA_3__c"=>"FinalField"}], result
  end

end
