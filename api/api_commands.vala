using Gee;

namespace IotaLibVala.ApiCommand
{
    public class Command : Object
    {
        public string command {get; set;}
    }

    public Command get_node_info()
    {
        var ret = new Command();
        ret.command = "getNodeInfo";
        return ret;
    }
}