require 'base64'

module FakePlasticTree
  module Hashes
    
    protected
    
    def encode_prop(hash, keys)
      prop = {}
      prop[:time] ||= Time.now.to_i
      prop[:random] ||= rand(10000000)

      keys.each do |key|
        prop[key] = hash[key] if hash[key]
      end

      dump = Marshal::dump(prop)
      out = Base64.encode64(dump)
      out = out[0...-1] if out[-1, 1] == "\n"
      out
    end

    def decode_prop(out)
      out = out + "\n"
      dump = Base64.decode64(out)
      prop = Marshal::load(dump)
      prop
    rescue
      {} # empty hash
    end
    
  end
end
