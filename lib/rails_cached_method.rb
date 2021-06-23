require "rails_cached_method/version"
require "rails_cached_method/railtie"

module RailsCachedMethod
  class CachedProxy
    # disable warning of redefining __send__ and __object_id__
    old = $VERBOSE.dup
    $VERBOSE = nil
    Object.methods.each do |e|
      delegate e, to: :@__object__
    end
    $VERBOSE = old

    def initialize(object, key: nil, expires_in:, parent_key: nil, recache: false)
      @__object__     = object
      @__key__        = key
      @__expires_in__ = expires_in
      @__recache__    = recache
      @__parent_key__ = parent_key
      @__object__
    end

    def __value__
      @__object__
    end

    def method_missing(*args)
      key = ___compose_key__(args)
      if @__recache__
        #puts "deleting: #{key}"
        Rails.cache.delete(key)
      end
      #puts "key: #{key}, expires_in: #{@__expires_in__}, args: #{args}, recache: #{@__recache__}"
      Rails.cache.fetch(key, expires_in: @__expires_in__) do
        CachedProxy.new(
          @__object__.send(*args),
          expires_in: @__expires_in__,
          recache: @__recache__,
          parent_key: key,
        )
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
    def cached(key: nil, expires_in: 1.minute, recache: false)
      CachedProxy.new(
        self,
        key: key,
        expires_in: expires_in,
        recache: recache
      )
    end
  end
end

Object.send :include, RailsCachedMethod::CachedProxyExt