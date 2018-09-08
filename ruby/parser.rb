require "./ratio"

class ParserError < StandardError; end

class Parser
    def initialize(s)
        @s=s
        @pos=0
    end

    def peak
    end

    def next
    end

    def expect(f)
    end

    def char(c)
    end

    def number
    end

    def eof
    end

    def factor
    end

    def term
    end

    def expr
    end

    def parse
    end
end