module Sprinkle
  module Verifiers
    module MD5match
      Sprinkle::Verify.register(MD5match)
      def match_local_remote(localfile, remotefile, mode=nil)
        raise "Couldn't find local file #{localfile}" unless ::File.exists?(localfile)
        local = `md5sum #{localfile}`.split.first
        @commands << %{[ "X$(md5sum #{remotefile} | awk \'{print $1}\')" = "X#{local}" ]}
      end
    
      def match_remote_remote(fileA, fileB, mode=nil)
        @commands << %{[ "X$(md5sum #{fileA} | awk \'{print $1}\')" = "X$(md5sum #{fileB} | awk \'{print $1}\')" ]} 
      end
    end
  end
end
