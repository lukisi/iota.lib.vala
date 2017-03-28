using Gee;

namespace Converter
{
    const string trytesAlphabet = "9ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    

    public ArrayList<int> trits_from_int(int input, ArrayList<int>? state = null)
    {
        ArrayList<int> ret = new ArrayList<int>();
        if (state != null) ret.add_all(state);
        error("not yet implemented");
    }

    public ArrayList<int> trits_from_string(string input)
    {
        error("not yet implemented");
    }
}

