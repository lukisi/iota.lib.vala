using Gee;

namespace IotaLibVala
{
    public class Iota : Object
    {
        public string host {get; set;}
        public int port {get; set;}
        public string provider {get; set;}
        public bool token {get; set;}
        public bool sandbox {get; set;}
        public Api api {get; set;}

        private MakeRequest make_request;

        public Iota(string host="http://localhost", int port=14265)
        {
            this.host = host;
            this.port = port;
            provider = @"$(host):$(port)";
            token = false;
            make_request = new MakeRequest(provider, token);
            sandbox = false;
            api = new Api(make_request, sandbox);
        }

        public Iota.client_side_pow(string host="http://localhost", int port=14265)
        {
            this(host, port);
            api = new ApiClientsidePow(make_request, sandbox);
        }
    }
}