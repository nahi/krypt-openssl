module OpenSSL
  # DIFF: X509::Attribute#value= is not supported
  module X509
    class Attribute
      def value=(value)
        raise 'X509::Attribute#value= depends C-level class object in OpenSSL::ASN1'
      end
    end
  end
end
