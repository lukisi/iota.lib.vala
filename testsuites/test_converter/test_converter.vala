using Gee;
using IotaLibVala;

void main()
{
    Converter c = Converter.singleton;

    Gee.List<int64?> trits;
    Gee.List<int64?> expect;

    trits = c.trits_from_trytes("SPAM9");
    expect = new ArrayList<int64?>.wrap({1, 0, -1, 1, -1, -1, 1, 0, 0, 1, 1, 1, 0, 0, 0});
    assert(trits.size == expect.size);
    for (int i = 0; i < expect.size; i++) assert(trits[i] == expect[i]);

    string back = c.trytes(trits);
    assert(back == "SPAM9");
}

