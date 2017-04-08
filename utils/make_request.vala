using Gee;

namespace IotaLibVala
{
    internal string json_string_object(Object obj)
    {
        Json.Node n = Json.gobject_serialize(obj);
        Json.Generator g = new Json.Generator();
        g.root = n;
        string ret = g.to_data(null);
        return ret;
    }

    public class Request : Object
    {
        // TODO XMLHttpRequest
        public signal void ready_state_change();
        public int ready_state;
        public void send(string msg) throws Error
        {
            error("not implemented yet.");
        }
    }

    public class MakeRequest : Object
    {
        public string provider {get; set;}
        public Request open()
        {
            var request = new Request();
            // TODO
            error("not implemented yet.");
            // return request;
        }

        public void send(Object command, SourceFunc callback) throws RequestError
        {
            var request = open();
            request.ready_state_change.connect(() => {
                if (request.ready_state == 4) {
                    // TODO
                }
            });
            try {
                request.send(json_string_object(command));
            } catch (Error e) {
                throw new RequestError.INVALID_RESPONSE(@"Invalid Response: $(e.message)");
            }
        }
    }
}