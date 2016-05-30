package test {
import com.google.protobuf.Enum;

public class Response extends Enum {
    public static const OK:Response = new Response(0);
    public static const NO:Response = new Response(1);

    public function Response(value:int) {
        super(value);
    }
    
    public static function valueOf(value:int):Response {
        switch (value) {
            default:
                return OK;
            case 0:
                return OK;
            case 1:
                return NO;
        }
    }
    
    public static function toEnums(values:Vector.<int>):Vector.<Response> {
        var enums:Vector.<Response> = new Vector.<Response>();
        for each (var value:int in values) {
            enums.push(Response.valueOf(value));
        }
        return enums;
    }
}
}
