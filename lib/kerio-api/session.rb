require 'json'
require 'httparty'
require 'kerio-api/error'
require 'uri'
require 'pp'

module Kerio
  module Api
    class Session
      attr_writer :token

      def initialize(url, verify_ssl, debug)
        @url = url

        @verify_ssl = verify_ssl
        @debug = debug
        @token = nil
        @cookie = nil
      end

      def headers
        headers = {}
        headers['X-Token'] = @token if not @token.nil?
        headers['Cookie'] = @cookie if not @cookie.nil?
        headers['Accept-Encoding'] = 'identity'

        headers
      end

      def process_json_response(resp)
        @cookie = resp.headers['Set-Cookie'] if not resp.headers['Set-Cookie'].nil?

        raise Kerio::Api::Error.new(resp) if ((not resp["error"].nil?) || (resp.code != 200))
      end

      def json_method(name, params)

        h = headers
        h['Accept'] = 'application/json-rpc'

        body = {
          jsonrpc: '2.0',
          id: Kernel.rand(10 ** 12),
          method: name,
          params: params,
        }
        body['token'] = @token if not @token.nil?

        PP.pp body if @debug

        options = {
          body: JSON.generate(body),
          headers: h,
          verify: @verify_ssl,
          follow_redirects: true,
        }
        options[:debug_output] = $stdout if @debug
        resp = HTTParty.post(
          @url.to_s,
          options
        )

        PP.pp resp if @debug

        process_json_response(resp)
        return resp
      end

      def upload_file(file)
        h = headers
        h['Accept'] = '*/*'
        h['Content-Type'] = 'multipart/form-data';

        options = {
          headers: h,
          verify: @verify_ssl,
          query: {
            'newFile.bin' => file,
          },
          follow_redirects: true,
        }
        options[:debug_output] = $stdout if @debug

        resp = HTTParty.post(
          @url.to_s + '/upload',
          options
        )

        process_json_response(resp)
        return resp
      end

      def download_file(path)
        h = headers
        h['Accept'] = '*/*'
        h['Accept-Encoding'] = 'identity'
        puts h.inspect

        u = URI.parse("#{@url.scheme}://#{@url.host}:#{@url.port}#{path}")
        options = {
          headers: h,
          verify: @verify_ssl,
          stream_body: true,
          follow_redirects: true
        }
        resp = HTTParty.get(
          u.to_s,
          options
        )

        raise Kerio::Api::Error.new(resp) if resp.code != 200

        return { "result" => { "code" => resp.code } }
      end
    end
  end
end
