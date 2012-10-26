require "hasherize_csv/version"

module HasherizeCsv
  module DefaultOpts
    DEFAULT = { :separator => "\n", :value_pattern => /([^,]+[\s\w_-]+),?/ }
    SALESFORCE = { :separator => "\r", :value_pattern => /\"(.*?)\"/m }
  end

  class Csv 
    attr_accessor :keys, :file, :separator
    def initialize file, opts = {}
      @file = file
      @separator = opts[:separator] || DefaultOpts::DEFAULT[:separator]
      @value_pattern = opts[:value_pattern] || DefaultOpts::DEFAULT[:value_pattern]
      @keys = []
      next_line { |l| @keys = values_from_line l if !l.nil? }
    end

    def next_item 
      next_line { |l|
        if l.nil?
          yield nil
        else
          yield hashify_values( values_from_line l ) 
        end
      }
    end

    def each
      while(1) 
        self.next_item { |hash|
          return if hash.nil?
          yield hash
        }
      end 
    end

    private 
    def next_line
      yield(@file.gets(@separator) ? $_.chomp : $_) 
    end

    def hashify_values values
      Hash[keys.zip(values)] if !values.nil? and values.length != 0
    end

    def values_from_line line
      line.scan(@value_pattern).flatten
    end
  end
end
