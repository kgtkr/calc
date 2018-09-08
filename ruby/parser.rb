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
        v=self.peak
        @pos+=1
        v
    end

    def expect(f)
        v=self.peak
        if f.call(v)
            self.next
            v
        else
            raise ParserError.new
        end
    end

    def char(c)
        self.expect(lambda{|v|v==c})
    end

    def number
        s=""
        begin
            self.char("-1")
            g=-1
        rescue => error
            g=1
        end

        while true
            begin
                s+=self.expect(lambda{|v|"1234567890".index(v)!=nil})
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
            self.char("(")
        rescue =>error
            return self.number
        end

        v=self.expr
        char(")")
        v
    end

    def term
        x=self.factor
        while true
            begin
                op=self.expect(lambda{|c|c=="*"||c=="/"})
            rescue => error
                break
            end

            case op
            when "*"
                x=x*self.factor
                break
            when "/"
                x/self.factor
                break
            end
        end
        x
    end

    def expr
        x=self.term
        while true
            begin
                op=self.expect(lambda{|c|c=="+"||c=="-"})
            rescue => error
                break
            end

            case op
            when "+"
                x=x+self.term
                break
            when "-"
                x+self.term
                break
            end
        end
        x
    end

    def parse
        v=self.expr
        eof
        v
    end
end