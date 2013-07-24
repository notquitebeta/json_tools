#! /usr/bin/env ruby
#require 'rubygems'
require 'json'
require 'pp'

def file_to_hash filename
  puts "[file_to_hash] filename: #{filename}" if $debug3 
  if File.exists? filename
    json1 = File.read(filename)
    return JSON.parse(json1)
  else
    return Hash.new
  end
end

def merge_hashes *hashes
  puts "[merge_hashes] " if $debug3
  temp_hash = Hash.new
  hashes.each {|h| 
    h.each {|k,v| temp_hash[k] = v}
  }
  return temp_hash
end

def hash_to_json_file hashname, filename
  puts "[hash_to_json_file] filename: #{filename}" if $debug3
  if File.exists? filename
    #prompt user for override
  #else
    File.open(filename, "w") do |f|
      f.write(JSON.pretty_generate(hashname))
    end
  end
end

def file_to_list filename
  return file_get_buffer filename, "array"
end

def file_get_buffer(infile, type="string")
# type represents what is returned and should be "string" or "array"
# if type is something else, nil is returned
# if the infile is not found, nil is returned
  puts "[file_get_buffer] called with file= #{infile}" if $debug3

  if File.exists?(infile)
    string = File.open(infile, 'rb') { |f| f.read }
    if type.eql?("string")
      return string
    elsif type.eql?("array")
      return string.split("\n")
    else
      return nil
    end
  else
    return Array.new if type.eql?("array")
    return nil
  end
end

def list_category obj,list,category, setting=1
  puts "[ist_category] category: #{category}" if $debug3
  list.each do |e| 
    e.chomp
    #pp e
    obj[e] = Hash.new unless obj.has_key?(e)
    obj[e][category] = setting 
  end
  return obj
end

def hash_of_hashes_to_table obj, sep="\t"
  columns = Array.new
  # load all columns into columns array (ordered)
  obj.each {|k,v|
    v.each {|c,e|
      columns.push(c) unless columns.include?(c)
    }
  }

  s = ""
  s += ""+sep+columns.join(sep)+"\n"
  obj.each {|k,v|
    s += k+sep
    columns.each {|c|
      if obj[k].has_key?(c)
        s += obj[k][c].to_s+sep
      else
        s += " "+sep
      end
    }
    s += "\n"
  }
  return s
end

def string_to_file filename, str
  File.open(filename, 'w') {|f| f.write(str) }
end

obj = file_to_hash 'lists.json'
know_list = file_to_list "list1.txt"
vowel_list = file_to_list "list2.txt"

obj = list_category obj,know_list,"known"
obj = list_category obj,vowel_list,"vowel"

tab = hash_of_hashes_to_table obj

string_to_file "table.txt", tab
