using Gee;

public void sample_routine()
{
    ArrayList<int> l = new ArrayList<int>();
    l.add(1);
    l.add(2);
    foreach (int i in l) print(@"$(i)\n");
}
