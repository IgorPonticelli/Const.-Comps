import java.io.InputStreamReader;

%%

%public
%class lexeme
%unicode
%line
%integer

%{

public static int STRING = 257;
public static int NUMBER = 258;

public static int LBRACE = 259;   // {
public static int RBRACE = 260;   // }
public static int LBRACKET = 261; // [
public static int RBRACKET = 262; // ]
public static int COLON = 263;    // :
public static int COMMA = 264;    // ,

public static void main(String argv[]) {
    lexeme scanner;

    if (argv.length == 0) {
        scanner = new lexeme(new InputStreamReader(System.in));
    } else {
        try {
            scanner = new lexeme(new java.io.FileReader(argv[0]));
        } catch (Exception e) {
            System.out.println("Erro ao abrir arquivo");
            return;
        }
    }

    try {
        int token;
        while((token = scanner.yylex()) != YYEOF) {
            System.out.println(
                "linha: " + (scanner.yyline+1) +
                " token: " + token +
                " lexema: <" + scanner.yytext() + ">"
            );
        }
    } catch(Exception e){
        e.printStackTrace();
    }
}

%}

DIGIT=[0-9]
INT={DIGIT}+
FLOAT={DIGIT}+ "." {DIGIT}+
NUMBER={FLOAT}|{INT}

STRING=\"([^\"\\]|\\.)*\"

WHITESPACE=[ \t\r\n]+

%%

"{"        { return LBRACE; }
"}"        { return RBRACE; }
"["        { return LBRACKET; }
"]"        { return RBRACKET; }

":"        { return COLON; }
","        { return COMMA; }

{STRING}   { return STRING; }

{NUMBER}   { return NUMBER; }

{WHITESPACE}   { }

. {
    System.out.println("Linha "+(yyline+1)+": caractere inválido: "+yytext());
}