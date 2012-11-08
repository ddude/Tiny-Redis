import tinyredis.redis,
       std.stdio
    ;

/**
 * Make sure the redis server is running
 */
void main()
{
    /**
     * If your redis server is not on its standard host/port, adjust it here :
     */
    auto redis = new Redis("localhost", 6379);
    try{
        //The LASTSAVE command does not take any parameters and returns an int
        Response r = redis.send("LASTSAVE");
        assert(r.type == ResponseType.Integer);
        writeln(r.intval);
        
        //Here's how you get the value of the field 
        writeln(redis.send("SET name adil"));
        r = redis.send("GET name");
        writeln("My name is ", r.value);
        
        //And here's a redis set
        writeln(redis.send("SADD", "myset", "adil"));
        writeln(redis.send("SADD", "myset", 350001939));
        writeln(redis.send("SADD", "myset", 1.2));
        writeln(redis.send("SADD", "myset", true));
        writeln(redis.send("SMEMBERS myset"));
     
        //You can also pass your data as an array
//        redis.send("SREM", ["myset", "adil", "350001939"]); //for redis v2.4 and above
     
        //Redis Transactions
        writeln(redis.send("MULTI")); //OK
        writeln(redis.send("INCR foo")); //QUEUED
        writeln(redis.send("SMEMBERS myset")); //QUEUED
        writeln(redis.send("INCR bar")); //QUEUED
        writeln(redis.send("EXEC")); //[(Integer) 1, [350001939, $4, true, 1, 1.2, adil], (Integer) 1]
        
        //And finally this command will throw a RedisResponseException
        writeln(redis.send("AND THIS IS A COMMAND REDIS DOES NOT UNDERSTAND"));
    }catch(RedisResponseException e)
    {
        writeln("(error) ", e.msg);
    }
}