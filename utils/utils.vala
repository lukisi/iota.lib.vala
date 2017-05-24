using Gee;

namespace IotaLibVala.Utils
{
    public string add_checksum(string address)
    {
        assert(address.length == 81);
        Converter c = Converter.singleton;
        var curl = new Curl();
        curl.init();
        curl.absorb(c.trits_from_trytes(address));
        var state = curl.squeeze();
        var checksum = c.trytes(state).substring(0, 9);
        return address + checksum;
    }

    public Transaction transaction_object(string trytes)
    {
        assert(trytes.length == 2673);
        // validity check
        for (var i = 2279; i < 2295; i++) if (trytes.@get(i) != '9')
            error(@"expected 9 at pos $(i)");

        Converter c = Converter.singleton;
        Gee.List<int64?> transaction_trits = c.trits_from_trytes(trytes);
        Gee.List<int64?> hash;

        var curl = new Curl();
        curl.init();
        curl.absorb(transaction_trits);
        hash = curl.squeeze();

        var ret = new Transaction();
        ret.hash = c.trytes(hash);
        ret.signature_message_fragment = trytes.slice(0, 2187);
        ret.address = trytes.slice(2187, 2268);
        ret.@value = c.@value(transaction_trits.slice(6804, 6837));
        ret.tag = trytes.slice(2295, 2322);
        ret.timestamp = c.@value(transaction_trits.slice(6966, 6993));
        ret.current_index = c.@value(transaction_trits.slice(6993, 7020));
        ret.last_index = c.@value(transaction_trits.slice(7020, 7047));
        ret.bundle = trytes.slice(2349, 2430);
        ret.trunk_transaction = trytes.slice(2430, 2511);
        ret.branch_transaction = trytes.slice(2511, 2592);
        ret.nonce = trytes.slice(2592, 2673);

        return ret;
    }

    public string transaction_trytes(Transaction transaction)
    {
        Converter c = Converter.singleton;

        Gee.List<int64?> value_trits = c.trits_from_long(transaction.@value);
        while (value_trits.size < 81) {
            value_trits.add(0);
        }

        Gee.List<int64?> timestamp_trits = c.trits_from_long(transaction.timestamp);
        while (timestamp_trits.size < 27) {
            timestamp_trits.add(0);
        }

        Gee.List<int64?> current_index_trits = c.trits_from_long(transaction.current_index);
        while (current_index_trits.size < 27) {
            current_index_trits.add(0);
        }

        Gee.List<int64?> last_index_trits = c.trits_from_long(transaction.last_index);
        while (last_index_trits.size < 27) {
            last_index_trits.add(0);
        }

        return transaction.signature_message_fragment
            + transaction.address
            + c.trytes(value_trits)
            + transaction.tag
            + c.trytes(timestamp_trits)
            + c.trytes(current_index_trits)
            + c.trytes(last_index_trits)
            + transaction.bundle
            + transaction.trunk_transaction
            + transaction.branch_transaction
            + transaction.nonce;
    }
}