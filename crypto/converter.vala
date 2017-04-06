using Gee;

namespace IotaLibVala
{
    public class Converter : Object
    {
        private const int NUMBER_OF_TRITS_IN_A_TRYTE = 3;

        private static Converter _instance;
        public static Converter singleton {
            get {
                if (_instance == null) _instance = new Converter();
                return _instance;
            }
        }

        private Converter()
        {
            CCurl.Converter.init_converter();
        }

        public ArrayList<int64?> trits_from_trytes(string trytes)
        {
            int64 * buf = CCurl.Converter.trits_from_trytes((char *)trytes, trytes.length);
            int retlen = trytes.length * NUMBER_OF_TRITS_IN_A_TRYTE;
            ArrayList<int64?> ret = new ArrayList<int64?>();
            for (int i = 0; i < retlen; i++) ret.add(buf[i]);
            CCurl.Converter.free(buf);
            return ret;
        }

        public string trytes(ArrayList<int64?> trits)
        {
            int64 [] _trits = new int64[trits.size];
            for (int i = 0; i < trits.size; i++) _trits[i] = trits[i];
            char * buf = CCurl.Converter.trytes_from_trits(_trits, 0, trits.size);
            string ret = (string)buf;
            CCurl.Converter.free(buf);
            return ret;
        }
    }
}
