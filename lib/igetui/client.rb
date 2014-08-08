module IGeTui
  class Client
    attr_accessor :client_id

    def initialize(client_id)
      @client_id = client_id
    end
  end
end
