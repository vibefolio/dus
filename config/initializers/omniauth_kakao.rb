# Zeitwerk autoloader가 OmniAuth::Strategies::Kakao와 Omniauth::Strategies::Kakao를 혼동하므로
# lib/omniauth를 autoload에서 제외하고 여기서 직접 require합니다
require File.expand_path('../../../lib/omniauth/strategies/kakao', __FILE__)
