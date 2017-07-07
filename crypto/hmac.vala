using Gee;

namespace IotaLibVala
{
    public class HMAC : Object
    {
        private Gee.List<int64?> key;
        private Converter c;
        public HMAC(string hmac_key)
        {
            c = Converter.singleton;
            key = c.trits_from_trytes(hmac_key);
        }

        public void add_hmac(Bundle bundle)
        {
            error("not yet implemented");
            /*
    var curl = new Curl();
    for(var i = 0; i < bundle.bundle.length; i++) {
        if (bundle.bundle[i].value > 0) {
            var bundleHashTrits = Converter.trits(bundle.bundle[i].bundle);
            var hmac = new Int32Array(243);
            curl.initialize();
            curl.absorb(key);
            curl.absorb(bundleHashTrits);
            curl.squeeze(hmac);
            var hmacTrytes = Converter.trytes(hmac);
            bundle.bundle[i].signatureMessageFragment = hmacTrytes + bundle.bundle[i].signatureMessageFragment.substring(243, 2187);
        }
    }
             */
        }
    }
}
