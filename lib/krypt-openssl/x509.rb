module OpenSSL
  # DIFF [intentional]: X509::Attribute#value= is not supported because ossl depends C-level class object. ossl needs a fix.
  module X509
    class Attribute
      def value=(value)
        raise 'X509::Attribute#value= depends C-level class object in OpenSSL::ASN1'
      end
    end
  end
end
