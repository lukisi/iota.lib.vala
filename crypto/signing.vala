using Gee;

namespace IotaLibVala
{
    public class Signing : Object
    {
        private static Signing _instance;
        public static Signing singleton {
            get {
                if (_instance == null) _instance = new Signing();
                return _instance;
            }
        }

        private Signing()
        {
            // nop
        }

        public Gee.List<int64?> key(Gee.List<int64?> seed, int index, int length)
        {
            Gee.List<int64?> subseed = seed.slice(0, seed.size);

            for (var i = 0; i < index; i++) {
                for (var j = 0; j < 243; j++) {
                    subseed[j] = subseed[j] + 1;
                    if (subseed[j] > 1) {
                        subseed[j] = -1;
                    } else {
                        break;
                    }
                }
            }

            var curl = new Curl();
            curl.init();
            curl.absorb(subseed);
            subseed = curl.squeeze();

            curl.reset();
            curl.absorb(subseed);

            ArrayList<int64?> ret = new ArrayList<int64?>();
            Gee.List<int64?> buffer;

            while (length-- > 0) {
                for (var i = 0; i < 27; i++) {
                    buffer = curl.squeeze();
                    for (var j = 0; j < 243; j++) {
                        ret.add(buffer[j]);
                    }
                }
            }

            return ret;
        }

        public Gee.List<int64?> digests(Gee.List<int64?> key)
        {
            error("not implemented yet");
        }

        public Gee.List<int64?> address(Gee.List<int64?> digests)
        {
            error("not implemented yet");
        }
    }
}