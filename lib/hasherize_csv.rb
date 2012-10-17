require "hasherize_csv/version"

module HasherizeCsv
   class Salesforce
     attr_accessor :keys, :file, :separator
     def initialize file, opts = {}
	@file = file
	@separator = opts[:separator] || "\r"
	@keys = []
	next_line { |l| @keys = values_from_line l if !l.nil? }
     end

     def next 
	next_line { |l|
	   return nil if l.nil? 

	   yield hashify_values( values_from_line l ) 
	   return true
	}
     end
 
     def each
        while(1) do
	   self.next { |hash|
	     return nil if hash.nil?
             yield hash
	   }
        end 
     end

    private 
     def next_line 
	yield(@file.gets(@separator))
     end

     def hashify_values values
        Hash[keys.zip(values)] if !values.nil? and values.length != 0
     end

     def values_from_line line
	line.scan(/\"(.*?)\"/m).flatten
     end
   end
end
