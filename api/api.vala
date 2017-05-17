using Gee;

namespace IotaLibVala
{
    public class Address : Object
    {
        public string s {get; set;}
        public string to_string() {return s;}
    }

    public class Transaction : Object
    {
        public string t_hash {get; set;}
        public string to_string() {return t_hash;}
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

        public async string send_command(string json_command) throws RequestError
        {
            return yield make_request.send(json_command);
        }

        public async string get_node_info() throws RequestError
        {
            var json_command = ApiCommand.get_node_info();
            return yield send_command(json_command);
        }

        public async Gee.List<Transaction> find_transactions_for_address(string address) throws RequestError
        {
            var json_command = ApiCommand.find_transactions_for_address(address);
            string json_result = yield send_command(json_command);
            Gee.List<Transaction> ret = ApiResults.find_transactions_for_address(json_result);
            return ret;
        }

        public class OptionsGetNewAddress : Object
        {
            public int index;
            public int? total;
            public int security;
            public bool checksum;
            public bool return_all;
            public OptionsGetNewAddress()
            {
                index = 0;
                total = null;
                security = 2;
                checksum = false;
                return_all = false;
            }
        }

        public async Gee.List<Address>
        get_new_address(string seed, OptionsGetNewAddress options)
        throws RequestError
        {
            int index = options.index;
            // TODO validate the seed

            ArrayList<Address> ret = new ArrayList<Address>();

            if (options.total != null)
            {
                for (var i = 0; i < options.total; i++, index++) {
                    ret.add(make_new_address(seed, index, options.security, options.checksum));
                }
                return ret;
            }

            Address new_address;
            while (true)
            {
                new_address = make_new_address(seed, index, options.security, options.checksum);
                var transactions = yield find_transactions_for_address(new_address.s);
                if (options.return_all) ret.add(new_address);
                index++;
                if (transactions.size == 0) break;
            }
            if (!options.return_all) ret.add(new_address);

            return ret;
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
                address = Utils.add_checksum(address);
            }

            var ret = new Address();
            ret.s = address;
            return ret;
        }

        public async ApiResults.GetBalancesResponse get_balances(Gee.List<Address> addresses, int threshold) throws RequestError
        {
            // TODO check
            var json_command = ApiCommand.get_balances(addresses, threshold);
            string json_result = yield send_command(json_command);
            ApiResults.GetBalancesResponse ret = ApiResults.get_balances(json_result);
            return ret;
        }
    }
}