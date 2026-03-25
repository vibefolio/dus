require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Kakao < OmniAuth::Strategies::OAuth2
      option :name, 'kakao'

      option :client_options, {
        site: 'https://kauth.kakao.com',
        authorize_url: 'https://kauth.kakao.com/oauth/authorize',
        token_url: 'https://kauth.kakao.com/oauth/token',
        # 카카오는 client_id를 request body에 포함해야 함 (Basic Auth 미지원)
        auth_scheme: :request_body
      }

      uid { raw_info['id'].to_s }

      info do
        {
          'name' => raw_info.dig('properties', 'nickname'),
          'nickname' => raw_info.dig('properties', 'nickname'),
          'image' => raw_info.dig('properties', 'profile_image'),
          'email' => raw_info.dig('kakao_account', 'email')
        }
      end

      def raw_info
        @raw_info ||= access_token.get('https://kapi.kakao.com/v2/user/me').parsed
      end

      # redirect_uri에 쿼리 파라미터가 붙지 않도록 고정 URL 반환
      # (origin 파라미터가 redirect_uri에 포함되면 카카오 콘솔 등록 URI와 불일치 KOE006)
      def callback_url
        full_host + script_name + callback_path
      end

      def authorize_params
        super.tap do |params|
          params[:scope] = 'profile_nickname,profile_image,account_email'
        end
      end
    end
  end
end
