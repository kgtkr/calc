import * as Rational from "./rational";

export class Parser {
    pos = 0;
    constructor(public s: string) {
    }

    peek() {
        if (this.pos >= this.s.length) {
            throw new Error();
        }
        return this.s[this.pos];
    }

    next() {
        let v = this.peek();
        this.pos++;
        return v;
    }

    expect(f: (x: string) => boolean) {
        let v = this.peek();
        if (f(v)) {
            this.next();
            return v;
        } else {
            throw new Error();
        }
    }

    char(c: string) {
        return this.expect(v => v === c);
    }

    number() {
        let g;
        let s = "";
        try {
            this.char("-");
            g = -1;
        } catch{
            g = 1;
        }

        while (true) {
            try {
                s += this.expect(isDigit);
            } catch{
                if (s.length === 0) {
                    throw new Error();
                } else {
                    break;
                }
            }
        }

        if (s.length !== 1 && s[0] === "0") {
            throw new Error();
        }
        const v = +s * g;
        if (isNaN(v)) {
            throw new Error();
        } else {
            return Rational.rational(v, 1);
        }
    }

    eof() {
        if (this.s.length !== this.pos) {
            throw new Error();
        }
    }

    factor(): Rational.Rational {
        try {
            this.char("(");
        } catch{
            return this.number();
        }

        let v = this.expr();
        this.char(")");
        return v;
    }

    term(): Rational.Rational {
        let x = this.factor();
        while (true) {
            let op;
            try {
                op = this.expect(c => c === "*" || c === "/");
            } catch{
                break;
            }

            switch (op) {
                case "*":
                    x = Rational.mul(x, this.factor());
                    break;
                case "/":
                    x = Rational.div(x, this.factor());
                    break;
            }
        }
        return x;
    }

    expr(): Rational.Rational {
        let x = this.term();
        while (true) {
            let op;
            try {
                op = this.expect(c => c === "+" || c === "-");
            } catch{
                break;
            }

            switch (op) {
                case "+":
                    x = Rational.add(x, this.term());
                    break;
                case "-":
                    x = Rational.sub(x, this.term());
                    break;
            }
        }
        return x;
    }

    parse() {
        let v = this.expr();
        this.eof();
        return v;
    }
}

function isDigit(c: string) {
    return "0123456789".includes(c);
}