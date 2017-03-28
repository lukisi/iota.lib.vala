using Gee;

void main()
{
    Converter c = Converter.singleton;
    ArrayList<int> trits = c.trits_from_int(13);
    assert(trits.size == 3);
    assert(trits[0] == 1);
    assert(trits[1] == 1);
    assert(trits[2] == 1);
}

