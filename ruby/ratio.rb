class Ratio
    attr_reader :d,:n
    def initialize(n,d)
        if d==0 then
            @n=1
            @d=0
        else
            g=n.abs.gcd(d.abs)
            @n=n/g
            @d=d/g
        end

    end

    def to_str()
        if @d==0 then
            "NaN"
        else
            @n.to_s+"/"+@d.to_s
        end
    end

    def +(other)
        if @d!=0&&other.d!=0 then
            Ratio.new(@n * other.d + other.n * @d, @d * other.d)
        else
            Ratio.new(1,0)
        end
    end

    def -(other)
        if @d!=0&&other.d!=0 then
            Ratio.new(@n * other.d - other.n * @d, @d * other.d)
        else
            Ratio.new(1,0)
        end
    end

    def *(other)
        if @d!=0&&other.d!=0 then
            Ratio.new(@n*other.n, @d * other.d)
        else
            Ratio.new(1,0)
        end
    end

    def /(other)
        if @d!=0&&other.d!=0 then
            Ratio.new(@n*other.d, @d * other.n)
        else
            Ratio.new(1,0)
        end
    end
end