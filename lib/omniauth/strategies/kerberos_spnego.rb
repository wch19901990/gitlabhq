require 'omniauth'

module OmniAuth
  module Strategies
    class KerberosSpnego
      include OmniAuth::Strategy
      include Gitlab::Routing.url_helpers

      option :name, 'kerberos_spnego'

      uid { username }

      info do
        { username: username, email: email }
      end

      def username
        principal_name.split('@')[0]
      end

      def email
        username + '@' + principal_name.split('@')[1].downcase
      end

      def principal_name
        return @principal_name if defined?(@principal_name)

        @principal_name = session.delete(:kerberos_spnego_principal_name)
      end

      def request_phase
        redirect users_auth_kerberos_spnego_negotiate_path
      end
    end
  end
end
