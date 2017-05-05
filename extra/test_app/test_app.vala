using Gee;
using IotaLibVala;

void main()
{
    test_2();
}

void test_1()
{
    MainLoop loop = new MainLoop();
    var iota = new Iota();

    iota.api.get_new_address.begin("HELP", 0, 10, 2, false, (obj, res) => {
        var result = ((Api)obj).get_new_address.end(res);
        print(@"List of $(result.size) items.\n");
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