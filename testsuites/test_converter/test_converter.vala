using Gee;

void main()
{
    Converter c = Converter.singleton;

    ArrayList<int> trits = c.trits_from_int(13);
    ArrayList<int> expect = new ArrayList<int>.wrap({1, 1, 1});
    assert(trits.size == expect.size);
    for (int i = 0; i < expect.size; i++) assert(trits[i] == expect[i]);

    trits = c.trits_from_string("SPAM9");
    expect = new ArrayList<int>.wrap({1, 0, -1, 1, -1, -1, 1, 0, 0, 1, 1, 1, 0, 0, 0});
    assert(trits.size == expect.size);
    for (int i = 0; i < expect.size; i++) assert(trits[i] == expect[i]);

    string back = c.trytes(trits);
    assert(back == "SPAM9");
}

