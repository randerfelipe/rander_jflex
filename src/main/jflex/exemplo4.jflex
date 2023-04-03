enum Classe {
    cInt,               //ok
    cPalRes,
    cIdent,             //ok                    
    cParEsq,            //ok
    cParDir,            //ok
    cAdicao,            //ok
    cSubtracao,         //ok
    cMultiplicacao,     //ok
    cDivisao,           //ok
    cAtribuicao,        //ok
    cPonto,             //ok
    cVirgula,           //ok
    cPontoVirgula,      //ok
    cDoisPontos,        //ok
    cMaior,             //ok
    cMenor,             //ok
    cMaiorIgual,        //ok
    cMenorIgual,        //ok
    cDiferente,         //ok
    cIgual,             //ok
    cReal,
    cString,            //ok
    cEOF                //ok
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
class Valor {

    private enum TipoValor {
        INTEIRO, DECIMAL, IDENTIFICADOR
    }

    private int valorInteiro;
    private double valorDecimal;
    private String valorIdentificador;
    private TipoValor tipo;

    public Valor() {
    }

    public Valor(int valorInteiro) {
        this.valorInteiro = valorInteiro;
        tipo = TipoValor.INTEIRO;
    }

    public Valor(String valorIdentificador) {
        this.valorIdentificador = valorIdentificador;
        tipo = TipoValor.IDENTIFICADOR;
    }

    public int getValorInteiro() {
        return valorInteiro;
    }

    public void setValorInteiro(int valorInteiro) {
        this.valorInteiro = valorInteiro;
        tipo = TipoValor.INTEIRO;
    }

    public double getValorDecimal() {
        return valorDecimal;
    }

    public void setValorDecimal(double valorDecimal) {
        this.valorDecimal = valorDecimal;
        tipo = TipoValor.DECIMAL;
    }

    public String getValorIdentificador() {
        return valorIdentificador;
    }

    public void setValorIdentificador(String valorIdentificador) {
        this.valorIdentificador = valorIdentificador;
        tipo = TipoValor.IDENTIFICADOR;
    }

    @Override
    public String toString() {
        if (tipo == TipoValor.INTEIRO) {
            return "ValorInteiro: " + valorInteiro;
        } else if (tipo == TipoValor.DECIMAL) {
            return "ValorDecimal: " + valorDecimal;
        } else {
            return "ValorIdentificador: " + valorIdentificador;
        }
    }

}

class Token {

    private Classe classe;
    private Valor valor;
    private int linha;
    private int coluna;

    public Token(int linha, int coluna, Classe classe) {
        this.linha = linha;
        this.coluna = coluna;
        this.classe = classe;
    }

    public Token(int linha, int coluna, Classe classe, Valor valor) {
        this.classe = classe;
        this.valor = valor;
        this.linha = linha;
        this.coluna = coluna;
    }

    public Classe getClasse() {
        return classe;
    }

    public void setClasse(Classe classe) {
        this.classe = classe;
    }

    public Valor getValor() {
        return valor;
    }

    public void setValor(Valor valor) {
        this.valor = valor;
    }

    public int getLinha() {
        return linha;
    }

    public void setLinha(int linha) {
        this.linha = linha;
    }

    public int getColuna() {
        return coluna;
    }

    public void setColuna(int coluna) {
        this.coluna = coluna;
    }

    @Override
    public String toString() {
        return "Token [classe: " + classe + ", " + valor + ", linha: " + linha + ", coluna: " + coluna + "]";
    }

}

%%

// %standalone
%class Lexico
// %function getToken
%type Token
%unicode
%line
%column
// %cup

DIGITO = [0-9]
LETRA = [A-Za-z]
INTEIRO = 0 | [1-9] {DIGITO}*
IDENTIFICADOR = {LETRA} ({LETRA} | {DIGITO})*

FIMLINHA = \r|\n|\r\n
ESPACO = {FIMLINHA} | [ \t\f]

%{
public static void main(String[] argv) {
    if (argv.length == 0) {
      System.out.println("Usage : java Lexico [ --encoding <name> ] <inputfile(s)>");
    }
    else {
      int firstFilePos = 0;
      String encodingName = "UTF-8";
      if (argv[0].equals("--encoding")) {
        firstFilePos = 2;
        encodingName = argv[1];
        try {
          // Side-effect: is encodingName valid?
          java.nio.charset.Charset.forName(encodingName);
        } catch (Exception e) {
          System.out.println("Invalid encoding '" + encodingName + "'");
          return;
        }
      }
      for (int i = firstFilePos; i < argv.length; i++) {
        Lexico scanner = null;
        java.io.FileInputStream stream = null;
        java.io.Reader reader = null;
        try {
          stream = new java.io.FileInputStream(argv[i]);
          reader = new java.io.InputStreamReader(stream, encodingName);
          scanner = new Lexico(reader);
          while ( !scanner.zzAtEOF ) {
            System.out.println(scanner.yylex());
          }
        }
        catch (java.io.FileNotFoundException e) {
          System.out.println("File not found : \""+argv[i]+"\"");
        }
        catch (java.io.IOException e) {
          System.out.println("IO error scanning file \""+argv[i]+"\"");
          System.out.println(e);
        }
        catch (Exception e) {
          System.out.println("Unexpected exception:");
          e.printStackTrace();
        }
        finally {
          if (reader != null) {
            try {
              reader.close();
            }
            catch (java.io.IOException e) {
              System.out.println("IO error closing file \""+argv[i]+"\"");
              System.out.println(e);
            }
          }
          if (stream != null) {
            try {
              stream.close();
            }
            catch (java.io.IOException e) {
              System.out.println("IO error closing file \""+argv[i]+"\"");
              System.out.println(e);
            }
          }
        }
      }
    }
  }
%}

%%

{INTEIRO}       { return new Token(yyline + 1, yycolumn + 1, Classe.cInt, new Valor(yytext())); }
{IDENTIFICADOR} { return new Token(yyline + 1, yycolumn + 1, Classe.cIdent, new Valor(yytext())); }
{ESPACO}        { /* ignorar */ }

//Comentarios 

COMENTARIO = "{" [^}] ~"}"

%%

{COMENTARIO}    { /* ignorar */ }
