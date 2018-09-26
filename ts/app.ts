import { Parser } from "./parser";
import * as Rational from "./rational";

try {
    if (process.argv.length < 3) {
        throw new Error();
    }
    const s = process.argv[2];
    console.log(Rational.toString(new Parser(s).parse()));
} catch (e) {
    console.log("Error");
}