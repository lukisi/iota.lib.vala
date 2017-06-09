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

const int depth = 4;
const int min_weight_magnitude = 13;

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

    Api.TransferToSend transfer = new Api.TransferToSend(address, val);
    transfer.tag = tag;
    transfer.message = message;
    Api.SendTransferOptions options = new Api.SendTransferOptions();
    Gee.List<Transaction> transactions;
    try {
        transactions = yield iota.api.send_transfer
            (seed,
             depth,
             min_weight_magnitude,
             new ArrayList<Api.TransferToSend>.wrap({transfer}),
             options);
    } catch (InputError e) {
        error(@"InputError $(e.message)");
    } catch (RequestError e) {
        error(@"RequestError $(e.message)");
    } catch (BalanceError e) {
        error(@"BalanceError $(e.message)");
    }
    print(@"Success! Returned $(transactions.size) transactions:\n");
    foreach (Transaction transaction in transactions) {
        print("\n");
        print(@"hash: $(transaction.hash)\n");
        print(@"signature_message_fragment: $(transaction.signature_message_fragment)\n");
        print(@"address: $(transaction.address)\n");
        print(@"value: $(transaction.@value)\n");
        print(@"tag: $(transaction.tag)\n");
        print(@"timestamp: $(transaction.timestamp)\n");
        print(@"current_index: $(transaction.current_index)\n");
        print(@"last_index: $(transaction.last_index)\n");
        print(@"bundle: $(transaction.bundle)\n");
        print(@"trunk_transaction: $(transaction.trunk_transaction)\n");
        print(@"branch_transaction: $(transaction.branch_transaction)\n");
        print(@"nonce: $(transaction.nonce)\n");
    }
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
            if (conf.has_key("SEND_TOKENS", "SEED")) seed = conf.get_string("SEND_TOKENS", "SEED");
            else warning("using default SEED");
            if (conf.has_key("SEND_TOKENS", "ADDRESS")) address = conf.get_string("SEND_TOKENS", "ADDRESS");
            else warning("using default ADDRESS");
            if (conf.has_key("SEND_TOKENS", "HOST")) host = conf.get_string("SEND_TOKENS", "HOST");
            else warning("using default HOST");
            if (conf.has_key("SEND_TOKENS", "PORT")) port = conf.get_integer("SEND_TOKENS", "PORT");
            else warning("using default PORT");
            if (conf.has_key("SEND_TOKENS", "VALUE")) val = conf.get_int64("SEND_TOKENS", "VALUE");
            else warning("using default VALUE");
            if (conf.has_key("SEND_TOKENS", "TAG")) tag = conf.get_string("SEND_TOKENS", "TAG");
            else warning("using default TAG");
            if (conf.has_key("SEND_TOKENS", "MESSAGE")) message = conf.get_string("SEND_TOKENS", "MESSAGE");
            else warning("using default MESSAGE");
        }
        else warning("no section SEND_TOKENS in config.ini");
    }
    catch (KeyFileError.NOT_FOUND e) {warning("no config.ini");}
    catch (FileError.NOENT e) {warning("no config.ini");}
    catch (Error e) {error(e.message);}
}
