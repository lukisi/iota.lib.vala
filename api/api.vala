using Gee;

namespace IotaLibVala
{
    public errordomain BalanceError
    {
        NOT_ENOUGH_BALANCE,
        GENERIC_ERROR
    }

    public class Transaction : Object
    {
        public string hash {get; set;}
        public string signature_message_fragment {get; set;}
        public string address {get; set;}
        public int64 @value {get; set;}
        public string tag {get; set;}
        public int64 timestamp {get; set;}
        public int64 current_index {get; set;}
        public int64 last_index {get; set;}
        public string bundle {get; set;}
        public string trunk_transaction {get; set;}
        public string branch_transaction {get; set;}
        public string nonce {get; set;}
    }

    public class Api : Object
    {
        public MakeRequest make_request {get; set;}
        public bool sandbox {get; set;}

        public Api(MakeRequest make_request, bool sandbox)
        {
            this.make_request = make_request;
            this.sandbox = sandbox;
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

        public async Gee.List<string> find_transactions_for_address(string address) throws RequestError
        {
            var json_command = ApiCommand.find_transactions_for_address(address);
            string json_result = yield send_command(json_command);
            Gee.List<string> ret = ApiResults.find_transactions_for_address(json_result);
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

        public async Gee.List<string>
        get_new_address(string seed, OptionsGetNewAddress options)
        throws RequestError
        {
            int index = options.index;
            // TODO validate the seed

            ArrayList<string> ret = new ArrayList<string>();

            if (options.total != null)
            {
                for (var i = 0; i < options.total; i++, index++) {
                    ret.add(make_new_address(seed, index, options.security, options.checksum));
                }
                return ret;
            }

            string new_address;
            while (true)
            {
                new_address = make_new_address(seed, index, options.security, options.checksum);
                var transactions = yield find_transactions_for_address(new_address);
                if (options.return_all) ret.add(new_address);
                index++;
                if (transactions.size == 0) break;
            }
            if (!options.return_all) ret.add(new_address);

            return ret;
        }

        private string make_new_address(string seed, int index, int security, bool checksum)
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

            return address;
        }

        public async ApiResults.GetBalancesResponse
        get_balances(Gee.List<string> addresses, int threshold) throws RequestError
        {
            // TODO check
            var json_command = ApiCommand.get_balances(addresses, threshold);
            string json_result = yield send_command(json_command);
            ApiResults.GetBalancesResponse ret = ApiResults.get_balances(json_result);
            return ret;
        }

        public class OptionsGetInputs : Object
        {
            public int start;
            public int end;
            public int64 threshold;
            public int security;
            public OptionsGetInputs()
            {
                start = 0;
                end = 0;
                threshold = 0;
                security = 2;
            }
        }

        public class GetInputsInputValue : Object
        {
            public string address;
            public int64 balance;
            public int key_index;
            public int security;
            public GetInputsInputValue
            (string address,
             int64 balance,
             int key_index,
             int security)
            {
                this.address = address;
                this.balance = balance;
                this.key_index = key_index;
                this.security = security;
            }
        }

        public class GetInputsResponse : Object
        {
            public Gee.List<GetInputsInputValue> inputs;
            public int64 total_balance;
            public GetInputsResponse()
            {
                inputs = new ArrayList<GetInputsInputValue>();
                total_balance = 0;
            }
        }

        public async GetInputsResponse
        get_inputs(string seed, OptionsGetInputs options)
        throws RequestError, BalanceError
        {
            // TODO validate seed

            // TODO validate start + end

            var start = options.start;
            var end = options.end;
            var threshold = options.threshold;
            var security = options.security;
            Gee.List<string> addresses;
            if (end != 0)
            {
                addresses = new ArrayList<string>();
                for (int i = start; i < end; i++)
                {
                    addresses.add(make_new_address(seed, i, security, false));
                }
            }
            else
            {
                OptionsGetNewAddress options_gna = new OptionsGetNewAddress();
                options_gna.index = start;
                options_gna.return_all = true;
                options_gna.security = security;
                addresses = yield get_new_address(seed, options_gna);
            }

            // getBalancesAndFormat addresses:
            var balances = yield get_balances(addresses, 100);
            var inputs_object = new GetInputsResponse();
            var threshold_reached = true;
            if (threshold != 0) threshold_reached = false;
            for (int i = 0; i < addresses.size; i++)
            {
                int64 balance = balances.balances[i];
                if (balance > 0)
                {
                    inputs_object.inputs.add(new GetInputsInputValue(addresses[i], balance, start + i, security));
                    inputs_object.total_balance += balance;
                    if (threshold != 0 && inputs_object.total_balance >= threshold)
                    {
                        threshold_reached = true;
                        break;
                    }
                }
            }

            if (! threshold_reached) throw new BalanceError.NOT_ENOUGH_BALANCE("Not enough balance");
            return inputs_object;
        }

        public class TransferToSend : Object
        {
            public string tag;
            public string message;
            public string address;
            public int64 @value;
        }

        public class SendTransferOptions : Object
        {
            public string? address;
            public Gee.List<GetInputsInputValue> inputs;
            public int security;
            public SendTransferOptions()
            {
                address = null;
                security = 2;
                inputs = new ArrayList<GetInputsInputValue>();
            }
        }

        public async Gee.List<Transaction>
        send_transfer
        (string seed, int depth, int min_weight_magnitude,
         Gee.List<TransferToSend> transfers,
         SendTransferOptions options)
        throws InputError, RequestError, BalanceError
        {
            // TODO validate input
            var trytes = yield prepare_transfers(seed, transfers, options);
            return yield send_trytes(trytes, depth, min_weight_magnitude);
        }

        public async Gee.List<string>
        prepare_transfers
        (
         string seed,
         Gee.List<TransferToSend> transfers,
         SendTransferOptions options)
        throws InputError, RequestError, BalanceError
        {
            if (! InputValidator.is_trytes(seed)) throw new InputError.INVALID_SEED("Invalid seed");
            if (! InputValidator.is_inputs(options.inputs)) throw new InputError.INVALID_INPUTS("Invalid inputs");

            // TODO validate transfers

            string? remainder_address = options.address;
            int security = options.security;

            var bundle = new Bundle();
            int64 total_value = 0;
            string tag = "";
            Gee.List<string> signature_fragments = new ArrayList<string>();

            for (int i = 0; i < transfers.size; i++)
            {
                var signature_message_length = 1;
                if (transfers[i].message.length > 2187)
                {
                    signature_message_length += transfers[i].message.length / 2187;
                    var msg_copy = transfers[i].message;
                    while (msg_copy.length > 0)
                    {
                        var fragment = msg_copy.slice(0, 2187);
                        msg_copy = msg_copy.slice(2187, msg_copy.length);
                        while (fragment.length < 2187) fragment += "9";
                        signature_fragments.add(fragment);
                    }
                }
                else
                {
                    var fragment = "";
                    if (transfers[i].message.length > 0)
                        fragment = transfers[i].message.slice(0, 2187);
                    while (fragment.length < 2187) fragment += "9";
                    signature_fragments.add(fragment);
                }
                int timestamp = (int)(time_t(null)); // timestamp in seconds
                tag = transfers[i].tag;
                if (tag == "") tag = "999999999999999999999999999";
                while (tag.length < 27) tag += "9";
                bundle.add_entry(signature_message_length,
                                 transfers[i].address,
                                 transfers[i].@value,
                                 tag,
                                 timestamp);
                total_value += transfers[i].@value;
            }

            Gee.List<GetInputsInputValue> add_remainder_inputs;
            if (total_value > 0)
            {
                if (! options.inputs.is_empty)
                {
                    var inputs_addresses = new ArrayList<string>();
                    foreach (var el in options.inputs) inputs_addresses.add(el.address);
                    var balances = yield get_balances(inputs_addresses, 100);
                    var confirmed_inputs = new ArrayList<GetInputsInputValue>();
                    int64 total_balance = 0;
                    for (int i = 0; i < balances.balances.size; i++)
                    {
                        var this_balance = balances.balances[i];
                        if (this_balance > 0)
                        {
                            total_balance += this_balance;
                            var el = options.inputs[i];
                            el.balance = this_balance;
                            confirmed_inputs.add(el);
                            if (total_balance >= total_value) break;
                        }
                    }
                    if (total_value > total_balance)
                        throw new BalanceError.NOT_ENOUGH_BALANCE("Not enough balance");
                    add_remainder_inputs = confirmed_inputs;
                }
                else
                {
                    var options_gi = new OptionsGetInputs();
                    options_gi.threshold = total_value;
                    options_gi.security = security;
                    var inputs = yield get_inputs(seed, options_gi);
                    add_remainder_inputs = inputs.inputs;
                }
            }
            else
            {
                bundle.finalize();
                bundle.add_trytes(signature_fragments);
                var bundle_trytes = new ArrayList<string>();
                foreach (var tx in bundle.bundle)
                    bundle_trytes.insert(0, Utils.transaction_trytes(tx));
                return bundle_trytes;
            }

            // addRemainder(add_remainder_inputs)

            var total_transfer_value = total_value;
            for (int i = 0; i < add_remainder_inputs.size; i++)
            {
                var this_balance = add_remainder_inputs[i].balance;
                var to_subtract = -this_balance;
                int timestamp = (int)(time_t(null)); // timestamp in seconds
                bundle.add_entry(add_remainder_inputs[i].security,
                                 add_remainder_inputs[i].address,
                                 to_subtract,
                                 tag,
                                 timestamp);
                if (this_balance >= total_transfer_value)
                {
                    var remainder = this_balance - total_transfer_value;
                    if (remainder > 0)
                    {
                        if (remainder_address != null)
                        {
                            bundle.add_entry(1,
                                             remainder_address,
                                             remainder,
                                             tag,
                                             timestamp);
                        }
                        else
                        {
                            var options_gna = new OptionsGetNewAddress();
                            options_gna.security = security;
                            var address_a = yield get_new_address(seed, options_gna);
                            timestamp = (int)(time_t(null));
                            bundle.add_entry(1,
                                             address_a[0],
                                             remainder,
                                             tag,
                                             timestamp);
                        }
                    }
                }
                else
                {
                    total_transfer_value -= this_balance;
                }
            }

            // signInputsAndReturn

            bundle.finalize();

            // Here actually sign
            // TODO

            bundle.add_trytes(signature_fragments);
            var bundle_trytes = new ArrayList<string>();
            foreach (var tx in bundle.bundle)
                bundle_trytes.insert(0, Utils.transaction_trytes(tx));
            return bundle_trytes;
        }

        public async Gee.List<Transaction>
        send_trytes
        (Gee.List<string> trytes, int depth, int min_weight_magnitude)
        throws InputError, RequestError
        {
            var to_approve = yield get_transactions_to_approve(depth);
            var attached = yield attach_to_tangle(to_approve.trunk_transaction,
                                                  to_approve.branch_transaction,
                                                  min_weight_magnitude,
                                                  trytes);
            if (sandbox)
            {
                error("sandbox not implemented");
            }
            yield broadcast_and_store(attached);
            var ret = new ArrayList<Transaction>();
            foreach (string attached_trytes in attached)
                ret.add(Utils.transaction_object(attached_trytes));
            return ret;
        }

        public async ApiResults.GetTransactionsToApproveResponse
        get_transactions_to_approve(int depth) throws RequestError
        {
            var json_command = ApiCommand.get_transactions_to_approve(depth);
            string json_result = yield send_command(json_command);
            ApiResults.GetTransactionsToApproveResponse ret = ApiResults.get_transactions_to_approve(json_result);
            return ret;
        }

        public async Gee.List<string>
        attach_to_tangle
        (string trunk_transaction,
        string branch_transaction,
        int min_weight_magnitude,
        Gee.List<string> trytes)
        throws InputError, RequestError
        {
            if (! InputValidator.is_hash(trunk_transaction))
                throw new InputError.INVALID_TRUNK_OR_BRANCH(trunk_transaction);
            if (! InputValidator.is_hash(branch_transaction))
                throw new InputError.INVALID_TRUNK_OR_BRANCH(branch_transaction);
            if (! InputValidator.is_value(min_weight_magnitude))
                throw new InputError.NOT_INT("");
            if (! InputValidator.is_array_of_trytes(trytes))
                throw new InputError.INVALID_TRYTES("");

            var json_command = ApiCommand.attach_to_tangle(trunk_transaction,
                                                           branch_transaction,
                                                           min_weight_magnitude,
                                                           trytes);
            string json_result = yield send_command(json_command);
            Gee.List<string> ret = ApiResults.attach_to_tangle(json_result);
            return ret;
        }

        public async void
        broadcast_transaction(Gee.List<string> trytes) throws RequestError
        {
            // TODO check inputValidator.isArrayOfAttachedTrytes(trytes)
            var json_command = ApiCommand.broadcast_transaction(trytes);
            string json_result = yield send_command(json_command);
            ApiResults.broadcast_transaction(json_result);
            // void
        }

        public async void
        store_transaction(Gee.List<string> trytes) throws RequestError
        {
            // TODO check inputValidator.isArrayOfAttachedTrytes(trytes)
            var json_command = ApiCommand.store_transaction(trytes);
            string json_result = yield send_command(json_command);
            ApiResults.store_transaction(json_result);
            // void
        }

        public async void
        broadcast_and_store(Gee.List<string> trytes) throws RequestError
        {
            yield broadcast_transaction(trytes);
            yield store_transaction(trytes);
        }
    }
}