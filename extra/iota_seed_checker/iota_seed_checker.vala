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

async void dostuff()
{
    Idle.add(dostuff.callback);
    yield;

    string seed = "THROWAWAYSEED";
    int total = 10;

    var iota = new Iota("http://service.iotasupport.com");

    Api.OptionsGetNewAddress options = new Api.OptionsGetNewAddress();
    options.total = total;
    Gee.List<Address> addresses;
    try {
        addresses = yield iota.api.get_new_address(seed, options);
    } catch (RequestError e) {
        assert_not_reached(); // not even an RPC API call.
    }
    foreach (var a in addresses) print(@" * $(a)\n");
    Gee.List<int64?> inputs;
    try {
        ApiResults.GetBalancesResponse resp = yield iota.api.get_balances(addresses, 100);
        inputs = resp.balances;
    } catch (RequestError e) {
        error(e.message);
    }
    var i = 0;
    int64 totalB = 0;
    foreach (int64? b in inputs)
    {
        assert(b != null);
        totalB += b; 
        if (b > 0) {
            print(@"$(i+1) The address $(addresses[i].s) has a balance of: $(b)\n");
            print("Balance detected!!!\n");
        } else {
            print(@"$(i+1) The address $(addresses[i].s) has a balance of: $(b)\n");
        };
        i++;
    }
    print(@"Total value for this seed = $(totalB)\n");
}
