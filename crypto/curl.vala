using Gee;

namespace IotaLibVala
{
    public class Curl : Object
    {
        private CCurl.Curl._Curl _curl;
        public Curl()
        {
            _curl = CCurl.Curl._Curl();
        }

        public void init()
        {
            CCurl.Curl.init_curl(&_curl);
        }

        public void absorb(Gee.List<int64?> trits, int offset=-1, int length=-1)
        {
            if (offset == -1) offset = 0;
            if (length == -1) length = trits.size;
            int64[] _trits = new int64[offset+length];
            for (int i = 0; i < offset + length; i++) _trits[i] = trits[i];
            CCurl.Curl.absorb(&_curl, (int64 *)_trits, offset, length);
        }

        public Gee.List<int64?> squeeze(int offset=-1, int length=-1)
        {
            if (offset == -1) offset = 0;
            if (length == -1) length = 243;
            int64[] _trits = new int64[offset+length];
            CCurl.Curl.squeeze(&_curl, (int64 *)_trits, offset, length);
            var ret = new ArrayList<int64?>();
            for (int i = 0; i < offset + length; i++) ret.add(_trits[i]);
            return ret;
        }

        public void reset()
        {
            CCurl.Curl.reset(&_curl);
        }
    }
}
