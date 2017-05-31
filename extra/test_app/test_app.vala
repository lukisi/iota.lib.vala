using Gee;
using IotaLibVala;

void main(string[] args)
{
    assert(args.length == 2);
    if (args[1] == "1") test_1();
    if (args[1] == "2") test_2();
    if (args[1] == "3") test_3();
}

const string FICTIONALSEED = "THROWAWAYSEED";

void test_1()
{
    MainLoop loop = new MainLoop();
    var iota = new Iota();

    Api.OptionsGetNewAddress options = new Api.OptionsGetNewAddress();
    options.total = 10;
    iota.api.get_new_address.begin(FICTIONALSEED, options, (obj, res) => {
        try {
            var result = ((Api)obj).get_new_address.end(res);
            foreach (var a in result) print(@" * $(a)\n");
            loop.quit();
        } catch (RequestError e) {
            assert_not_reached(); // not even an RPC API call.
        }
    });

    print("looping.\n");
    loop.run();
    print("Exiting.\n");
}

void test_3()
{
    MainLoop loop = new MainLoop();
    var iota = new Iota("http://service.iotasupport.com");

    Api.OptionsGetNewAddress options = new Api.OptionsGetNewAddress();
    options.checksum = true;
    iota.api.get_new_address.begin(FICTIONALSEED, options, (obj, res) => {
        try {
            var result = ((Api)obj).get_new_address.end(res);
            assert(result.size == 1);
            print(@" = $(result[0])\n");
        } catch (RequestError e) {
            warning(@"RequestError. Code = $(e.code). Message: $(e.message)");
        }
        loop.quit();
    });

    print("looping.\n");
    loop.run();
    print("Exiting.\n");
}

void test_2()
{
    MainLoop loop = new MainLoop();
    var iota = new Iota("http://service.iotasupport.com");

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