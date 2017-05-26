using Gee;

namespace IotaLibVala.ApiResults
{
    public class GetBalancesResponse
    {
        public Gee.List<int64?> balances;
        public string milestone;
        public int64 milestone_index;
        public GetBalancesResponse()
        {
            balances = new ArrayList<int64?>();
        }
    }

    public class GetTransactionsToApproveResponse
    {
        public string trunk_transaction;
        public string branch_transaction;
    }

    public Gee.List<string>
    find_transactions_for_address(string json_result)
    throws RequestError
    {
        ArrayList<string> ret = new ArrayList<string>();
        Json.Parser p_res = new Json.Parser();
        try {
            p_res.load_from_data(json_result);
        } catch (Error e) {
            throw new RequestError.INVALID_RESPONSE("response must be a JSON tree");
        }
        unowned Json.Node res_rootnode = p_res.get_root();
        Json.Reader r_res = new Json.Reader(res_rootnode);
        if (!r_res.is_object()) throw new RequestError.INVALID_RESPONSE("root must be an object");
        if (!r_res.read_member("hashes")) throw new RequestError.INVALID_RESPONSE("root must have hashes");
        if (!r_res.is_array()) throw new RequestError.INVALID_RESPONSE("hashes must be an array");
        var hashes_length = r_res.count_elements();
        for (int j = 0; j < hashes_length; j++)
        {
            r_res.read_element(j);
            if (!r_res.is_value())
                throw new RequestError.INVALID_RESPONSE(@"each hash must be a string");
            if (r_res.get_value().get_value_type() != typeof(string))
                throw new RequestError.INVALID_RESPONSE(@"each hash must be a string");
            ret.add(r_res.get_string_value());
            r_res.end_element();
        }
        r_res.end_member();
        return ret;
    }

    public GetBalancesResponse
    get_balances(string json_result)
    throws RequestError
    {
        GetBalancesResponse ret = new GetBalancesResponse();
        Json.Parser p_res = new Json.Parser();
        try {
            p_res.load_from_data(json_result);
        } catch (Error e) {
            throw new RequestError.INVALID_RESPONSE("response must be a JSON tree");
        }
        unowned Json.Node res_rootnode = p_res.get_root();
        Json.Reader r_res = new Json.Reader(res_rootnode);
        if (!r_res.is_object()) throw new RequestError.INVALID_RESPONSE("root must be an object");
        if (!r_res.read_member("balances")) throw new RequestError.INVALID_RESPONSE("root must have balances");
        if (!r_res.is_array()) throw new RequestError.INVALID_RESPONSE("balances must be an array");
        for (int j = 0; j < r_res.count_elements(); j++)
        {
            r_res.read_element(j);
            if (!r_res.is_value())
                throw new RequestError.INVALID_RESPONSE(@"each balance must be a string");
            if (r_res.get_value().get_value_type() != typeof(string))
                throw new RequestError.INVALID_RESPONSE(@"each balance must be a string");
            string balance = r_res.get_string_value();
            int64 val;
            bool res;
            res = int64.try_parse(balance, out val);
            if (! res) throw new RequestError.INVALID_RESPONSE(@"each balance must represent a int64");
            ret.balances.add(val);
            r_res.end_element();
        }
        r_res.end_member();
        if (!r_res.read_member("milestone")) throw new RequestError.INVALID_RESPONSE("root must have milestone");
        if (!r_res.is_value())
            throw new RequestError.INVALID_RESPONSE(@"milestone must be a string");
        if (r_res.get_value().get_value_type() != typeof(string))
            throw new RequestError.INVALID_RESPONSE(@"milestone must be a string");
        ret.milestone = r_res.get_string_value();
        r_res.end_member();
        if (!r_res.read_member("milestoneIndex")) throw new RequestError.INVALID_RESPONSE("root must have milestoneIndex");
        if (!r_res.is_value())
            throw new RequestError.INVALID_RESPONSE(@"milestoneIndex must be a int");
        if (r_res.get_value().get_value_type() != typeof(int64))
            throw new RequestError.INVALID_RESPONSE(@"milestoneIndex must be a int");
        ret.milestone_index = r_res.get_int_value();
        r_res.end_member();
        return ret;
    }

    public GetTransactionsToApproveResponse
    get_transactions_to_approve(string json_result)
    throws RequestError
    {
        GetTransactionsToApproveResponse ret = new GetTransactionsToApproveResponse();
        Json.Parser p_res = new Json.Parser();
        try {
            p_res.load_from_data(json_result);
        } catch (Error e) {
            throw new RequestError.INVALID_RESPONSE("response must be a JSON tree");
        }
        unowned Json.Node res_rootnode = p_res.get_root();
        Json.Reader r_res = new Json.Reader(res_rootnode);
        if (!r_res.is_object()) throw new RequestError.INVALID_RESPONSE("root must be an object");
        if (!r_res.read_member("trunkTransaction")) throw new RequestError.INVALID_RESPONSE("root must have trunkTransaction");
        if (!r_res.is_value())
            throw new RequestError.INVALID_RESPONSE(@"trunkTransaction must be a string");
        if (r_res.get_value().get_value_type() != typeof(string))
            throw new RequestError.INVALID_RESPONSE(@"trunkTransaction must be a string");
        ret.trunk_transaction = r_res.get_string_value();
        r_res.end_member();
        if (!r_res.read_member("branchTransaction")) throw new RequestError.INVALID_RESPONSE("root must have branchTransaction");
        if (!r_res.is_value())
            throw new RequestError.INVALID_RESPONSE(@"branchTransaction must be a string");
        if (r_res.get_value().get_value_type() != typeof(string))
            throw new RequestError.INVALID_RESPONSE(@"branchTransaction must be a string");
        ret.branch_transaction = r_res.get_string_value();
        r_res.end_member();
        return ret;
    }

    public Gee.List<string>
    attach_to_tangle(string json_result)
    throws RequestError
    {
        Gee.List<string> ret = new ArrayList<string>();
        Json.Parser p_res = new Json.Parser();
        try {
            p_res.load_from_data(json_result);
        } catch (Error e) {
            throw new RequestError.INVALID_RESPONSE("response must be a JSON tree");
        }
        unowned Json.Node res_rootnode = p_res.get_root();
        Json.Reader r_res = new Json.Reader(res_rootnode);
        if (!r_res.is_object()) throw new RequestError.INVALID_RESPONSE("root must be an object");
        if (!r_res.read_member("trytes")) throw new RequestError.INVALID_RESPONSE("root must have trytes");
        if (!r_res.is_array()) throw new RequestError.INVALID_RESPONSE("trytes must be an array");
        for (int j = 0; j < r_res.count_elements(); j++)
        {
            r_res.read_element(j);
            if (!r_res.is_value())
                throw new RequestError.INVALID_RESPONSE(@"each element of trytes must be a string");
            if (r_res.get_value().get_value_type() != typeof(string))
                throw new RequestError.INVALID_RESPONSE(@"each element of trytes must be a string");
            string tryte_el = r_res.get_string_value();
            ret.add(tryte_el);
            r_res.end_element();
        }
        r_res.end_member();
        return ret;
    }

    public void
    broadcast_transactions(string json_result)
    throws RequestError
    {
        Json.Parser p_res = new Json.Parser();
        try {
            p_res.load_from_data(json_result);
        } catch (Error e) {
            throw new RequestError.INVALID_RESPONSE("response must be a JSON tree");
        }
        unowned Json.Node res_rootnode = p_res.get_root();
        Json.Reader r_res = new Json.Reader(res_rootnode);
        if (!r_res.is_object()) throw new RequestError.INVALID_RESPONSE("root must be an object");
        // void
    }

    public void
    store_transactions(string json_result)
    throws RequestError
    {
        Json.Parser p_res = new Json.Parser();
        try {
            p_res.load_from_data(json_result);
        } catch (Error e) {
            throw new RequestError.INVALID_RESPONSE("response must be a JSON tree");
        }
        unowned Json.Node res_rootnode = p_res.get_root();
        Json.Reader r_res = new Json.Reader(res_rootnode);
        if (!r_res.is_object()) throw new RequestError.INVALID_RESPONSE("root must be an object");
        // void
    }
}