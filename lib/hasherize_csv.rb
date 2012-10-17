require "hasherize_csv/version"

module HasherizeCsv
   module DefaultOpts
     SALESFORCE = { :separator => "\r", :value_pattern => /\"(.*?)\"/m }
     
   end
 
   class Csv 
     attr_accessor :keys, :file, :separator
     def initialize file, opts = {}
	@file = file
	@separator = opts[:separator] || "\n"
        @value_pattern = opts[:value_pattern] || /([\s\w_-]+),?/
	@keys = []
	next_line { |l| @keys = values_from_line l if !l.nil? }
     end

     def next 
	next_line { |l|
	   return nil if l.nil? 
	   yield hashify_values( values_from_line l ) 
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
	line.scan(@value_pattern).flatten
     end
   end
end
