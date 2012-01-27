module OpenSSL
  remove_const(:ASN1)
  ASN1 = Krypt::ASN1

  module ASN1
    # DIFF: class name change
    EndOfContent = EndOfContents

    # DIFF: tagging is not supported
    [Boolean, Integer, Enumerated, BitString, OctetString, UTF8String, NumericString, PrintableString, T61String, VideotexString, IA5String, GraphicString, ISO64String, GeneralString, UniversalString, BMPString, Null, ObjectId, UTCTime, GeneralizedTime, Sequence, Set].each do |klass|
      class << klass
        alias old_new new
        def new(*args)
          if args.size > 1
            if args[2] != :IMPLICIT
              raise "explicit tagging is not supported: #{args[2]}"
            end
            args = [args[0], args[1], args[3]]
          end
          old_new(*args)
        end
      end

      # DIFF: no function style constructor such as ASN1::Integer(5)
      name = klass.to_s.split('::').last
      define_singleton_method(name) { |*args|
        klass.new(*args)
      }
    end

    # DIFF: OpenSSL common names are not supported
    class << ObjectId
      def register(oid, sn, ln)
        true
      end
    end
  end
end
