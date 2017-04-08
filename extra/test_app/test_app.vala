using Gee;
using IotaLibVala;

void main()
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
