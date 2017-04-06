using Gee;

namespace IotaLibVala
{
    public class Curl : Object
    {
        private CCurl.Curl._Curl _curl;
        public Curl() {
            _curl = CCurl.Curl._Curl();
        }

        public void init() {
            CCurl.Curl.init_curl(&_curl);
        }
    }
}
