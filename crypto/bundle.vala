using Gee;

namespace IotaLibVala
{
    public class Bundle : Object
    {
        public Bundle()
        {
            _bundle = new ArrayList<Transaction>();
        }

        private Gee.List<Transaction> _bundle;
        public Gee.List<Transaction> bundle {
            get {
                return _bundle;
            }
        }

        public void add_entry(int signature_message_length,
                              string address,
                              int64 @value,
                              string tag,
                              int timestamp)
        {
            debug(@"Bundle.add_entry: signature_message_length = $(signature_message_length)");
            debug(@"Bundle.add_entry: address = $(address)");
            debug(@"Bundle.add_entry: value = $(@value)");
            debug(@"Bundle.add_entry: tag = $(tag)");
            debug(@"Bundle.add_entry: timestamp = $(timestamp)");
            for (var i = 0; i < signature_message_length; i++) {

                var transaction_object = new Transaction();
                transaction_object.address = address;
                transaction_object.@value = i == 0 ? @value : 0;
                transaction_object.tag = tag;
                transaction_object.timestamp = timestamp;

                _bundle.add(transaction_object);
            }
        }

        public void add_trytes(Gee.List<string> signature_fragments)
        {
            debug(@"Bundle.add_trytes: [");
            foreach (string s in signature_fragments)
                debug(@"Bundle.add_trytes:  \"$(s)\",");
            debug(@"Bundle.add_trytes: ]");
            string empty_signature_fragment = "";
            string empty_hash = "999999999999999999999999999999999999999999999999999999999999999999999999999999999";

            for (var j = 0; empty_signature_fragment.length < 2187; j++) {
                empty_signature_fragment += "9";
            }

            for (var i = 0; i < _bundle.size; i++) {

                // Fill empty signature_message_fragment
                _bundle[i].signature_message_fragment = empty_signature_fragment;
                if (signature_fragments.size > i)
                    _bundle[i].signature_message_fragment = signature_fragments[i];

                // Fill empty trunk_transaction
                _bundle[i].trunk_transaction = empty_hash;

                // Fill empty branch_transaction
                _bundle[i].branch_transaction = empty_hash;

                // Fill empty nonce
                _bundle[i].nonce = empty_hash;
            }
        }

        public void finalize_bundle()
        {
            debug(@"Bundle.finalize_bundle()");
            Converter c = Converter.singleton;
            var curl = new Curl();
            curl.init();

            for (var i = 0; i < _bundle.size; i++) {
                var value_trits = c.trits_from_long(_bundle[i].@value);
                while (value_trits.size < 81) {
                    value_trits.add(0);
                }
                debug(@"Bundle.finalize_bundle: value_trits = $(debug_list_int(value_trits))");

                var timestamp_trits = c.trits_from_long(_bundle[i].timestamp);
                while (timestamp_trits.size < 27) {
                    timestamp_trits.add(0);
                }
                debug(@"Bundle.finalize_bundle: timestamp_trits = $(debug_list_int(timestamp_trits))");

                var current_index_trits = c.trits_from_long(_bundle[i].current_index = i);
                while (current_index_trits.size < 27) {
                    current_index_trits.add(0);
                }
                debug(@"Bundle.finalize_bundle: current_index_trits = $(debug_list_int(current_index_trits))");

                var last_index_trits = c.trits_from_long(_bundle[i].last_index = _bundle.size - 1);
                while (last_index_trits.size < 27) {
                    last_index_trits.add(0);
                }
                debug(@"Bundle.finalize_bundle: last_index_trits = $(debug_list_int(last_index_trits))");

                debug(@"$(_bundle[i].address)");
                debug(@"$(c.trytes(value_trits))");
                debug(@"$(_bundle[i].tag)");
                debug(@"$(c.trytes(timestamp_trits))");
                debug(@"$(c.trytes(current_index_trits))");
                debug(@"$(c.trytes(last_index_trits))");
                string _trytes = _bundle[i].address
                                         + c.trytes(value_trits)
                                         + _bundle[i].tag
                                         + c.trytes(timestamp_trits)
                                         + c.trytes(current_index_trits)
                                         + c.trytes(last_index_trits);
                debug(@"Bundle.finalize_bundle: _trytes = $(_trytes)");
                curl.absorb(
                     c.trits_from_trytes(_trytes));

            }

            var hash = c.trytes(curl.squeeze());
            debug(@"Bundle.finalize_bundle: hash = $(hash)");

            for (var i = 0; i < _bundle.size; i++) {

                _bundle[i].bundle = hash;
            }
        }

        public Gee.List<int64?> normalized_bundle(string bundle_hash)
        {
            var ret = new ArrayList<int64?>();
            Converter c = Converter.singleton;

            for (var i = 0; i < 3; i++) {

                int64 sum = 0;
                for (var j = 0; j < 27; j++) {
                    int64 v = c.@value(c.trits_from_trytes(bundle_hash.substring(i * 27 + j, 1)));
                    ret.add(v);
                    sum += v;
                }

                if (sum >= 0) {
                    while (sum-- > 0) {
                        for (var j = 0; j < 27; j++) {
                            if (ret[i * 27 + j] > -13) {
                                ret[i * 27 + j] = ret[i * 27 + j] - 1;
                                break;
                            }
                        }
                    }
                } else {
                    while (sum++ < 0) {
                        for (var j = 0; j < 27; j++) {
                            if (ret[i * 27 + j] < 13) {
                                ret[i * 27 + j] = ret[i * 27 + j] + 1;
                                break;
                            }
                        }
                    }
                }
            }

            return ret;
        }
    }
}