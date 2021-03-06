using Gee;

namespace IotaLibVala
{
    public errordomain BalanceError
    {
        NOT_ENOUGH_BALANCE,
        GENERIC_ERROR
    }

    /* Class for objects that represent a transaction.
     * See function Utils.transaction_object.
     */
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

    /* Making API requests, including generalized wrapper functions
     */
    public class Api : Object
    {
        public MakeRequest make_request {get; set;}
        public bool sandbox {get; set;}

        public Api(MakeRequest make_request, bool sandbox)
        {
            this.make_request = make_request;
            this.sandbox = sandbox;
        }

        /* General function that makes an HTTP request to the local node
         */
        public async string send_command(string json_command) throws RequestError
        {
            return yield make_request.send(json_command);
        }

        /* Call API attachToTangle
         */
        public virtual async Gee.List<string>
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

        /* Call API interruptAttachingToTangle
         */
        public virtual async void /*WHAT*/
        interrupt_attaching_to_tangle()
        throws InputError, RequestError
        {
            error("not implemented yet");
        }

        /* Call API findTransactions for the particular case where the only search
         * value is an array with 1 address.
         */
        public async Gee.List<string> find_transactions_for_address(string address) throws RequestError
        {
            var json_command = ApiCommand.find_transactions_for_address(address);
            string json_result = yield send_command(json_command);
            Gee.List<string> ret = ApiResults.find_transactions_for_address(json_result);
            return ret;
        }

        /* Call API getBalances
         */
        public async ApiResults.GetBalancesResponse
        get_balances(Gee.List<string> addresses, int threshold) throws RequestError
        {
            // TODO check
            var json_command = ApiCommand.get_balances(addresses, threshold);
            string json_result = yield send_command(json_command);
            ApiResults.GetBalancesResponse ret = ApiResults.get_balances(json_result);
            return ret;
        }

        /* Call API getNodeInfo
         */
        public async ApiResults.NodeInfo get_node_info() throws RequestError
        {
            var json_command = ApiCommand.get_node_info();
            string json_result = yield send_command(json_command);
            ApiResults.NodeInfo ret = ApiResults.get_node_info(json_result);
            return ret;
        }

        /* Call API getTransactionsToApprove
         */
        public async ApiResults.GetTransactionsToApproveResponse
        get_transactions_to_approve(int depth) throws RequestError
        {
            var json_command = ApiCommand.get_transactions_to_approve(depth);
            string json_result = yield send_command(json_command);
            ApiResults.GetTransactionsToApproveResponse ret = ApiResults.get_transactions_to_approve(json_result);
            return ret;
        }

        /* Call API broadcastTransactions
         */
        public async void
        broadcast_transactions(Gee.List<string> trytes) throws RequestError
        {
            // TODO check inputValidator.isArrayOfAttachedTrytes(trytes)
            var json_command = ApiCommand.broadcast_transactions(trytes);
            string json_result = yield send_command(json_command);
            ApiResults.broadcast_transactions(json_result);
            // void
        }

        /* Call API storeTransactions
         */
        public async void
        store_transactions(Gee.List<string> trytes) throws RequestError
        {
            // TODO check inputValidator.isArrayOfAttachedTrytes(trytes)
            var json_command = ApiCommand.store_transactions(trytes);
            string json_result = yield send_command(json_command);
            ApiResults.store_transactions(json_result);
            // void
        }

        /*************************************

        WRAPPER AND CUSTOM  FUNCTIONS

        **************************************/

        /* Used as part of parameter `options` in function `send_transfer`.
         * Used as part of return value of function `get_inputs`.
         */
        public class TransferInputValue : Object
        {
            public string address;
            public int64 balance;
            public int key_index;
            public int? security;
            public TransferInputValue
            (string address,
             int64 balance,
             int key_index,
             int? security)
            {
                this.address = address;
                this.balance = balance;
                this.key_index = key_index;
                this.security = security;
            }
        }

        /* Broadcasts and stores transaction trytes
         */
        public async void
        store_and_broadcast(Gee.List<string> trytes) throws RequestError
        {
            yield store_transactions(trytes);
            yield broadcast_transactions(trytes);
        }

        /* Gets transactions to approve, attaches to Tangle, broadcasts and stores
         */
        public async Gee.List<Transaction>
        send_trytes
        (Gee.List<string> trytes, int depth, int min_weight_magnitude)
        throws InputError, RequestError
        {
            // Get branch and trunk
            var to_approve = yield get_transactions_to_approve(depth);
            // attach to tangle - do pow
            var attached = yield attach_to_tangle(to_approve.trunk_transaction,
                                                  to_approve.branch_transaction,
                                                  min_weight_magnitude,
                                                  trytes);
            if (sandbox)
            {
                error("sandbox not implemented");
            }
            // Broadcast and store tx
            yield store_and_broadcast(attached);
            var ret = new ArrayList<Transaction>();
            foreach (string attached_trytes in attached)
                ret.add(Utils.transaction_object(attached_trytes));
            return ret;
        }

        /* Used for parameter `transfers` in function `send_transfer`
         */
        public class TransferToSend : Object
        {
            public TransferToSend(string address, int64 val)
            {
                tag = "";
                message = "";
                this.address = address;
                @value = val;
            }
            public string tag;
            public string message;
            public string address;
            public int64 @value;
        }

        /* Used for parameter `options` in function `send_transfer`
         */
        public class SendTransferOptions : Object
        {
            /*
             * inputs      Inputs used for signing. Needs to have correct security, keyIndex and address value
             * address     Remainder address
             * security    security level to be used for getting inputs and addresses
             */
            public string? address;
            public Gee.List<TransferInputValue> inputs;
            public int security;
            public SendTransferOptions()
            {
                address = null;
                security = 2;
                inputs = new ArrayList<TransferInputValue>();
            }
        }

        /* Prepares Transfer, gets transactions to approve
         *   attaches to Tangle, broadcasts and stores
         */
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

        /**
        *   Generates a new address
        *
        *   @method     make_new_address
        *   @param      {string} seed
        *   @param      {int} index
        *   @param      {int} security      Security level of the private key
        *   @param      {bool} checksum
        *   @returns    {string} address
        **/
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
                try {
                    address = Utils.add_checksum(address);
                } catch (InputError e) {assert_not_reached();}
            }

            return address;
        }

        /* Used for parameter `options` in function `get_new_address`.
         */
        public class OptionsGetNewAddress : Object
        {
            /*
             *  index         Key index to start search from
             *  checksum      add 9-tryte checksum
             *  total         Total number of addresses to return
             *  security      Security level to be used for the private key / address. Can be 1, 2 or 3
             *  return_all    return all searched addresses
             */
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

        /*
         * Generates a new address either deterministically or index-based
         */
        public async Gee.List<string>
        get_new_address(string seed, OptionsGetNewAddress options)
        throws RequestError, InputError
        {
            int index = options.index;
            if (index < 0)
                throw new InputError.INVALID_INDEX("Invalid Index option provided");
            if (options.security < 1 || options.security > 3)
                throw new InputError.INVALID_SECURITY("Invalid Security option provided");
            // TODO validate the seed

            ArrayList<string> ret = new ArrayList<string>();

            // Case 1: total
            //
            // If total number of addresses to generate is supplied, simply generate
            // and return the list of all addresses
            if (options.total != null)
            {
                // Increase index with each iteration
                for (var i = 0; i < options.total; i++, index++) {
                    ret.add(make_new_address(seed, index, options.security, options.checksum));
                }
                return ret;
            }

            //  Case 2: no total provided
            //
            //  Continue calling findTransactions to see if address was already created
            //  if null, return list of addresses
            string new_address;
            while (true)
            {
                new_address = make_new_address(seed, index, options.security, options.checksum);
                var transactions = yield find_transactions_for_address(new_address);
                if (options.return_all) ret.add(new_address);
                index++;
                if (transactions.size == 0) break;
            }
            // If returnAll, return list of allAddresses
            // else return the last address that was generated
            if (!options.return_all) ret.add(new_address);

            return ret;
        }

        /* Used for parameter `options` in function `get_inputs`
         */
        public class OptionsGetInputs : Object
        {
            /*
             * start       Starting key index
             * end         Ending key index
             * threshold   Min balance required
             * security    secuirty level of private key / seed
             */
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

        /* Used for return value of function `get_inputs`
         */
        public class GetInputsResponse : Object
        {
            public Gee.List<TransferInputValue> inputs;
            public int64 total_balance;
            public GetInputsResponse()
            {
                inputs = new ArrayList<TransferInputValue>();
                total_balance = 0;
            }
        }

        /* Gets the inputs of a seed
         */
        public async GetInputsResponse
        get_inputs(string seed, OptionsGetInputs options)
        throws RequestError, BalanceError, InputError
        {
            // TODO validate seed

            // TODO validate start + end
            // If start value bigger than end, return error
            // or if difference between end and start is bigger than 500 keys

            var start = options.start;
            var end = options.end;
            var threshold = options.threshold;
            var security = options.security;
            Gee.List<string> addresses;

            //  Case 1: start and end
            //
            //  If start and end is defined by the user, simply iterate through the keys
            if (end != 0)
            {
                addresses = new ArrayList<string>();
                for (int i = start; i < end; i++)
                {
                    addresses.add(make_new_address(seed, i, security, false));
                }
            }
            //  Case 2: iterate till threshold || end
            //
            //  Either start from index: 0 or start (if defined) until threshold is reached.
            //  Calls get_new_address and deterministically generates and returns all addresses
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

            // If threshold defined, keep track of whether reached or not
            // else set default to true
            var threshold_reached = true;
            if (threshold != 0) threshold_reached = false;

            for (int i = 0; i < addresses.size; i++)
            {
                int64 balance = balances.balances[i];
                if (balance > 0)
                {
                    inputs_object.inputs.add(new TransferInputValue(addresses[i], balance, start + i, security));
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

        /* Prepares transfer by generating bundle, finding and signing inputs
         * Returns an array of bundle trytes
         */
        public async Gee.List<string>
        prepare_transfers
        (string seed,
         Gee.List<TransferToSend> transfers,
         SendTransferOptions options)
        throws InputError, RequestError, BalanceError
        {
            if (! InputValidator.is_trytes(seed)) throw new InputError.INVALID_SEED("Invalid seed");
            if (! InputValidator.is_inputs(options.inputs)) throw new InputError.INVALID_INPUTS("Invalid inputs");

            foreach (var this_transfer in transfers)
            {
                // Remove the checksum of the address if it's there after validating it
                if (this_transfer.address.length == 90) {
                    if (!Utils.is_valid_checksum(this_transfer.address))
                        throw new InputError.INVALID_CHECKSUM(@"INVALID_CHECKSUM: $(this_transfer.address)");
                }
                this_transfer.address = Utils.no_checksum(this_transfer.address);
            }

            string? remainder_address = options.address;
            int security = options.security;

            // Create a new bundle
            var bundle = new Bundle();
            int64 total_value = 0;
            string tag = "";
            Gee.List<string> signature_fragments = new ArrayList<string>();

            //
            //  Iterate over all transfers, get totalValue
            //  and prepare the signatureFragments, message and tag
            //
            for (int i = 0; i < transfers.size; i++)
            {
                var signature_message_length = 1;
                // If message longer than 2187 trytes, increase signatureMessageLength (add 2nd transaction)
                if (transfers[i].message.length > 2187)
                {
                    // Get total length, message / maxLength (2187 trytes)
                    signature_message_length += transfers[i].message.length / 2187;
                    var msg_copy = transfers[i].message;
                    // While there is still a message, copy it
                    while (msg_copy.length > 0)
                    {
                        var fragment = msg_copy.slice(0, 2187);
                        msg_copy = msg_copy.slice(2187, msg_copy.length);
                        // Pad remainder of fragment
                        while (fragment.length < 2187) fragment += "9";
                        signature_fragments.add(fragment);
                    }
                }
                else
                {
                    // Else, get single fragment with 2187 of 9's trytes
                    var fragment = "";
                    if (transfers[i].message.length > 0)
                        fragment = transfers[i].message.slice(0, 2187);
                    while (fragment.length < 2187) fragment += "9";
                    signature_fragments.add(fragment);
                }
                int timestamp = (int)(time_t(null)); // timestamp in seconds
                tag = transfers[i].tag;
                if (tag == "") tag = "999999999999999999999999999";
                // Pad for required 27 tryte length
                while (tag.length < 27) tag += "9";
                // Add first entries to the bundle
                bundle.add_entry(signature_message_length,
                                 transfers[i].address,
                                 transfers[i].@value,
                                 tag,
                                 timestamp);
                total_value += transfers[i].@value;
            }

            Gee.List<TransferInputValue> chosen_inputs;
            // Get inputs if we are sending tokens
            if (total_value > 0)
            {
                //  Case 1: user provided inputs
                //
                //  Validate the inputs by calling getBalances
                if (! options.inputs.is_empty)
                {
                    // Get list of addresses of the provided inputs
                    var inputs_addresses = new ArrayList<string>();
                    foreach (var el in options.inputs) inputs_addresses.add(el.address);
                    var balances = yield get_balances(inputs_addresses, 100);
                    var confirmed_inputs = new ArrayList<TransferInputValue>();
                    int64 total_balance = 0;
                    for (int i = 0; i < balances.balances.size; i++)
                    {
                        var this_balance = balances.balances[i];
                        // If input has balance, add it to confirmedInputs
                        if (this_balance > 0)
                        {
                            total_balance += this_balance;
                            var el = options.inputs[i];
                            el.balance = this_balance;
                            confirmed_inputs.add(el);
                            // if we've already reached the intended input value, break out of loop
                            if (total_balance >= total_value) break;
                        }
                    }
                    if (total_value > total_balance)
                        throw new BalanceError.NOT_ENOUGH_BALANCE("Not enough balance");
                    chosen_inputs = confirmed_inputs;
                }
                //  Case 2: Get inputs deterministically
                //
                //  If no inputs provided, derive the addresses from the seed and
                //  confirm that the inputs exceed the threshold
                else
                {
                    var options_gi = new OptionsGetInputs();
                    options_gi.threshold = total_value;
                    options_gi.security = security;
                    // If inputs have not enough balance this will throw error
                    var inputs = yield get_inputs(seed, options_gi);
                    chosen_inputs = inputs.inputs;
                }
            }
            else
            {
                // If no input required, don't sign and simply finalize the bundle
                bundle.finalize_bundle();
                bundle.add_trytes(signature_fragments);
                var bundle_trytes = new ArrayList<string>();
                foreach (var tx in bundle.bundle)
                    bundle_trytes.insert(0, Utils.transaction_trytes(tx));
                return bundle_trytes;
            }

            // See function addRemainder in JS

            var total_transfer_value = total_value;
            for (int i = 0; i < chosen_inputs.size; i++)
            {
                var this_balance = chosen_inputs[i].balance;
                var to_subtract = -this_balance;
                int timestamp = (int)(time_t(null)); // timestamp in seconds
                // Add input as bundle entry
                bundle.add_entry(chosen_inputs[i].security,
                                 chosen_inputs[i].address,
                                 to_subtract,
                                 tag,
                                 timestamp);
                // If there is a remainder value
                // Add extra output to send remaining funds to
                if (this_balance >= total_transfer_value)
                {
                    var remainder = this_balance - total_transfer_value;
                    if (remainder > 0)
                    {
                        // If user has provided remainder address
                        // Use it to send remaining funds to
                        if (remainder_address != null)
                        {
                            // Remainder bundle entry
                            bundle.add_entry(1,
                                             remainder_address,
                                             remainder,
                                             tag,
                                             timestamp);
                        }
                        else
                        {
                            // Generate a new Address by calling getNewAddress
                            var options_gna = new OptionsGetNewAddress();
                            options_gna.security = security;
                            var address_a = yield get_new_address(seed, options_gna);
                            timestamp = (int)(time_t(null));
                            // Remainder bundle entry
                            bundle.add_entry(1,
                                             address_a[0],
                                             remainder,
                                             tag,
                                             timestamp);
                        }
                    }
                    // If there is no remainder, do not add transaction to bundle
                    // simply sign and return
                }
                else
                {
                    // If multiple inputs provided, subtract the totalTransferValue by
                    // the inputs balance
                    total_transfer_value -= this_balance;
                }
            }

            // See function signInputsAndReturn in JS

            bundle.finalize_bundle();
            bundle.add_trytes(signature_fragments);

            //  SIGNING OF INPUTS
            //
            //  Here we do the actual signing of the inputs
            //  Iterate over all bundle transactions, find the inputs
            //  Get the corresponding private key and calculate the signatureFragment
            Signing s = Signing.singleton;
            Converter c = Converter.singleton;
            for (var i = 0; i < bundle.bundle.size; i++) {

                if (bundle.bundle[i].@value < 0) {
                    var this_address = bundle.bundle[i].address;

                    // Get the corresponding keyIndex and security of the address
                    int key_index = -1;
                    int key_security = -1;
                    foreach (TransferInputValue input in chosen_inputs) {
                        if (input.address == this_address) {

                            key_index = input.key_index;
                            key_security = input.security != null ? input.security : security;
                            break;
                        }
                    }
                    assert(key_index != -1);
                    assert(key_security != -1);

                    var bundle_hash = bundle.bundle[i].bundle;

                    // Get corresponding private key of address
                    var key = s.key(c.trits_from_trytes(seed), key_index, key_security);

                    //  Get the normalized bundle hash
                    var normalized_bundle_hash = bundle.normalized_bundle(bundle_hash);
                    var normalized_bundle_fragments = new ArrayList<Gee.List<int64?>>();

                    // Split hash into 3 fragments
                    for (var l = 0; l < 3; l++) {
                        normalized_bundle_fragments.add(normalized_bundle_hash.slice(l * 27, (l + 1) * 27));
                    }

                    //  First 6561 trits for the first_fragment
                    var first_fragment = key.slice(0, 6561);

                    //  First bundle fragment uses the first 27 trytes
                    var first_bundle_fragment = normalized_bundle_fragments[0];

                    //  Calculate the new signature_fragment with the first bundle fragment
                    var first_signed_fragment = s.signature_fragment(first_bundle_fragment, first_fragment);

                    //  Convert signature to trytes and assign the new signature_fragment
                    bundle.bundle[i].signature_message_fragment = c.trytes(first_signed_fragment);

                    // if user chooses higher than 27-tryte security
                    // for each security level, add an additional signature
                    for (var j = 1; j < key_security; j++) {
                        //  Because the signature is > 2187 trytes, we need to
                        //  find the subsequent transaction to add the remainder of the signature
                        //  Same address as well as value = 0 (as we already spent the input)
                        if (bundle.bundle[i + j].address == this_address && bundle.bundle[i + j].@value == 0) {
                            // Use the next 6561 trits
                            var next_fragment = key.slice(6561 * j,  (j + 1) * 6561);
                            var next_bundle_fragment = normalized_bundle_fragments[j];
                            //  Calculate the new signature
                            var next_signed_fragment = s.signature_fragment(next_bundle_fragment, next_fragment);
                            //  Convert signature to trytes and assign it again to this bundle entry
                            bundle.bundle[i + j].signature_message_fragment = c.trytes(next_signed_fragment);
                        }
                    }
                }
            }

            var bundle_trytes = new ArrayList<string>();
            foreach (var tx in bundle.bundle)
                bundle_trytes.insert(0, Utils.transaction_trytes(tx));
            return bundle_trytes;
        }
    }

    public class ApiClientsidePow : Api
    {
        public ApiClientsidePow(MakeRequest make_request, bool sandbox)
        {
            base(make_request, sandbox);
        }

        /* Call client-side attachToTangle
         */
        public override async Gee.List<string>
        attach_to_tangle
        (string trunk_transaction,
         string branch_transaction,
         int min_weight_magnitude,
         Gee.List<string> trytes)
        throws InputError, RequestError
        {
            Pow libccurl = Pow.singleton;

            if (! InputValidator.is_hash(trunk_transaction))
                throw new InputError.INVALID_TRUNK_OR_BRANCH(trunk_transaction);
            if (! InputValidator.is_hash(branch_transaction))
                throw new InputError.INVALID_TRUNK_OR_BRANCH(branch_transaction);
            if (! InputValidator.is_value(min_weight_magnitude))
                throw new InputError.NOT_INT("");
            if (! InputValidator.is_array_of_trytes(trytes))
                throw new InputError.INVALID_TRYTES("");

            Gee.List<string> final_bundle_trytes = new ArrayList<string>();
            string? prev_tx_hash = null;
            int i = 0;
            while (i < trytes.size)
            {
                // See function getBundleTrytes in JS
                var this_trytes = trytes[i];

                // PROCESS LOGIC:
                // Start with last index transaction
                // Assign it the trunk / branch which the user has supplied
                // IF there is a bundle, chain  the bundle transactions via
                // trunkTransaction together

                // If this is the first transaction, to be processed
                // Make sure that it's the last in the bundle and then
                // assign it the supplied trunk and branch transactions
                if (prev_tx_hash == null)
                {
                    var tx_object = Utils.transaction_object(this_trytes);

                    // Check if last transaction in the bundle
                    if (tx_object.last_index != tx_object.current_index) {
                        throw new InputError.INVALID_INPUTS
                            ("Wrong bundle order. The bundle should be ordered " +
                             "in descending order from currentIndex");
                    }

                    tx_object.trunk_transaction = trunk_transaction;
                    tx_object.branch_transaction = branch_transaction;

                    var new_trytes = Utils.transaction_trytes(tx_object);

                    var returned_trytes =
                        yield libccurl.ccurl_pow(new_trytes, min_weight_magnitude);

                    if (returned_trytes == null)
                        throw new RequestError.REQUEST_ERROR("POW INTERRUPTED");

                    // Save prev_tx_hash
                    var new_tx_object = Utils.transaction_object(returned_trytes);
                    prev_tx_hash = new_tx_object.hash;

                    final_bundle_trytes.insert(0, returned_trytes);
                }

                else
                {
                    var tx_object = Utils.transaction_object(this_trytes);

                    // Chain the bundle together via the trunkTransaction (previous tx in the bundle)
                    // Assign the supplied trunkTransaciton as branchTransaction
                    tx_object.trunk_transaction = prev_tx_hash;
                    tx_object.branch_transaction = trunk_transaction;

                    var new_trytes = Utils.transaction_trytes(tx_object);

                    var returned_trytes =
                        yield libccurl.ccurl_pow(new_trytes, min_weight_magnitude);

                    if (returned_trytes == null)
                        throw new RequestError.REQUEST_ERROR("POW INTERRUPTED");

                    // Save prev_tx_hash
                    var new_tx_object = Utils.transaction_object(returned_trytes);
                    prev_tx_hash = new_tx_object.hash;

                    final_bundle_trytes.insert(0, returned_trytes);
                }

                i++;
            }
            return final_bundle_trytes;
        }

        /* Call client-side interruptAttachingToTangle
         */
        public override async void /*WHAT*/
        interrupt_attaching_to_tangle()
        throws InputError, RequestError
        {
            error("not implemented yet");
        }
    }
}