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

    public string get_node_info()
    {
        var ret = new Command();
        ret.command = "getNodeInfo";
        return json_string_object(ret);
    }

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

    public class CommandGetBalances : Command
    {
        public string[] addresses {get; set;}
        public int threshold {get; set;}
        public CommandGetBalances()
        {
            this.command = "getBalances";
        }
    }

    public string get_balances(Gee.List<Address> addresses, int threshold)
    {
        var ret = new CommandGetBalances();
        string[] _addresses = new string[addresses.size];
        for (int j = 0; j < addresses.size; j++) _addresses[j] = addresses[j].s;
        ret.addresses = _addresses;
        ret.threshold = threshold;
        return json_string_object(ret);
    }

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
}