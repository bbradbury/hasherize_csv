require "hasherize_csv/version"

module HasherizeCsv
  module DefaultOpts
    DEFAULT = { :separator => "\n", :value_pattern => /(.[^,]*),?/ }
    SALESFORCE = { :separator => "\r", :value_pattern => /\"(.*?)\"/m }
  end

  class Csv 
    include Enumerable
    attr_accessor :keys, :file, :separator
    def initialize file, opts = {}
      @file = file
      @separator = opts[:separator] || DefaultOpts::DEFAULT[:separator]
      @value_pattern = opts[:value_pattern] || DefaultOpts::DEFAULT[:value_pattern]
      @keys = []
      @keys =  values_from_line next_line 
    end

    def each
      return self.to_enum if !block_given?

      until (hash = next_item).nil?
        yield hash
      end 
    end

    private 
    def next_item 
      if (l = next_line).nil?
        return nil
      else
        return hashify_values( values_from_line l ) 
      end
    end

    def next_line
      @file.gets(@separator) ? $_.chomp : $_
    end

    def hashify_values values
      Hash[keys.zip(values)] if !values.nil? and values.length != 0
    end

    def values_from_line line
      line.scan(@value_pattern).flatten
    end
  end
end
