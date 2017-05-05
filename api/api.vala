using Gee;

namespace IotaLibVala
{
    public class Address : Object
    {
        public string s {get; set;}
    }

    public class Api : Object
    {
        public MakeRequest make_request {get; set;}

        public Api(MakeRequest make_request, bool sandbox)
        {
            this.make_request = make_request;
            if (sandbox)
            {
                error("sandbox not implemented");
            }
        }

        public async string send_command(Object command) throws RequestError
        {
            return yield make_request.send(command);
        }

        public async string get_node_info() throws RequestError
        {
            var command = ApiCommand.get_node_info();
            return yield send_command(command);
        }

        public async ArrayList<Object> get_new_address(string seed, int index, int? total, int security, bool checksum)
        {
            // TODO validate the seed

            ArrayList<Object> ret = new ArrayList<Object>();

            if (total != null)
            {
                for (var i = 0; i < total; i++, index++) {
                    ret.add(make_new_address(seed, index, security, checksum));
                }
                return ret;
            }

            error("not implemented yet");
        }

        private Object make_new_address(string seed, int index, int security, bool checksum)
        {
            Converter c = Converter.singleton;
            Gee.List<int64?> trits = c.trits_from_trytes(seed);
            Signing s = Signing.singleton;
            var key = s.key(trits, index, security);
            var digests = s.digests(key);
            var addressTrits = s.address(digests);
            var address = c.trytes(addressTrits);

            if (checksum) {
                error("not implemented yet Utils.addChecksum");
            }

/*
    var key = Signing.key(Converter.trits(seed), index, security);
    var digests = Signing.digests(key);
    var addressTrits = Signing.address(digests);
    var address = Converter.trytes(addressTrits)

    if (checksum) {
        address = Utils.addChecksum(address);
    }
*/

            var ret = new Address();
            ret.s = address;
            return ret;
        }
    }
}