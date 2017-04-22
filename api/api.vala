using Gee;

namespace IotaLibVala
{
    public class Address : Object {}

    public class Api : Object
    {
        public MakeRequest make_request {get; set;}

        public Api(MakeRequest make_request, bool sandbox)
        {
            this.make_request = make_request;
            if (sandbox)
            {
                error("sandbox not implemented");
            }
        }

        public async string send_command(Object command)
        {
            return yield make_request.send(command);
        }

        public async string get_node_info()
        {
            var command = ApiCommand.get_node_info();
            return yield send_command(command);
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