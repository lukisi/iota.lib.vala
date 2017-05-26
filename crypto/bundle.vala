using Gee;

namespace IotaLibVala
{
    public class Bundle : Object
    {
        public Bundle()
        {
            error("not yet implemented");
        }

        public Gee.List<Transaction> bundle {
            get {
                error("not yet implemented");
            }
        }

        public void add_entry(int signature_message_length,
                              string address,
                              int64 @value,
                              string tag,
                              int timestamp)
        {
            error("not yet implemented");
        }

        public void add_trytes(Gee.List<string> signature_fragments)
        {
            error("not yet implemented");
        }

        public void finalize()
        {
            error("not yet implemented");
        }

        public Gee.List<int64?> normalized_bundle(string bundle_hash)
        {
            error("not yet implemented");
        }
    }
}