extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct ParseError: Error{
    
}

class Parser{
    var pos:Int=0
    var s:Array<Character>

    init(_ s:String) {
        self.s=Array(s);
    }

    func peak() throws ->Character{
        if case Optional.some(let x)=self.s[safe:self.pos]{
            return x;
        }else{
            throw ParseError();
        }
    }

    func expect(_ f:(Character)->Bool)throws->Character{
        let x=try self.peak();
        if f(x){
            self.pos+=1;
            return x;
        }else{
            throw ParseError();
        }
    }

    func char(_ c:Character)throws->Character{
        return try self.expect{$0==c};
    }

    func number()throws->Rational{
        var s:Array<Character>=[];
        let g = (try? self.char("-")).map{(_) in -1} ?? 1;
        while case .some(let c) = try? self.expect({"0"..."9" ~= $0}) {
            s.append(c);
        }

        if s.count != 1 && s[safe:0]==Optional.some("0"){
            throw ParseError();
        }else{
            if case Optional.some(let x)=Int(String(s)).map({rational($0*g,1)}){
                return x;
            }else{
                throw ParseError();
            }
        }
    }

    func eof()throws{
        if self.s.count>self.pos{
            throw ParseError();
        }
    }

    func expr()throws->Rational{
        var x=try self.term();
        while case Optional.some(let c) = try? self.expect({$0 == "+" || $0 == "-"}) {
            if c=="+"{
                x = x+(try self.term());
            }else{
                x = x-(try self.term());
            }
        }
        return x;
    }

    func term()throws->Rational{
        var x=try self.factor();
        while case Optional.some(let c) = try? self.expect({$0 == "*" || $0 == "/"}) {
            if c=="*"{
                x = x * (try self.factor());
            }else{
                x = x / (try self.factor());
            }
        }
        return x;
    }

    func factor() throws-> Rational {
        if case Optional.some(_) = try? self.char("(") {
            let ret = try self.expr();
            let _=try self.char(")");
            return ret;
        } else {
            return try self.number();
        }
    }

    func parse()throws->Rational{
        let x = try self.expr();
        try self.eof();
        return x;
    }
}