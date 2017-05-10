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

    iota.api.get_new_address.begin(FICTIONALSEED, 0, 10, 2, false, (obj, res) => {
        var result = ((Api)obj).get_new_address.end(res);
        foreach (var a in result) print(@" * $(a)\n");
        loop.quit();
    });

    print("looping.\n");
    loop.run();
    print("Exiting.\n");
}

void test_3()
{
    MainLoop loop = new MainLoop();
    var iota = new Iota();

    iota.api.get_new_address.begin(FICTIONALSEED, 0, null, 2, true, (obj, res) => {
        var result = ((Api)obj).get_new_address.end(res);
        assert(result.size == 1);
        print(@" = $(result[0])\n");
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
            string output = ((Api)obj).get_node_info.end(res);
            print(@"nodeinfo: '$(output)'\n");
        } catch (RequestError e) {
            warning(@"RequestError: $(e.message)");
        }
        loop.quit();
    });

    print("looping.\n");
    loop.run();
    print("Exiting.\n");
}