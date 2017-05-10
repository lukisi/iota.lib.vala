using Gee;

namespace IotaLibVala
{
    public class Address : Object
    {
        public string s {get; set;}
        public string to_string() {return s;}
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

        public async ArrayList<Address> get_new_address(string seed, int index, int? total, int security, bool checksum)
        {
            // TODO validate the seed

            ArrayList<Address> ret = new ArrayList<Address>();

            if (total != null)
            {
                for (var i = 0; i < total; i++, index++) {
                    ret.add(make_new_address(seed, index, security, checksum));
                }
                return ret;
            }

            error("not implemented yet");
        }

        private Address make_new_address(string seed, int index, int security, bool checksum)
        {
            Converter c = Converter.singleton;
            Gee.List<int64?> trits = c.trits_from_trytes(seed);
            Signing s = Signing.singleton;
            var key = s.key(trits, index, security);
            var digests = s.digests(key);
            var address_trits = s.address(digests);
            var address = c.trytes(address_trits);

            if (checksum) {
                error("not implemented yet Utils.addChecksum");
                // address = Utils.addChecksum(address);
            }

            var ret = new Address();
            ret.s = address;
            return ret;
        }
    }
}