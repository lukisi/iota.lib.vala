namespace CCurl
{
    [CCode(cheader_filename = "curl.h")]
    namespace Curl
    {
        [CCode (cname = "NUMBER_OF_ROUNDS")]
        public const int NUMBER_OF_ROUNDS;

        [CCode (cname = "struct _Curl")]
        public struct _Curl {}

        [CCode (cname = "init_curl")]
        public void init_curl(_Curl *ctx);

        [CCode (cname = "absorb")]
        public void absorb(_Curl *ctx, int64 *trits, int offset, int length);

        [CCode (cname = "squeeze")]
        public void squeeze(_Curl *ctx, int64 *trits, int offset, int length);

        [CCode (cname = "reset")]
        public void reset(_Curl *ctx);

        /*

        #define NUMBER_OF_ROUNDS 27


        typedef struct _Curl {
	        trit_t state[STATE_LENGTH];
        } Curl;

        EXPORT void init_curl(Curl *ctx);

        EXPORT void absorb(Curl *ctx, trit_t *const trits, int offset, int length);
        EXPORT void squeeze(Curl *ctx, trit_t *const trits, int offset, int length);
        EXPORT void reset(Curl *ctx);

        */
    }


    [CCode(cheader_filename = "hash.h")]
    namespace Hash
    {
        [CCode (cname = "HASH_LENGTH")]
        public const int HASH_LENGTH;
        [CCode (cname = "STATE_LENGTH")]
        public const int STATE_LENGTH;
        [CCode (cname = "TRYTE_LENGTH")]
        public const int TRYTE_LENGTH;
        [CCode (cname = "TRANSACTION_LENGTH")]
        public const int TRANSACTION_LENGTH;

        [CCode (cname = "trit_t")]
        public struct trit : int64 {}

        /*
        #define HASH_LENGTH 243
        #define STATE_LENGTH 3 * HASH_LENGTH
        #define TRYTE_LENGTH 2673
        #define TRANSACTION_LENGTH TRYTE_LENGTH * 3
        typedef int64_t trit_t;
        */
    }


    [CCode(cheader_filename = "util/converter.h")]
    namespace Converter
    {
        [CCode (cname = "init_converter")]
        public void init_converter();

        [CCode (cname = "trits_from_trytes")]
        public int64 * trits_from_trytes(char * trytes, int length);

        [CCode (cname = "trytes_from_trits")]
        public char * trytes_from_trits(int64 * trits, int offset, int size);

        [CCode (cheader_filename = "stdlib.h", cname = "free")]
        public void free(void * ptr);

        [CCode (cname = "long_value")]
        public int64 long_value(int64 * trits, int offset, int size);

        /*

        void init_converter();
        trit_t *trits_from_trytes(const char *trytes, int length);
        char *trytes_from_trits(trit_t *const trits, const int offset, const int size);
        trit_t long_value(trit_t *const trits, const int offset, const int size);

        void getTrits(const char * bytes, int bytelength, trit_t *const trits, int length);

        trit_t trit_tValue(trit_t *const trits, const int offset, const int size);
        char *bytes_from_trits(trit_t *const trits, const int offset, const int size);
        int indexOf(char *values, char find);
        void copyTrits(trit_t const value, trit_t *const destination, const int offset, const int size);
        trit_t tryteValue(trit_t *const trits, const int offset);
        */
    }
}
