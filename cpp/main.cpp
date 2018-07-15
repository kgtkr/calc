#include <iostream>
#include <cstdlib>
#include <string>

int gcd(int a, int b)
{
	if (b == 0)
	{
		return a;
	}
	else
	{
		return gcd(b, a % b);
	}
}

struct ParseError
{
};

struct Rational
{
	int n;
	int d;
	bool is_nan;

	Rational(int n, int d)
	{
		if (d == 0)
		{
			this->is_nan = true;
		}
		else
		{
			auto g = gcd(std::abs(n), std::abs(d));
			g = d < 0 ? -g : g;
			this->n = n / g;
			this->d = d / g;
			this->is_nan = false;
		}
	}

	Rational(int n) : Rational(n, 1)
	{
	}

	explicit operator std::string() const noexcept
	{
		if (this->is_nan)
		{
			return "NaN";
		}
		if (this->d == 1)
		{
			return std::to_string(this->n);
		}
		return std::to_string(this->n) + "/" + std::to_string(this->d);
	}
};

Rational RNaN = Rational(0, 0);

Rational operator+(const Rational &a, const Rational &b)
{
	if (a.is_nan || b.is_nan)
	{
		return RNaN;
	}
	return Rational(a.n * b.d + b.n * a.d, a.d * b.d);
}

Rational operator-(const Rational &a, const Rational &b)
{
	if (a.is_nan || b.is_nan)
	{
		return RNaN;
	}
	return Rational(a.n * b.d - b.n * a.d, a.d * b.d);
}

Rational operator*(const Rational &a, const Rational &b)
{
	if (a.is_nan || b.is_nan)
	{
		return RNaN;
	}
	return Rational(a.n * b.n, a.d * b.d);
}

Rational operator/(const Rational &a, const Rational &b)
{
	if (a.is_nan || b.is_nan)
	{
		return RNaN;
	}
	return Rational(a.n * b.d, a.d * b.n);
}

bool is_digit(char c)
{
	return '0' <= c && c <= '9';
}

struct Parser
{
	int pos = 0;
	std::string s;
	Parser(std::string s)
	{
		this->s = s;
	}

	char peek()
	{
		if (this->pos >= this->s.length())
		{
			throw ParseError();
		}
		return this->s[this->pos];
	}

	char next()
	{
		auto v = this->peek();
		this->pos++;
		return v;
	}

	template <class T>
	char expect(T f)
	{
		auto v = this->peek();
		if (f(v))
		{
			this->next();
			return v;
		}
		else
		{
			throw ParseError();
		}
	}

	char expect_char(char c)
	{
		return this->expect([c](char x) { return x == c; });
	}

	Rational number()
	{
		int g;
		std::string s = "";
		try
		{
			this->expect_char('-');
			g = -1;
		}
		catch (ParseError e)
		{
			g = 1;
		}

		while (true)
		{
			try
			{
				s += this->expect(is_digit);
			}
			catch (ParseError e)
			{
				if (s.length() == 0)
				{
					throw ParseError();
				}
				else
				{
					break;
				}
			}
		}

		if (s.length() != 1 && s[0] == '0')
		{
			throw ParseError();
		}

		int v;
		try
		{
			v = std::stoi(s) * g;
		}
		catch (std::invalid_argument e)
		{
			throw ParseError();
		}
		catch (std::out_of_range e)
		{
			throw ParseError();
		}

		return Rational(v);
	}

	void eof()
	{
		if (this->s.length() != this->pos)
		{
			throw ParseError();
		}
	}

	Rational factor()
	{
		try
		{
			this->expect_char('(');
		}
		catch (ParseError e)
		{
			return this->number();
		}

		auto v = this->expr();
		this->expect_char(')');
		return v;
	}

	Rational term()
	{
		auto x = this->factor();
		while (true)
		{
			char op;
			try
			{
				op = this->expect([](char x) { return x == '*' || x == '/'; });
			}
			catch (ParseError e)
			{
				break;
			}

			switch (op)
			{
			case '*':
				x = x * this->factor();
				break;
			case '/':
				x = x / this->factor();
				break;
			}
		}
		return x;
	}

	Rational expr()
	{
		auto x = this->term();
		while (true)
		{
			char op;
			try
			{
				op = this->expect([](char x) { return x == '+' || x == '-'; });
			}
			catch (ParseError e)
			{
				break;
			}

			switch (op)
			{
			case '+':
				x = x + this->term();
				break;
			case '-':
				x = x - this->term();
				break;
			}
		}
		return x;
	}

	Rational parse()
	{
		auto v = this->expr();
		this->eof();
		return v;
	}
};

int main(int argc, char *argv[])
{
	if (argc < 2)
	{
		std::cout << "Error" << std::endl;
	}
	else
	{
		try
		{
			std::cout << (std::string)(Parser(argv[1]).parse()) << std::endl;
		}
		catch (ParseError e)
		{
			std::cout << "Error" << std::endl;
		}
	}
}