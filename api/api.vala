using Gee;

namespace IotaLibVala
{
    public class Address : Object {}

    public class Api : Object
    {
        public Object make_request {get; set;}
        public Api()
        {
            // TODO make_request = provider
        }

        public async void send_command()
        {
            // TODO
            error("not implemented yet");
        }

        public async ArrayList<Object> get_new_address(string seed, int index, int? total, int security, bool checksum)
        {
            // TODO validate the seed

            ArrayList<Object> ret = new ArrayList<Object>();

            if (total != null)
            {
                for (var i = 0; i < total; i++, index++) {
                    ret.add(make_new_address(seed, index, security, checksum));
                }
                return ret;
            }

            error("not implemented yet");
        }

        public Object make_new_address(string seed, int index, int security, bool checksum)
        {
            return new Address();
        }
    }
}