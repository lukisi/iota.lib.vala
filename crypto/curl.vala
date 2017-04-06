using Gee;

public class Curl : Object
{
    private ArrayList<int> truth_table;
    private ArrayList<int> state;
    public Curl()
    {
        truth_table = new ArrayList<int>.wrap({1, 0, -1, 1, -1, 0, -1, 1, 0});
    }

    /**
     *   Initializes the state with 729 trits
     *
     *   @method initialize
     **/
    public void initialize(ArrayList<int>? _state=null)
    {
        if (_state != null) state = _state;
        else
        {
            state = new ArrayList<int>();
            for (int i = 0; i < 729; i++) state.add(0);
        }
    }

    /**
     *   Sponge absorb function
     * 
     *   @method absorb
     **/
    public void absorb(ArrayList<int> data)
    {
        for (int i = 0; i < data.size; )
        {
            int j = 0;
            while (i < data.size && j < 243)
            {
                state[j++] = data[i++];
            }
            transform();
        }
    }

    /**
     *   Sponge squeeze function
     *
     *   @method squeeze
     **/
    public void squeeze(out ArrayList<int> data)
    {
        data = new ArrayList<int>();
        for (var i = 0; i < 243; i++)
        {
            data.add(state[i]);
        }
        transform();
    }

    /**
     *   Sponge transform function
     * 
     *   @method transform
     **/
    public void transform()
    {
        ArrayList<int> state_copy;
        int index = 0;
        for (int round = 0; round < 27; round++)
        {
            state_copy = new ArrayList<int>();
            state_copy.add_all(state);
            for (int i = 0; i < 729; i++)
            {
                state[i] = truth_table[state_copy[index] + state_copy[index += (index < 365 ? 364 : -365)] * 3 + 4];
            }
        }
    }
}