enum Rational{
    case value(Int,Int)
    case nan
}

func gcd(_ a: Int,_ b: Int) -> Int {
  return b == 0 ? a : gcd(b, a % b);
}

func rational(_ n:Int,_ d:Int)->Rational{
    if d == 0 {
      return Rational.nan;
    } else {
      let g = d.signum() * gcd(abs(n), abs(d));
      return Rational.value(n / g, d / g);
    }
}

func toString(_ x:Rational)->String{
    if case .value(let n,let d) = x{
        if d==1{
            return String(n);
        }else{
            return "\(n)/\(d)";
        }
    }else{
        return "NaN";
    }
}

func +(_ a:Rational,_ b:Rational)->Rational{
    if case (.value(let a_n,let a_d),.value(let b_n,let b_d))=(a,b){
        return rational(a_n * b_d + b_n * a_d, a_d * b_d);
    }else{
        return Rational.nan;
    }
}

func -(_ a:Rational,_ b:Rational)->Rational{
    if case (.value(let a_n,let a_d),.value(let b_n,let b_d))=(a,b){
        return rational(a_n * b_d - b_n * a_d, a_d * b_d);
    }else{
        return Rational.nan;
    }
}

func *(_ a:Rational,_ b:Rational)->Rational{
    if case (.value(let a_n,let a_d),.value(let b_n,let b_d))=(a,b){
        return rational(a_n * b_n, a_d * b_d);
    }else{
        return Rational.nan;
    }
}

func /(_ a:Rational,_ b:Rational)->Rational{
    if case (.value(let a_n,let a_d),.value(let b_n,let b_d))=(a,b){
        return rational(a_n * b_d, a_d * b_n);
    }else{
        return Rational.nan;
    }
}