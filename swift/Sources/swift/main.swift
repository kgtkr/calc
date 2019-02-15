import Foundation

let s=CommandLine.arguments[1];
do{
    print(toString(try Parser(s).parse()));
}catch{
    print("Error");
}