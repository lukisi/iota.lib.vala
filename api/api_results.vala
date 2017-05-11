using Gee;

namespace IotaLibVala.ApiResults
{
    public Gee.List<Transaction>
    find_transactions_for_address(string json_result)
    throws RequestError
    {
        ArrayList<Transaction> ret = new ArrayList<Transaction>();
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
        string[] hashes = new string[r_res.count_elements()];
        for (int j = 0; j < hashes.length; j++)
        {
            r_res.read_element(j);
            if (!r_res.is_value())
                throw new RequestError.INVALID_RESPONSE(@"each hash must be a string");
            if (r_res.get_value().get_value_type() != typeof(string))
                throw new RequestError.INVALID_RESPONSE(@"each hash must be a string");
            hashes[j] = r_res.get_string_value();
            r_res.end_element();
        }
        r_res.end_member();
        foreach (string hash in hashes)
        {
            Transaction t = new Transaction();
            t.t_hash = hash;
            ret.add(t);
        }
        return ret;
    }
}