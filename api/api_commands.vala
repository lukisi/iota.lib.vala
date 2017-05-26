using Gee;

namespace IotaLibVala.ApiCommand
{
    internal string json_string_object(Object obj)
    {
        Json.Node n = Json.gobject_serialize(obj);
        Json.Generator g = new Json.Generator();
        g.root = n;
        string ret = g.to_data(null);
        return ret;
    }

    public class Command : Object
    {
        public string command {get; set;}
    }

    /* Prepare JSON for API getNodeInfo
     */
    public string get_node_info()
    {
        var ret = new Command();
        ret.command = "getNodeInfo";
        return json_string_object(ret);
    }

    /* Prepare JSON for API findTransactions
     */
    public class CommandFindTransactionsForAddress : Command
    {
        public string[] addresses {get; set;}
        public CommandFindTransactionsForAddress()
        {
            this.command = "findTransactions";
        }
    }

    public string find_transactions_for_address(string address)
    {
        var ret = new CommandFindTransactionsForAddress();
        ret.addresses = {address};
        return json_string_object(ret);
    }

    /* Prepare JSON for API getBalances
     */
    public class CommandGetBalances : Command
    {
        public string[] addresses {get; set;}
        public int threshold {get; set;}
        public CommandGetBalances()
        {
            this.command = "getBalances";
        }
    }

    public string get_balances(Gee.List<string> addresses, int threshold)
    {
        var ret = new CommandGetBalances();
        string[] _addresses = new string[addresses.size];
        for (int j = 0; j < addresses.size; j++) _addresses[j] = addresses[j];
        ret.addresses = _addresses;
        ret.threshold = threshold;
        return json_string_object(ret);
    }

    /* Prepare JSON for API getTransactionsToApprove
     */
    public class CommandGetTransactionsToApprove : Command
    {
        public int depth {get; set;}
        public CommandGetTransactionsToApprove()
        {
            this.command = "getTransactionsToApprove";
        }
    }

    public string get_transactions_to_approve(int depth)
    {
        var ret = new CommandGetTransactionsToApprove();
        ret.depth = depth;
        return json_string_object(ret);
    }

    /* Prepare JSON for API attachToTangle
     */
    public class CommandAttachToTangle : Command
    {
        public string trunkTransaction {get; set;}
        public string branchTransaction {get; set;}
        public int minWeightMagnitude {get; set;}
        public string[] trytes {get; set;}
        public CommandAttachToTangle()
        {
            this.command = "attachToTangle";
        }
    }

    public string
    attach_to_tangle
    (string trunk_transaction,
    string branch_transaction,
    int min_weight_magnitude,
    Gee.List<string> trytes)
    {
        var ret = new CommandAttachToTangle();
        ret.trunkTransaction = trunk_transaction;
        ret.branchTransaction = branch_transaction;
        ret.minWeightMagnitude = min_weight_magnitude;
        string[] _trytes = new string[trytes.size];
        for (int j = 0; j < trytes.size; j++) _trytes[j] = trytes[j];
        ret.trytes = _trytes;
        return json_string_object(ret);
    }

    /* Prepare JSON for API broadcastTransactions
     */
    public class CommandBroadcastTransactions : Command
    {
        public string[] trytes {get; set;}
        public CommandBroadcastTransactions()
        {
            this.command = "broadcastTransactions";
        }
    }

    public string
    broadcast_transactions
    (Gee.List<string> trytes)
    {
        var ret = new CommandBroadcastTransactions();
        string[] _trytes = new string[trytes.size];
        for (int j = 0; j < trytes.size; j++) _trytes[j] = trytes[j];
        ret.trytes = _trytes;
        return json_string_object(ret);
    }

    /* Prepare JSON for API storeTransactions
     */
    public class CommandStoreTransactions : Command
    {
        public string[] trytes {get; set;}
        public CommandStoreTransactions()
        {
            this.command = "storeTransactions";
        }
    }

    public string
    store_transactions
    (Gee.List<string> trytes)
    {
        var ret = new CommandStoreTransactions();
        string[] _trytes = new string[trytes.size];
        for (int j = 0; j < trytes.size; j++) _trytes[j] = trytes[j];
        ret.trytes = _trytes;
        return json_string_object(ret);
    }
}