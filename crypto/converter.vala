using Gee;

public class Converter : Object
{
    private static Converter _instance;
    public static Converter singleton {
        get {
            if (_instance == null) _instance = new Converter();
            return _instance;
        }
    }

    private const string trytesAlphabet = "9ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private ArrayList<ArrayList<int>> trytesTrits;

    private Converter()
    {
        trytesTrits = new ArrayList<ArrayList<int>>.wrap({
            new ArrayList<int>.wrap({  0,  0,  0}),
            new ArrayList<int>.wrap({  1,  0,  0}),
            new ArrayList<int>.wrap({ -1,  1,  0}),
            new ArrayList<int>.wrap({  0,  1,  0}),
            new ArrayList<int>.wrap({  1,  1,  0}),
            new ArrayList<int>.wrap({ -1, -1,  1}),
            new ArrayList<int>.wrap({  0, -1,  1}),
            new ArrayList<int>.wrap({  1, -1,  1}),
            new ArrayList<int>.wrap({ -1,  0,  1}),
            new ArrayList<int>.wrap({  0,  0,  1}),
            new ArrayList<int>.wrap({  1,  0,  1}),
            new ArrayList<int>.wrap({ -1,  1,  1}),
            new ArrayList<int>.wrap({  0,  1,  1}),
            new ArrayList<int>.wrap({  1,  1,  1}),
            new ArrayList<int>.wrap({ -1, -1, -1}),
            new ArrayList<int>.wrap({  0, -1, -1}),
            new ArrayList<int>.wrap({  1, -1, -1}),
            new ArrayList<int>.wrap({ -1,  0, -1}),
            new ArrayList<int>.wrap({  0,  0, -1}),
            new ArrayList<int>.wrap({  1,  0, -1}),
            new ArrayList<int>.wrap({ -1,  1, -1}),
            new ArrayList<int>.wrap({  0,  1, -1}),
            new ArrayList<int>.wrap({  1,  1, -1}),
            new ArrayList<int>.wrap({ -1, -1,  0}),
            new ArrayList<int>.wrap({  0, -1,  0}),
            new ArrayList<int>.wrap({  1, -1,  0}),
            new ArrayList<int>.wrap({ -1,  0,  0})
        });
    }

    public ArrayList<int> trits_from_int(int input, ArrayList<int>? state = null)
    {
        ArrayList<int> ret = new ArrayList<int>();
        if (state != null) ret.add_all(state);

        var absoluteValue = input < 0 ? -input : input;

        while (absoluteValue > 0)
        {
            var remainder = absoluteValue % 3;
            absoluteValue = absoluteValue / 3;

            if (remainder > 1)
            {
                remainder = -1;
                absoluteValue++;
            }

            ret.add(remainder);
        }
        if (input < 0)
        {
            for (var i = 0; i < ret.size; i++)
            {
                ret[i] = -ret[i];
            }
        }

        return ret;
    }

    public ArrayList<int> trits_from_string(string input, ArrayList<int>? state = null)
    {
        ArrayList<int> ret = new ArrayList<int>();
        if (state != null) ret.add_all(state);

        for (var i = 0; i < input.length; i++)
        {
            var index = trytesAlphabet.index_of_char(input[i]);
            ret.add(trytesTrits[index][0]);
            ret.add(trytesTrits[index][1]);
            ret.add(trytesTrits[index][2]);
        }

        return ret;
    }

}

