module Instagram
  module Response
    def self.create( response_hash, ratelimit_hash )
      data = response_hash&.data&.dup || response_hash
      data = ::Hashie::Mash.new if data.nil?
      data.extend( self )
      data.instance_exec do
        %w{pagination meta}.each do |k|
          next unless response_hash.respond_to?(k)
          response_hash.public_send(k).tap do |v|
            instance_variable_set("@#{k}", v) if v
          end
        end
        @ratelimit = ::Hashie::Mash.new(ratelimit_hash)
      end
      data
    end

    attr_reader :pagination
    attr_reader :meta
    attr_reader :ratelimit
  end
end
