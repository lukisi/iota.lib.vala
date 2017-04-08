using Gee;

namespace IotaLibVala
{
    public class Request : Object
    {
        // TODO XMLHttpRequest
        public signal void ready_state_change();
        public int ready_state;
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
                // TODO
            } catch (Error e) {
                throw new RequestError.INVALID_RESPONSE(@"Invalid Response: $(e.message)");
            }
        }
    }
}