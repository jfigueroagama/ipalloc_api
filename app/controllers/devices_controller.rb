class DevicesController < ApplicationController
  require "csv"
  require "ipaddress"
  respond_to :json

  def show
    @device = ""
    if params[:address].present?
      ip = params[:address]
      if IPAddress.valid? ip
        @ip = IPAddress(params[:address])
        octets = @ip.octets
        if octets[0] == 1 && octets[1] == 2
          @device = get_address(@ip.address.to_s)
          if @device.nil?
            @response = { "error"=>"not found", "ip" => @ip.address}
            respond_with @response, status: :not_found
          else
            @response = { "device" => @device, "ip" => @ip.address}
            respond_with @response, status: :ok
          end
        else
          @response = { "error"=>"wrong request: the first to octets must be '1.2.''"}
          respond_with @response, status: :bad_request
        end
      else
        @response = { "error"=>"bad request: invalid ip address"}
        respond_with @response, status: :bad_request
      end
    end
  end

  private

  def get_address(address)
    file = File.open("IPAlloc.csv", "r+")
    CSV.foreach(file, headers: true) do |row|
      ip_block = row[0]
      ip_address = row[1].to_s
      ip_device = row[2].to_s
      if ip_address == address
        return ip_device
      end
    end
  end
end
