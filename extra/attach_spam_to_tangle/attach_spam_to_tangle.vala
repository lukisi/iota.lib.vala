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

string address;
string host;
int port;

async void dostuff()
{
    Idle.add(dostuff.callback);
    yield;

    address = "999999999999999999999999999999999999999999999999999999999999999999999999999999999";
    host = "http://service.iotasupport.com";
    port = 14265;

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
        if (conf.has_group("ATTACH_SPAM_TO_TANGLE"))
        {
            if (conf.has_key("ATTACH_SPAM_TO_TANGLE", "ADDRESS")) address = conf.get_string("ATTACH_SPAM_TO_TANGLE", "ADDRESS");
            else warning("using default ADDRESS");
            if (conf.has_key("ATTACH_SPAM_TO_TANGLE", "HOST")) host = conf.get_string("ATTACH_SPAM_TO_TANGLE", "HOST");
            else warning("using default HOST");
            if (conf.has_key("ATTACH_SPAM_TO_TANGLE", "PORT")) port = conf.get_integer("ATTACH_SPAM_TO_TANGLE", "PORT");
            else warning("using default PORT");
        }
        else warning("no section ATTACH_SPAM_TO_TANGLE in config.ini");
    }
    catch (KeyFileError.NOT_FOUND e) {warning("no config.ini");}
    catch (FileError.NOENT e) {warning("no config.ini");}
    catch (Error e) {error(e.message);}
}
