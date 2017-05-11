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
}