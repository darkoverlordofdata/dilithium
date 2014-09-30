#+--------------------------------------------------------------------+
#| filters.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of dilithium
#|
#| dilithium is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Filters for Liquid Compatability
#

_month_short = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
]
_month_long = [
  'January', 'February', 'March', 'April', 'May', 'June'
  'July', 'August', 'September', 'October', 'November', 'Decenber'
]

module.exports = class HuginnFilters

  @date_to_xmlschema: ($0) ->
    $0.toISOString()
  
  @date_to_rfc822: ($0) ->
    $0.toUTCString()
  
  @date_to_string: ($0) ->
    $0.getDate()+' '+_month_short[$0.getMonth()]+' '+$0.getFullYear()
  
  @date_to_long_string: ($0) ->
    $0.getDate()+' '+_month_long[$0.getMonth()]+' '+$0.getFullYear()
  
  @xml_escape: ($0) ->
    escape($0)
  
  @cgi_escape: ($0) ->
    escape($0)
  
  @uri_escape: ($0) ->
    encodeURI($0)
  
  @number_of_words: ($0) ->
    if ($match = $0.match(_word_count))
      $match.length
    else
      0

  @tags: ($0) ->
    $0.tags

  @array_to_sentence_string: ($0) ->
    switch $0.length
      when 0 then ''
      when 1 then $0[0]
      when 2 then "#{$0[0]} and #{$0[1]}"
      else
        $last = $0.pop()
        $0.join(', ')+', and '+$last
  
  @textilize: ($0) ->
    textile($0)
  
  @markdownify: ($0) ->
    md($0)
  
  @jsonify: ($0) ->
    JSON.stringify($0)

