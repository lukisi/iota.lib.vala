using Gee;
using IotaLibVala;

void main(string[] args)
{
    if (args.length == 2)
    {
        if (args[1] == "1") test_1();
        else if (args[1] == "2") test_2();
        else if (args[1] == "3") test_3();
        else usage(args[0]);
    }
    else usage(args[0]);
    
}

void usage(string appname)
{
    print(@"Usage: $(appname) <num>\n");
    print(@"   num=1: compute 10 addresses\n");
    print(@"   num=2: get_node_info\n");
    print(@"   num=3: find next unused address\n");
    print("""

In file config.ini, under section [TEST_APP], you can specify:
    SEED
    HOST
    PORT

""");
}

string seed;
string host;
int port;

void test_1()
{
    seed = "THROWAWAYSEED";
    host = "http://service.iotasupport.com";
    port = 14265;
    load_configuration();

    MainLoop loop = new MainLoop();
    var iota = new Iota(host, port);

    Api.OptionsGetNewAddress options = new Api.OptionsGetNewAddress();
    options.total = 10;
    iota.api.get_new_address.begin(seed, options, (obj, res) => {
        try {
            var result = ((Api)obj).get_new_address.end(res);
            foreach (var a in result) print(@" * $(a)\n");
            loop.quit();
        } catch (RequestError e) {
            assert_not_reached(); // not even an RPC API call.
        } catch (InputError e) {
            assert_not_reached(); // not even an RPC API call.
        }
    });

    print("looping.\n");
    loop.run();
    print("Exiting.\n");
}

void test_3()
{
    seed = "THROWAWAYSEED";
    host = "http://service.iotasupport.com";
    port = 14265;
    load_configuration();

    MainLoop loop = new MainLoop();
    var iota = new Iota(host, port);

    Api.OptionsGetNewAddress options = new Api.OptionsGetNewAddress();
    options.checksum = true;
    iota.api.get_new_address.begin(seed, options, (obj, res) => {
        try {
            var result = ((Api)obj).get_new_address.end(res);
            assert(result.size == 1);
            print(@" = $(result[0])\n");
        } catch (RequestError e) {
            warning(@"RequestError. Code = $(e.code). Message: $(e.message)");
        } catch (InputError e) {
            warning(@"InputError. Code = $(e.code). Message: $(e.message)");
        }
        loop.quit();
    });

    print("looping.\n");
    loop.run();
    print("Exiting.\n");
}

void test_2()
{
    seed = "THROWAWAYSEED";
    host = "http://service.iotasupport.com";
    port = 14265;
    load_configuration();

    MainLoop loop = new MainLoop();
    var iota = new Iota(host, port);

    iota.api.get_node_info.begin((obj, res) => {
        try {
            var result = ((Api)obj).get_node_info.end(res);
            print(@"nodeinfo: '$(result.json_result)'\n");
        } catch (RequestError e) {
            warning(@"RequestError: $(e.message)");
        }
        loop.quit();
    });

    print("looping.\n");
    loop.run();
    print("Exiting.\n");
}

void load_configuration()
{
    string fname = "config.ini";
    KeyFile conf = new KeyFile();
    try
    {
        conf.load_from_file(fname, KeyFileFlags.NONE);
        if (conf.has_group("TEST_APP"))
        {
            if (conf.has_key("TEST_APP", "SEED")) seed = conf.get_string("TEST_APP", "SEED");
            else warning("using default SEED");
            if (conf.has_key("TEST_APP", "HOST")) host = conf.get_string("TEST_APP", "HOST");
            else warning("using default HOST");
            if (conf.has_key("TEST_APP", "PORT")) port = conf.get_integer("TEST_APP", "PORT");
            else warning("using default PORT");
        }
        else warning("no section TEST_APP in config.ini");
    }
    catch (KeyFileError.NOT_FOUND e) {warning("no config.ini");}
    catch (FileError.NOENT e) {warning("no config.ini");}
    catch (Error e) {error(e.message);}
}
