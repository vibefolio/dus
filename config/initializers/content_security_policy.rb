# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.script_src  :self, :unsafe_inline
    policy.style_src   :self, :unsafe_inline
    policy.img_src     :self, :data, :blob, "https://images.unsplash.com", "https://*.googleusercontent.com"
    policy.font_src    :self
    policy.connect_src :self
    policy.frame_src   :self
    policy.object_src  :none
  end

  # Report violations without enforcing the policy.
  # 처음에는 report-only로 시작하여 깨지는 것이 없는지 확인
  config.content_security_policy_report_only = true
end
