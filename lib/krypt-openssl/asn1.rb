require 'stringio'

module OpenSSL
  remove_const(:ASN1)
  ASN1 = Krypt::ASN1

  module ASN1
    # DIFF: class name change
    EndOfContent = EndOfContents

    # DIFF [intentional]: tagging is not supported 
    class ASN1Data
      attr_accessor :tagging
    end
    [Boolean, Integer, Enumerated, BitString, OctetString, UTF8String, NumericString, PrintableString, T61String, VideotexString, IA5String, GraphicString, ISO64String, GeneralString, UniversalString, BMPString, Null, ObjectId, UTCTime, GeneralizedTime, Sequence, Set, ASN1Data].each do |klass|
      class << klass
        alias old_new new
        def new(*args)
          if args.size > 1
            if args[2] && args[2] != :IMPLICIT
              raise "explicit tagging is not supported: #{args[2]}"
            end
            args = [args[0], args[1], args[3] || :CONTEXT_SPECIFIC]
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

    # DIFF: different tag number constant names
    OBJECT = OBJECT_ID
    [:UTF8STRING, :NUMERICSTRING, :PRINTABLESTRING, :T61STRING, :VIDEOTEXSTRING, :IA5STRING, :GRAPHICSTRING, :ISO64STRING, :GENERALSTRING, :UNIVERSALSTRING, :BMPSTRING].each do |name|
      const_set(name, const_get(name.to_s.sub(/STRING$/, '_STRING')))
    end

    # DIFF [intentional]: Krypt handles UTF8 encoding correctly
    class UTF8String
      alias old_value value
      def value
        v = old_value
        v.force_encoding("ASCII-8BIT")
        v
      end
    end

    # DIFF [intentional]: OpenSSL common names are not supported
    class ObjectId
      MAP = {
        '2.5.29.19' => 'basicConstraints',
        '1.2.840.113549.1.1.1' => 'rsaEncryption',
        '1.2.840.10040.4.1' => 'DSA'
      }

      class << self
        def register(oid, sn, ln)
          true
        end

        alias object_id_new new
        def new(*args)
          if MAP.value?(args[0])
            args[0] = MAP.key(args[0])
          end
          object_id_new(*args)
        end
      end

      alias object_id_value value
      def value
        v = object_id_value
        if MAP.key?(v)
          v = MAP[v]
        end
        v
      end

      def sn
        raise 'OpenSSL common names are not supported'
      end
      alias oid sn
    end

    # DIFF: ASN1.decode_all is not implemented
    class << self
      def decode_all(str)
        raise 'StringIO as IO is not supported?'
        io = StringIO.new(str)
        ary = []
        while !io.eof?
          ary << decode(io)
        end
        ary
      end
    end
  end
end
