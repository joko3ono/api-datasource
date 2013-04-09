module Momod
  class Markas
    def self.list_url(url=nil); @list_url = url ? url : @list_url end
    def self.show_url(url=nil); @show_url = url ? url : @show_url end
    def self.save_url(url=nil); @save_url = url ? url : @save_url end
    def self.update_url(url=nil); @update_url = url ? url : @update_url end
    def self.delete_url(url=nil); @delete_url = url ? url : @delete_url end

    def initialize(*var)
      var = var.first
      if var and var.length > 0
        Momod::MomodHelper.parse_to_class var, self
      end
    end

    def self.attr_accessible(*vars)
      @attr_accessible ||= vars
    end

    def self.attr_accessor(*vars)
      @attributes ||= []
      @attributes.concat vars
      super(*vars)
    end

    def self.attributes
      @attributes
    end

    def attributes
      @attributes
    end

    def self.list(*args)
      if args.blank? or (args.class == Array and args.first.class == Hash)
        params = ( args.class == Array ? args.first : args )
        if self.list_url.eql?(Markas.list_url)
          self.list_url("/#{self.name.downcase.pluralize}")
          Momod::Markas.list_url("/#{self.name.downcase.pluralize}")
        end
        self.process_resp Typhoeus::Request.send(:get, Momod::DOMAIN + self.list_url , { params: params })
      else
        { status: 'error', body: "Invalid Parameter" }
      end
    end

    def self.show(*args)
      if args.blank?
        { status: 'error', body: "Invalid Parameter" }
      else
        params = args.last.equal?(args.first) ? {} : args.last
        id = args.first.class == Hash ? args.first[:id] : args.first
        if self.show_url.eql?(Markas.show_url)
          puts "here #{id}"
          self.show_url("/#{self.name.downcase.pluralize}/#{id}")
          Momod::Markas.show_url("/#{self.name.downcase.pluralize}/#{id}")
        end
        self.process_resp Typhoeus::Request.send(:get, Momod::DOMAIN + self.show_url , { params: params })
      end
    end

    def self.create(*args)
      args = args.first
      obj = self.new args
      obj.save
    end

    def self.process_resp(response, object = nil)
      begin
        bind = binding
        responses = []
        data = JSON.parse(response.body)
        if data.class == Array
          data.each do |datum|
            responses << Momod::MomodHelper.parse_to_class(datum, object || self.new)
          end
        else
          responses = Momod::MomodHelper.parse_to_class(data, object || self.new)
        end
        return responses
      rescue Exception => e
        raise e.inspect
      end
    end

    def save
      #TODO need to be changed in case not using id for primary-key
      if self.id
        self.class.update_the_data self
      else
        self.class.save_the_data self
      end
    end

    def update_attributes *args
      args = args.first
      if args and args.length > 0
        attrs = self.class.attr_accessible
        new_args = Hash.new
        args.map { |key,arg| eval("attrs.include?(:#{key}) ? new_args[:#{key}] = arg : ''") }
        Momod::MomodHelper.parse_to_class new_args, self
      end
      #TODO need to be changed in case not using id for primary-key
      self.class.update_the_data self, args
    end

    def destroy
      self.class.delete_url("/#{self.class.name.downcase.pluralize}/#{self.id}") if self.class.delete_url.eql?(Momod::Markas.delete_url)
      self.class.process_resp Typhoeus::Request.send(:delete, Momod::DOMAIN + self.class.delete_url , { params: {} })
    end

    private

    def self.save_the_data those
      params = Momod::MomodHelper.fetch_field those
      those.class.save_url("/#{those.class.name.downcase.pluralize}") if those.class.save_url.eql?(Momod::Markas.save_url)
      those.class.process_resp Typhoeus::Request.send(:post, Momod::DOMAIN + those.class.save_url, { params: params }), those
    end

    def self.update_the_data those, args = {}
      params = Momod::MomodHelper.fetch_field those
      those.class.save_url("/#{those.class.name.downcase.pluralize}/#{those.id}") if those.class.save_url.eql?(Momod::Markas.save_url)
      those.class.process_resp Typhoeus::Request.send(:put, Momod::DOMAIN + those.class.save_url, { params: params }), those
    end

  end

end
