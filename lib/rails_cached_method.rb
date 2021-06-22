require "rails_cached_method/version"
require "rails_cached_method/railtie"

module RailsCachedMethod
  class CacheedProxy
    def initialize(object, key: nil, expires_in:, parent_key: nil)
      @__object__     = object
      @__key__        = key
      @__expires_in__ = expires_in
      @__parent_key__ = parent_key
      @__object__
    end

    def to_s
      @__object__.to_s
    end

    def inspect
      @__object__.inspect
    end

    def method_missing(*args)
      __parent_key__ = ___compose_key__(args)
      puts "key: #{__parent_key__}, expires_in: #{@__expires_in__}, args: #{args}"

      Rails.cache.fetch(__parent_key__, expires_in: @__expires_in__) do
        CacheedProxy.new(@__object__.send(*args), expires_in: @__expires_in__, parent_key: __parent_key__)
      end
    end

    private
    def ___compose_key__(args)
      result = [@__parent_key__, @__key__]

      result += if @__object__.respond_to?(:to_global_id)
        [@__object__.to_global_id]
      elsif @__object__.is_a?(ActiveRecord::Relation)
        [@__object__.class]
      else
        [@__object__]
      end
      result += args[0..1]

      result.compact.map(&:to_s).join('.').dasherize
    end
  end

  module CachedProxyExt
    def cached(key: nil, expires_in: 1.minute)
      CacheedProxy.new(self, key: key, expires_in: expires_in)
    end
  end
end

Object.send :include, RailsCachedMethod::CachedProxyExt