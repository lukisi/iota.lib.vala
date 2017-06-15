using Gee;

namespace IotaLibVala
{
    public class Pow : Object
    {
        private static Pow _instance;
        public static Pow singleton {
            get {
                if (_instance == null) _instance = new Pow();
                return _instance;
            }
        }

        private Pow()
        {
        }

        public async string ccurl_pow(string trytes, int min_weight_magnitude)
        {
            // TODO should return null if interrupted with ccurl_pow_interrupt.
            SourceFunc callback = ccurl_pow.callback;
            Thread<string> t;
            try {
                t = new Thread<string>.try("pow", () => {
                    char * buf = CCurl.Pow.ccurl_pow((char *)trytes, min_weight_magnitude);
                    string ret = (string)buf;
                    CCurl.Pow.free(buf);
                    // Schedule callback and pass back result
                    Idle.add((owned) callback);
                    return ret;
                });
            } catch (Error e) {
                error("Couldn't create thread");
            }

            // Wait for background thread to schedule our callback
            yield;
            return t.join();
        }
    }
}
