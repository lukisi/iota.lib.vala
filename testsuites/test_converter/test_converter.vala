using Gee;
using Converter;

void main()
{
    ArrayList<int> trits = trits_from_int(13);
    assert(trits.size == 3);
    assert(trits[0] == 1);
    assert(trits[1] == 1);
    assert(trits[2] == 1);
}

