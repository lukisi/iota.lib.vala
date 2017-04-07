using Gee;

public class Iota : Object
{
    public string host {get; set;}
    public int port {get; set;}
    public string provider {get; set;}

    public Iota(string host="http://localhost", int port=14265)
    {
        this.host = host;
        this.port = port;
        this.provider = @"$(host):$(port)";
    }
}
