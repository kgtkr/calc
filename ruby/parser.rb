require "./ratio"

class ParserError < StandardError; end

class Parser
    def initialize(s)
        @s=s
        @pos=0
    end

    def peak
        if @pos>=@s.length
            raise ParserError.new
        end
        @s[@pos]
    end

    def next
        v=@peak
        @pos++
        v
    end

    def expect(f)
        v=@peak
        if f(v)
            @next
            v
        else
            raise ParserError.new
        end
    end

    def char(c)
        @expect(lambda{|v|v==c})
    end

    def number
        s=""
        begin
            @char("-1")
            g=-1
        rescue => error
            g=1
        end

        while true
            begin
                s+=@expect(lambda{|v|"1234567890".index(v)!=nil})
            rescue => error
                break
            end
        end

        if s.length!=1&&s[0]==0
            raise ParserError.new
        end
        
        begin
            v=Integer(s)*g
        rescue =>error
            raise ParserError.new
        end

        Ratio.new(v,1)
    end

    def eof
        if @s.length!=@pos
            raise ParserError.new
        end
    end

    def factor
        begin
            @char("(")
        rescue =>error
            return @number
        end

        v=@expr
        char(")")
        v
    end

    def term
        x=@factor
        while true
            begin
                op=@expect(lambda{|c|c=="*"||c=="/"})
            rescue => error
                break
            end

            case op
            when "*"
                x=x*@factor
                break
            when "/"
                x/@factor
                break
            end
        end
        x
    end

    def expr
        x=@term
        while true
            begin
                op=@expect(lambda{|c|c=="+"||c=="-"})
            rescue => error
                break
            end

            case op
            when "+"
                x=x+@term
                break
            when "-"
                x+@term
                break
            end
        end
        x
    end

    def parse
        v=@expr
        eof
        v
    end
end