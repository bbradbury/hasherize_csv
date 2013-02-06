# HasherizeCsv
[![Build Status](https://travis-ci.org/bbradbury/hasherize_csv.png)](https://travis-ci.org/bbradbury/hasherize_csv)

Dead simple CSV parsing, with configurable regex selectors if required. 
Reads line-by-line, so you can parse big CSV files without running out of memory.
The first line is always assumed to be column headers, and thus keys in the corresponding hash.

### Simple case
Given sample_csv.csv
```csv
Col1,Col2,Col3
Val1,Val2,Val3
Val4,Val5,Val6
```

and
```ruby
require 'hasherize_csv'
@f = File.new("sample_csv.csv")
@csv = HasherizeCsv::Csv.new(@f)

@csv.each do |hash|
   puts hash.inspect
end
```

The output will be
```
{'Col1' => 'Val1', 'Col2' => 'Val2', 'Col3' => 'Val3'}
{'Col1' => 'Val4', 'Col2' => 'Val5', 'Col3' => 'Val6'}
```

### Complex case: parse strange line endings and elegantly select values
Given complex_sample.csv
```csv
"Col1";"Col2";"Col3"\r
"Val1";"Val2";"Val3"\r
"Val4";"Val5

Oh my, newlines in the record!";"Val6"\r
```

and
```ruby
require 'hasherize_csv'
@f = File.new("sample_csv.csv")

#HasherizeCsv yields the value of the first match group in the :value_pattern regex
@csv = HasherizeCsv::Csv.new(@f, :separator => "\r", :value_pattern => /\"(.*?)\"/m)

@csv.each do |hash|
   puts hash.inspect
end
```

The output will be
```
{'Col1' => 'Val1', 'Col2' => 'Val2', 'Col3' => 'Val3'}
{'Col1' => 'Val4', 'Col2' => 'Val5\n\nOh my, newlines in the record!', 'Col3' => 'Val6'}
```

