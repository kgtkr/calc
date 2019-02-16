require "./ratio"
require "./parser"

begin
    if ARGV[0]==nil
        raise "Error"
    end
    s=ARGV[0]
    print(Parser.new(s).parse().to_str)
rescue => error
    print("Error")
end