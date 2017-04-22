using Gee;
using Soup;

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
        private Session session;
        private Soup.Message msg;
        public Request(string provider)
        {
            // create an HTTP session
            session = new Session();
            msg = new Soup.Message("POST", provider);
        }

        public async string send(string json) throws Error
        {
            debug(@"Request: sending message to provider = $(msg.get_uri().to_string(false))");
            debug(@"Request: message = '$(json)'");
            SourceFunc cb = send.callback;
            msg.request_body.append_take(json.data);
            msg.request_headers.append("Content-Type", "application/json");
            // async send the HTTP request and register callback
            session.queue_message(msg, (ses, mes) => {
                assert(mes == msg);
                cb();
            });
            yield;
            if (msg.status_code != (uint)Soup.Status.OK)
            {
                debug(@"Request: report status = $(msg.status_code)");
                throw new RequestError.REQUEST_ERROR(@"status = $(msg.status_code)");
            }
            string ret = (string)msg.response_body.data;
            debug(@"Request: report response = '$(ret)'");
            return ret;
        }
    }

    public class MakeRequest : Object
    {
        public string provider {get; set;}
        public bool token {get; set;}

        public MakeRequest(string provider, bool token)
        {
            this.provider = provider;
            this.token = token;
        }

        private Request open()
        {
            return new Request(provider);
        }

        public async string send(Object command) throws RequestError
        {
            var request = open();
            string ret;
            try {
                ret = yield request.send(json_string_object(command));
            } catch (Error e) {
                throw new RequestError.INVALID_RESPONSE(@"Invalid Response: $(e.message)");
            }
            return ret;
        }
    }
}