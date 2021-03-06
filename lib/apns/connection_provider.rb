require 'socket'
require 'openssl'

module APNS
  class ConnectionProvider
    def self.open_connection
      raise "The path to your pem file is not set. (APNS.pem = /path/to/cert.pem)" unless APNS::Config.pem
      raise "The path to your pem file does not exist!" unless File.exist?(APNS::Config.pem)

      context      = OpenSSL::SSL::SSLContext.new
      context.cert = OpenSSL::X509::Certificate.new(File.read(APNS::Config.pem))
      context.key  = OpenSSL::PKey::RSA.new(File.read(APNS::Config.pem), APNS::Config.pass)

      sock         = TCPSocket.new(APNS::Config.host, APNS::Config.port)
      ssl          = OpenSSL::SSL::SSLSocket.new(sock, context)
      ssl.connect

      return sock, ssl
    end
  end
end