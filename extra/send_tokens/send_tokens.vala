using Gee;
using IotaLibVala;

void main()
{
    MainLoop loop = new MainLoop();
    dostuff.begin((obj, res) => {
        dostuff.end(res);
        loop.quit();
    });

    print("looping.\n");
    loop.run();
    print("Exiting.\n");
}

string seed;
string address;
string host;
int port;
int64 val;
string tag;
string message;

async void dostuff()
{
    Idle.add(dostuff.callback);
    yield;

    seed = "THROWAWAYSEED";
    address = "999999999999999999999999999999999999999999999999999999999999999999999999999999999";
    host = "http://service.iotasupport.com";
    port = 14265;
    val = 1;
    tag = "";
    message = "";

    load_configuration();

    var iota = new Iota(host, port);

    // TODO
}


void load_configuration()
{
    string fname = "config.ini";
    KeyFile conf = new KeyFile();
    try
    {
        conf.load_from_file(fname, KeyFileFlags.NONE);
        if (conf.has_group("SEND_TOKENS"))
        {
            if (conf.has_key("SEND_TOKENS", "SEED")) address = conf.get_string("SEND_TOKENS", "SEED");
            if (conf.has_key("SEND_TOKENS", "ADDRESS")) address = conf.get_string("SEND_TOKENS", "ADDRESS");
            if (conf.has_key("SEND_TOKENS", "HOST")) host = conf.get_string("SEND_TOKENS", "HOST");
            if (conf.has_key("SEND_TOKENS", "PORT")) port = conf.get_integer("SEND_TOKENS", "PORT");
            if (conf.has_key("SEND_TOKENS", "VALUE")) val = conf.get_int64("SEND_TOKENS", "VALUE");
            if (conf.has_key("SEND_TOKENS", "TAG")) tag = conf.get_string("SEND_TOKENS", "TAG");
            if (conf.has_key("SEND_TOKENS", "MESSAGE")) message = conf.get_string("SEND_TOKENS", "MESSAGE");
        }
    }
    catch (KeyFileError.NOT_FOUND e) {}
    catch (FileError.NOENT e) {}
    catch (Error e) {error(e.message);}
}
