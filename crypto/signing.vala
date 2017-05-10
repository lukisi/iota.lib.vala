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
            Gee.List<int64?> ret = new ArrayList<int64?>();
            Gee.List<int64?> buffer;
            for (var i = 0; i < Math.floor(key.size / 6561); i++) {
                var key_fragment = key.slice(i * 6561, (i + 1) * 6561);
                for (var j = 0; j < 27; j++) {
                    buffer = key_fragment.slice(j * 243, (j + 1) * 243);
                    for (var k = 0; k < 26; k++) {
                        var k_curl = new Curl();
                        k_curl.init();
                        k_curl.absorb(buffer);
                        buffer = k_curl.squeeze();
                    }
                    for (var k = 0; k < 243; k++) {
                        key_fragment[j * 243 + k] = buffer[k];
                    }
                }
                var curl = new Curl();
                curl.init();
                curl.absorb(key_fragment);
                buffer = curl.squeeze();
                for (var j = 0; j < 243; j++) {
                    ret.add(buffer[j]);
                }
            }
            return ret;
        }

        public Gee.List<int64?> address(Gee.List<int64?> digests)
        {
            var curl = new Curl();
            curl.init();
            curl.absorb(digests);
            return curl.squeeze();
        }
    }
}