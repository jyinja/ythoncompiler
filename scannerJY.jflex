//scanner jflex jason yin, compile with jflex jar file and javac, disregard warnings, to run type in: 'java scannerJY input_filename'
//Comments can be found throughout the file, comments include print statements that I commented out (but you could uncomment to see buncha output if you want) or descriptions of
//what my code functionality does
//~~-->Done
//TODO: ~~Illegal array usage~~, ~~Wrong return type~~, ~~illegal number of parameters~~, ~~type mismatch in assignment statement~~, ~~illegal function usage~~, ~~illegal parameter type~~, ~~If statement requires boolean~~*
import java.io.*;
import java.util.*;
%%
%class scannerJY
%unicode
%line
%column
%byaccj
%{
//Variables to store info about scope and symbols, the arraylists are basically used sort of like a stack and boolean/ints are flagged when in certain scopes
static boolean arrayAccess = false;//tells if trying to access index of array
static int ParamCounter = 0;
static String funcHeaderInQuestion="";
static ArrayList<String> arrayElementValues = new ArrayList<>();
static int linecount = 0;
static int BOL = 1; //beginning of line condition
static scannerJY lexer=null;
private Parser yyparser; //reference to the parser object
static String lastToken =""; //keep track of important previous tokens if needed
static String lastString = "";
static String prevLis="";
static ArrayList<String> functions = new ArrayList<>();//store function Identifers here
static ArrayList<String> ids = new ArrayList<>(); //store identifiers
///static ArrayList<Object> vals = new ArrayList<>(); //store corresponding values of identifiers (Part2)(IDs that are not function IDs or class name)
static ArrayList<String> vals = new ArrayList<>();
static ArrayList<String> types = new ArrayList<>(); //store corresponding types of identifiers (part 3)
static ArrayList<String> ptypes = new ArrayList<>(); // param type storage
static ArrayList<String> classes = new ArrayList<>();//store classes, Main will always be in here
static ArrayList<String> params = new ArrayList<>(); // store parameters of functions, which is stuff inside parenthesis
static ArrayList<String> arrayElements = new ArrayList<>(); //store array elements that the mython program is trying to access
static ArrayList<ArrayList<Object>> symbolIDtable = new ArrayList<>();
static ArrayList<String> scopes = new ArrayList<>();
static String parenORbrack = ""; //for adding to vals
static String existingType = "";//for error checking mismatch assignment
static int inParenthesis = 0;
static int inBrackets = 0;
static Hashtable ST = new Hashtable();//Maybe?
static int declarate = 0;//in assign
static int defline = 0;

static int inWhile = 0;
static int inIf = 0;
static int inElse = 0;
static int inFunction = 0;// inside of a def:
static int inPrint = 0;
static int inReturn = 0;//inPrint and inReturn will be about the same, to make sure that what follows them are integers
static int boolexp = 0;
static int inParameterParenthesis = 0;

//static ST st = new ST();
public scannerJY(java.io.Reader r, Parser yyparser){
    this(r);
    this.yyparser = yyparser;
}
//return current line number
public int getLine(){
    return yyline;
}
/*
public int getLineCount(){
    return linecount;
}*/
%}
///%type Integer//changes yylex return type
//lex stuff below
LineTerminator = \r|\n|\r\n
WhiteSpace = [ \t\f]
InputCharacter = [^\r\n]
///Comment = "//" {InputCharacter}* {LineTerminator}?
Comment = "//" {InputCharacter}*
keywords ="and"|"class"|"def"|"else"|"end"|"false"|"if"|"input"|"Main"|"not"|"or"|"print"|"return"|"true"|"while"
opsdelims="+"|"-"|"*"|"!"|"=="|"<>"|"<"|"<="|">"|">="|"["|"]"|","|"("|")"|":"|"="|"."
intLiterals = 0|[1-9][0-9]*
identifiers = [a-z][a-zA-Z0-9_]*
classIdentifiers = [A-Z][a-zA-Z0-9_]*
EOF=[$]
%%
{keywords}    { /*System.out.println("keyword: "+yytext());*/ //NOTE:these initial print statements are commented out but can be uncommented to see tokens
if(yytext().equals("Main")){
    classes.add(yytext());
    lastToken = "Main";
    return Parser.MAIN_T;
}
else if(yytext().equals("class")){
    lastToken = "class";
    BOL=0;
    return Parser.CLASS_T;
}
else if(yytext().equals("and")){
    if(lastToken.equals("intLiterals")){
        yyparser.yyerror("Illegal types in expression and expects boolean");
    }
    else if(declarate==1 && boolexp==0){
        //and is part of an assignment meaning the overall value type is boolean
        vals.add("boolean");//to process ands,ors,nots?
        types.add("boolean");
        boolexp=1;
    }
    lastToken = "and";
    return Parser.AND;
}
else if(yytext().equals("def")){
    defline = 1;
    inFunction = 1;
    lastToken = "def";
    BOL=0;//set beginning of line variable to zero because no longer at the start of the line
    return Parser.DEF_T;
}
else if(yytext().equals("else")){
    inElse = inElse+1;
    lastToken="else";
    BOL=0;
    yyparser.yylval=new ParserVal(yytext()); //send to yacc added 4/8
    return Parser.ELSE_T;
}
else if (yytext().equals("end")){

    if(inWhile>0){
        inWhile --;
    }
    else if (/*inIf==1*/inIf>0 && inElse >0){
        //inIf = 0;
        inIf--;
        inElse --;
    }
    else if(inElse==0 && inIf>0){
        //inIf = 0;
        inIf--;
    }
    else if(inFunction==1){
        inFunction = 0;
        //print statements can be uncommented for more output
        ///System.out.println("Function: "+functions);
        ///System.out.println("Parameters: "+params);
        ///System.out.println("Parameter types: "+ptypes);
        ///System.out.println("IDs: "+ids);
        ///System.out.println("ID Values: "+vals);
        ///System.out.println("ID Types: "+types);
        StringBuilder ss = new StringBuilder();
        if(functions.size()>0){


            ss.append(functions.get(functions.size()-1)+"\n");//function scopes are encoded in 6 lines, order: func_name,params, ptypes,ids,vals,types
            for(String s : params){
                ss.append(s);
                ss.append(" ");
            }
            ss.append("\n");
            for(String s: ptypes){
                ss.append(s);
                ss.append(" ");
            }

            ss.append("\n");//separate by new line
        }
        for(String s:ids){
            ss.append(s);
            ss.append(" ");
        }
        ss.append("\n");
        for(String s:vals){
            ss.append(s);
            ss.append(" ");
        }
        ss.append("\n");
        for(String s:types){
            ss.append(s);
            ss.append(" ");
        }
        ///System.out.println(ss.toString());
        scopes.add(ss.toString());
        params.clear();//acts like pop
        ids.clear();
        types.clear();
        vals.clear();
        ptypes.clear();
    }
    else{
        //if not in a loop or conditional, or function (so essentially in main), print statements can be uncommmented/commented out to visualize
        ///System.out.println("main program...");
        ///System.out.println("Function: "+functions);
        ///System.out.println("Parameters: "+params); //when the parameters print out is blank then the program is printing info for the main
        ///System.out.println("Parameter types: "+ptypes);
        ///System.out.println("IDs: "+ids);
        ///System.out.println("ID Values: "+vals);
        ///System.out.println("ID Types: "+types);
        StringBuilder ss = new StringBuilder();
        /*
        if(functions.size()>0){


            ss.append(functions.get(functions.size()-1)+"\n");
            for(String s : params){
                ss.append(s);
                ss.append(" ");
            }
            ss.append("\n");
            for(String s: ptypes){
                ss.append(s);
                ss.append(" ");
            }

            ss.append("\n");//separate by new line
        }*/
        ss.append("Main\n");//encoded in 4 lines in scopes list, order:Main,ids,vals,types
        for(String s:ids){
            ss.append(s);
            ss.append(" ");
        }
        ss.append("\n");
        for(String s:vals){
            ss.append(s);
            ss.append(" ");
        }
        ss.append("\n");
        for(String s:types){
            ss.append(s);
            ss.append(" ");
        }
        ///System.out.println(ss.toString());
        scopes.add(ss.toString());
        ///System.out.println("Array elements to be accessed: "+arrayElements);
        ///System.out.println("Scopes from scanner: "+scopes);

        int ind = 0;
        for(int i = 0;i<ids.size();i++){
            for(int j = 0;j<arrayElements.size();j++){
                    if(ids.get(i).equals(arrayElements.get(j).substring(0,1)) && types.get(ids.indexOf(arrayElements.get(j).substring(0,1))).equals("array")){
                        ind = i;//find index corresponding to the array
                        int inum = Integer.parseInt(arrayElements.get(j).substring(2,3));//get the index number
                        arrayElementValues.add(vals.get(ind).substring(inum*2+1,inum*2+1+1) );//get value from ORIGINAL array
                }
            }
        }
        //System.out.println("Array elements to be accessed: "+arrayElements);//if there is an array in the program then print out array elements that are attempted to be accessed in the program and then print corresponding values to those array access variables.
        ///System.out.println("Corresponding Array element values: "+arrayElementValues);//you can read the corresponding values to variables by matching index by index, so index zero in arrayElements corresponds to value in index zero of arrayElementValues
        //this is like popping off a stack, the information is saved to scopes arraylist to keep track of scopes but is cleared for the next scope to be read
        params.clear();
        ids.clear();
        types.clear();
        vals.clear();
        ptypes.clear();
    }
    //params.clear();
    lastToken = "end";
    return Parser.END_T;
}
else if(yytext().equals("false")){
    //if(lastToken == "+"||lastToken=="-"||lastToken=="*"){
    if(lastToken.equals("+")||lastToken.equals("-") ||lastToken.equals("*") || lastToken.equals("<") || lastToken.equals("<=") || lastToken.equals(">") || lastToken.equals(">=")){
        //if boolean appears in arithmetic case
        yyparser.yyerror("Illegal types in expression operator "+lastToken+" expects integers");
    }
    else if(lastToken.equals("=")){
        if(existingType.equals("boolean")){
            vals.set(ids.indexOf(lastString),yytext());//update the value at the proper index
        }
        else if(!existingType.equals("boolean") && !existingType.equals("")){
            //existing type does not match the previously initialized type and is not just an empty string then mismatch error
            yyparser.yyerror("Type mismatch in assignment statement");
        }
        else{
            vals.add("false");
            types.add("boolean");
            boolexp=1;//seen a boolean expression
        }
        //vals.add("false");
        //types.add("boolean");
        //boolexp=1;
    }
    lastToken = "false";
    return Parser.FALSE_T;
}
else if(yytext().equals("if")){
    inIf = inIf+1;
    lastToken = "if";
    BOL=0;
    return Parser.IF_T;
}
else if(yytext().equals("input")){
    if(lastToken.equals("=")){
        vals.add(yytext());
        //types.add("string");
        types.add("integer");
    }
    lastToken="input";
    return Parser.INPUT_T;
}
else if(yytext().equals("not")){
    if(lastToken.equals("=")){
        vals.add("boolean");//to process nots?
        types.add("boolean");
        boolexp=1;
    }
    lastToken = "not";
    BOL=0;
    return Parser.NOT;
}
else if(yytext().equals("or")){
    if(lastToken.equals("intLiterals")){ //if last element was integer then error
        yyparser.yyerror("Illegal types in expression or expects boolean");
    }
    else if(declarate==1 && boolexp==0){
        //or is part of an assignment meaning the overall value type is boolean
        vals.add("boolean");//to process ands,ors,nots?
        types.add("boolean");
        boolexp=1;
    }
    lastToken = "or";
    return Parser.OR;
}
else if(yytext().equals("print")){ //print integer types
    inPrint=1;
    lastToken = "print";
    BOL=0;
    return Parser.PRINT_T;
}
else if(yytext().equals("return")){ //must return integer types
    inReturn=1;
    lastToken = "return";
    BOL=0;
    return Parser.RETURN_T;
}
else if(yytext().equals("true")){
    if(lastToken.equals("+")||lastToken.equals("-") ||lastToken.equals("*") || lastToken.equals("<") || lastToken.equals("<=") || lastToken.equals(">") || lastToken.equals(">=")){
        //if boolean appears in arithmetic case or inequality symbol case
        yyparser.yyerror("Illegal types in expression operator "+lastToken+" expects integers");
    }
    else if(lastToken.equals("=")){
        if(existingType.equals("boolean")){
            vals.set(ids.indexOf(lastString),yytext());//update the value at the proper index
        }
        else if(!existingType.equals("boolean") && !existingType.equals("")){
            //existing type does not match the previously initialized type and is not just an empty string then mismatch error
            yyparser.yyerror("Type mismatch in assignment statement");
        }
        else{
            vals.add("true");
            types.add("boolean");
            boolexp=1;//seen a boolean expression
        }
    }
    lastToken = "true";
    return Parser.TRUE_T;
}
else if(yytext().equals("while")){
    inWhile = inWhile+1;
    lastToken = "while";
    BOL=0;
    return Parser.WHILE_T;
}
yyparser.yylval=new ParserVal(yytext());
}
{identifiers} { /*System.out.println("identifer: "+yytext());*/
/*if(inFunction ==0){
    //in main, not in a function definition
    System.out.println("in main : "+yytext());
    boolean contains = false;
    for(int i = 0;i<functions.size();i++){
        if(functions.get(i).equals(yytext())){
            contains = true;
            break;
        }
    }
    if(contains == false){
        //this is a function call that was not previously defined
        yyparser.yyerror("Function not declared: "+yytext());
    }
    else{

        ids.add(yytext());//add main method variables
    }
}*/
if(lastToken.equals("def")){
    boolean contains = false;
    for(int i =0;i<functions.size();i++){
        if(functions.get(i).equals(yytext())){
            contains = true;
            break;
        }
    }
    if(contains == true){//if the function already exists then we can't def it twice
        yyparser.yyerror("Duplicate function or variable in scope: "+yytext());//duplicate function or variable error call
    }
    else{
        functions.add(yytext());
    }

}
else if(lastToken.equals("return") || inReturn==1){//if identifier is the return value, need to check the type of the identifier to ensure it is integer
    if(!ids.contains(yytext()) && !params.contains(yytext()) && !functions.contains(yytext()) && BOL==0){
        yyparser.yyerror("Undefined var "+yytext()); //if identifier not contained in functions arraylist or IDs and the statement is not supposed to assign anything and no longer at the start of the line then error
    }
    else{
    int index = 0;
    if(ids.size()>0){//check identifier variables
        for(int i = 0;i<ids.size();i++){
            if(ids.get(i).equals(yytext())){
                index = i;
                //break;
                if(!types.get(index).equals("integer")){
                    yyparser.yyerror("Wrong return type for function: must be integer");//check types for integer for returns
                }
            }
        }
        //move the if check not equal to integer type up into the for loop to avoid unnecessary error messages

    }
    else if(params.size()>0){
        for(int i = 0;i<params.size();i++){
            if(params.get(i).equals(yytext())){//parameter type check for integer in returns
                index = i;
                //break;
                if(!ptypes.get(index).equals("integer")){
                    yyparser.yyerror("Wrong return type for function: must be integer");//check types for integer in return lines
                }
            }
        }
        /*moved up
        if(!ptypes.get(index).equals("integer")){
            yyparser.yyerror("Wrong return type for function: must be integer");//check types for integer in return lines
        }*/
    }
    }
}
else if(lastToken.equals("(") && defline ==1){ //if parenthesis as part of a defining function line
    boolean contains = false;
    for(int i =0;i<params.size();i++){
        if(params.get(i).equals(yytext())){
            contains = true;
            break;
        }
    }
    if(contains == true){//if the function already exists then we can't def it twice
        yyparser.yyerror("Duplicate variable in scope: "+yytext());//duplicate parameter variable error call
    }
    else{
        params.add(yytext());
        ptypes.add("integer");//default to be integer until program finds out otherwise (array)
    }
}
else if (lastToken.equals(",") && defline==1){ //parameters following commas
    boolean contains = false;
    for(int i =0;i<params.size();i++){
        if(params.get(i).equals(yytext())){
            contains = true;
            break;
        }
    }
    if(contains == true){//if the function already exists then we can't def it twice
        yyparser.yyerror("Duplicate variable in scope: "+yytext());//duplicate parameter variable error call
    }
    else{
        params.add(yytext());
        ptypes.add("integer");
    }
}
else if((lastToken.equals("(") && /*inIf==1*/inIf>0) || lastToken.equals("if")){//inIf greater than zero means this
    if(inFunction==1){ //if in a def function but also cover the other case
        //check if yytext is a recognized identifier as either a parameter or a defined var
        int index = 0;
        if(ids.size()>0){
            for(int i = 0;i<ids.size();i++){
                if(ids.get(i).equals(yytext())){
                    index = i;
                    //break;
                    if(!types.get(index).equals("boolean")){
                        //try to get this working with yacc to typecheck something like exp == exp, or like exp < exp, but how to give exp more than integer type?
                        ///yyparser.yyerror("If stmt requires boolean condition");//check types for boolean in if conditional statement
                    }
                }
            }
            //moved if !types.get(index).equals (boolean) up ward into the look and took out the break
        }
        if(params.size()>0){//after checking ids check param types
            for(int i = 0;i<params.size();i++){
                if(params.get(i).equals(yytext())){//parameter boolean check case for if statements
                    index = i;
                    //break;
                    if(!ptypes.get(index).equals("boolean")){
                        //uncomment for If error checking,
                        ///yyparser.yyerror("If stmt requires boolean condition");//check types for boolean in if conditional statement
                    }
                }
            }

        }

    }
    else if(inFunction ==0){
        //DO THIS, not in function case for if statements so you do not need to check parameters
    }
}
else if(lastToken.equals("[") && inBrackets==1){
    boolean contains = false;
    for(int i = 0;i<ids.size();i++){
        if(ids.get(i).equals(yytext())){
            if(types.get(i).equals("integer")){
                contains = true;//not only is the identifier defined, but also matches correct type
            }
            else{
                yyparser.yyerror("Illegal types in array access");
            }
        }
    }
    for(int i = 0;i<params.size();i++){
        if(params.get(i).equals(yytext())){
            if(ptypes.get(i).equals("integer")){
                contains = true;//not only is the parameter existing, but also matches correct type
            }
            else{
                yyparser.yyerror("Illegal types in array access");
            }
        }
    }
    if(contains == true){
        parenORbrack+=yytext();//add the array access thing between the square brackets []
    }
}
else if (lastToken.equals("=") && declarate==1){
    //identifier is part of an assignment, if it is function name then the type is integer otherwise check types for respective type
    if(functions.contains(yytext())){//add appropriate type
        types.add("integer");
    }
    else if(ids.contains(yytext())){
        types.add(types.get(ids.indexOf(yytext()) ));
    }
    else if(params.contains(yytext())){
        types.add(ptypes.get(params.indexOf(yytext())));
    }
    else{
        yyparser.yyerror("Undefined var "+yytext());//possible error, if the identifier is not contained in any of the lists
    }
}
//else if (!lastToken.equals("*")&&!lastToken.equals("-")&&!lastToken.equals("+")&&!lastToken.equals("=") && !lastToken.equals("(") && !lastToken.equals(",") && !lastToken.equals("<") && !lastToken.equals("<=") && !lastToken.equals(">") && !lastToken.equals(">=") && !lastToken.equals("==") && !lastToken.equals("<>")){
else if(lastToken.equals("<") || lastToken.equals(">") || lastToken.equals(">=") || lastToken.equals("<=")){
    //inequality ops will require integers to be before and after them, this covers the after case
    if(ids.contains(yytext())){
        //check identifier types for array type or integer type
        if(!types.get(ids.indexOf(yytext())).equals("integer") && !types.get(ids.indexOf(yytext())).equals("array")){
            yyparser.yyerror("Illegal types in expression "+lastToken+" expects integers");
        }
    }
    else if(params.contains(yytext())){//next check parameter types
        if(!ptypes.get(params.indexOf(yytext())).equals("integer") && !ptypes.get(params.indexOf(yytext())).equals("array")){
            yyparser.yyerror("Illegal types in expression "+lastToken+" expects integers");
        }
    }
}
else{
    boolean contains = false;
    boolean containsF= false;
    boolean containsP = false;
    for(int i =0;i<ids.size();i++){//could either identify as identifier or function name or parameter
        if(ids.get(i).equals(yytext())){
            contains = true;
            break;
        }
    }
    if (contains == true && declarate == 1){//something is being assigned to an existing variable
        vals.add(yytext());
    }
    //else if(contains==false )//else check param existence, if identifier is not identified AT ALL, then call yyerror for undefined error
    for(int i =0;i<functions.size();i++){
        if(functions.get(i).equals(yytext())){
            containsF = true;
            break;
        }
    }//check for bad usage of functions with this
    for(int i =0;i<params.size();i++){
        if(params.get(i).equals(yytext())){
            containsP = true;
            break;
        }
    }
    //System.out.println(BOL);
    if (contains==false && containsP==false&&containsF==false && BOL==1){//if identifier has never been defined/declared and this is a assignment and current the beginning of the line then add the identifier to IDs
        //System.out.println(yyparser.yylex());
        ids.add(yytext());//if identifier not already contained then you add into the list of IDs
    }
    else if(contains==false &&containsP==false && containsF==false && BOL==0){
        yyparser.yyerror("Undefined var "+yytext()); //if identifier not contained in functions arraylist or IDs and the statement is not supposed to assign anything and no longer at the start of the line then error
    }


}
lastToken = "identifiers";
lastString = yytext();
BOL=0;
yyparser.yylval=new ParserVal(yytext());
return Parser.ID;}

{classIdentifiers} { /*System.out.println("class identifier: "+yytext());*/
if(lastToken.equals("class")){
    classes.add(yytext());
}
lastToken = "classIdentifiers";
lastString = yytext();
yyparser.yylval=new ParserVal(yytext());
return Parser.CLASS_ID;}

{intLiterals} { /*System.out.println("integer literal: "+yytext());*/
if(lastToken.equals("=")){
    if(existingType.equals("integer")){
        //types.add("integer");
        //vals.add(yytext());
        vals.set(ids.indexOf(lastString),yytext());//update the value at the proper index
    }
    else if(!existingType.equals("integer") && !existingType.equals("")){
        //existing type does not match the previously initialized type and is not just an empty string then mismatch error
        yyparser.yyerror("Type mismatch in assignment statement");
    }
    else{
        //if the last identifier not already existing then we add
        types.add("integer");
        vals.add(yytext());
    }
}
else if(inBrackets==1 && declarate ==1){
    parenORbrack+=yytext();//if in bracket add to the special string variable because this is also a declaration/assignment line for a list
    //vals.get(vals.size()).add((Object)yytext());
}
else if(arrayAccess == true ){
    parenORbrack+=yytext();//add the index of the access, an array access line
}
else if(lastToken.equals("and") || lastToken.equals("or")){
    //you parse an integer literal and the last token is and / or
    yyparser.yyerror("Illegal types in expression "+lastToken+" expects boolean");
}
lastToken = "intLiterals";
lastString = yytext();
yyparser.yylval=new ParserVal(Integer.parseInt(yytext())); //send to yacc
return Parser.INT_LIT;}

{opsdelims}   { /*System.out.println("operator & delimiter: "+yytext());*/
if(yytext().equals("+")){
    if(lastToken.equals("true") || lastToken.equals("false")){
        yyparser.yyerror("Illegal types in expression operator + expects integers");//only check for boolean case because that would result in error. intliterals or array accesses would be ok
    }
    lastToken = "+";
    parenORbrack="";//reset special string storage variable
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.PLUS;
}
else if(yytext().equals("-")){
    if(lastToken.equals("true") || lastToken.equals("false")){
        yyparser.yyerror("Illegal types in expression operator - expects integers");
    }
    lastToken = "-";
    parenORbrack="";//reset special string storage variable
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.MINUS;
}
else if(yytext().equals("*")){
    if(lastToken.equals("true") || lastToken.equals("false")){
        yyparser.yyerror("Illegal types in expression operator * expects integers");
    }
    lastToken="*";
    parenORbrack="";//reset special string storage variable
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.MULT;
}
else if(yytext().equals("!")){ //NOT, may be a mistake from the specification (accidentally left in), could ignore this.
    lastToken = "!";
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.NOT;
}
else if(yytext().equals("==")){
    if(inReturn==1 || inPrint==1){
        //in a line with a print or a return and a boolean operator is seen, does not matter if surrounded in parenthesis or not
        yyparser.yyerror("Wrong return type for function: must be integer");
    }
    lastToken = "==";
    parenORbrack="";//reset special string storage variable
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.EQ;
}
else if(yytext().equals("<>")){
    if(inReturn==1 || inPrint==1){
        //in a line with a print or a return and a boolean operator is seen, does not matter if surrounded in parenthesis or not
        yyparser.yyerror("Wrong return type for function: must be integer");
    }
    lastToken = "<>";
    parenORbrack="";//reset special string storage variable
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.NE;
}
else if(yytext().equals("<")){
    //less than, less than or equal, greater than, and greater than or equal can only be applied to numbers !!
    if(!lastToken.equals("intLiterals") && !lastToken.equals("identifiers") && !lastToken.equals("]")){
        //last token was not int literal or not an identifier so this is an error
        yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");
    }
    //now check the identifier for proper integer type
    if(lastToken.equals("identifiers")){
        if(ids.contains(yytext())){
            if(!types.get(ids.indexOf(yytext())).equals("integer")){
                yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");//no integer type identifier
            }
        }
        else if(params.contains(yytext())){
            if(ptypes.get(params.indexOf(yytext())).equals("integer")){
                yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");
            }
        }
    }

    lastToken = "<";
    parenORbrack="";//reset special string storage variable
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.LT;
}
else if(yytext().equals("<=")){
    if(!lastToken.equals("intLiterals") && !lastToken.equals("identifiers") && !lastToken.equals("]")){
        //last token was not int literal or not an identifier so this is an error
        yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");
    }
    //now check the identifier for proper integer type
    if(lastToken.equals("identifiers")){
        if(ids.contains(yytext())){
            if(!types.get(ids.indexOf(yytext())).equals("integer")){
                yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");//no integer type identifier
            }
        }
        else if(params.contains(yytext())){
            if(ptypes.get(params.indexOf(yytext())).equals("integer")){
                yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");
            }
        }
    }
    lastToken = "<=";
    parenORbrack="";//reset special string storage variable
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.LE;
}
else if(yytext().equals(">")){
    if(!lastToken.equals("intLiterals") && !lastToken.equals("identifiers") && !lastToken.equals("]")){
        //last token was not int literal or not an identifier so this is an error
        yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");
    }
    //now check the identifier for proper integer type
    if(lastToken.equals("identifiers")){
        if(ids.contains(yytext())){
            if(!types.get(ids.indexOf(yytext())).equals("integer")){
                yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");//no integer type identifier
            }
        }
        else if(params.contains(yytext())){
            if(ptypes.get(params.indexOf(yytext())).equals("integer")){
                yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");
            }
        }
    }
    lastToken = ">";
    parenORbrack="";//reset special string storage variable
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.GT;
}
else if(yytext().equals(">=")){
    if(!lastToken.equals("intLiterals") && !lastToken.equals("identifiers") && !lastToken.equals("]")){
        //last token was not int literal or not an identifier so this is an error
        yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");
    }
    //now check the identifier for proper integer type
    if(lastToken.equals("identifiers")){
        if(ids.contains(yytext())){
            if(!types.get(ids.indexOf(yytext())).equals("integer")){
                yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");//no integer type identifier
            }
        }
        else if(params.contains(yytext())){
            if(ptypes.get(params.indexOf(yytext())).equals("integer")){
                yyparser.yyerror("Illegal types in expression operator "+yytext()+" expects integers");
            }
        }
    }
    lastToken = ">=";
    parenORbrack="";//reset special string storage variable
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.GE;
}
else if(yytext().equals("[")){
    inBrackets=1;//start the bracket condition
    if(lastToken.equals("=")){
        if(existingType.equals("array")){
            //vals.set(ids.indexOf(lastString),yytext());//update the value at the proper index
            parenORbrack+=yytext();
            prevLis=lastString;
        }
        else if(!existingType.equals("array") && !existingType.equals("")){
            //existing type does not match the previously initialized type and is not just an empty string then mismatch error
            yyparser.yyerror("Type mismatch in assignment statement");
        }
        else{
            types.add("array");//not already existing identifier of array so you add and creation of a new item to the list
            parenORbrack+=yytext();//add the single left bracket

        }
        ///types.add("array");
        ///parenORbrack+=yytext();//add the single left bracket
        //vals.add(new ArrayList());
    }

    else if (!lastToken.equals("=")){
        //last token is not assignment so it would be an ID
        ///parenORbrack+=lastToken;
        parenORbrack+=lastString;
        parenORbrack+=yytext();
        arrayAccess=true;
        if(inParenthesis==0){//in the case in which the array access is not within scope of parenthesis (meaning not in function header)
            boolean IdIsArrayType = false;
            for(int i = 0;i<ids.size();i++){
                if(ids.get(i).equals(lastString)){
                    if(types.get(i).equals("array")){
                        IdIsArrayType = true;
                        break;//check identifier type for array type, the next case will check for parameter type if the identifier is a parameter
                    }
                }
            }
            for(int i = 0;i<params.size();i++){
                if(params.get(i).equals(lastString)){
                    if(ptypes.get(i).equals("array")){
                        IdIsArrayType = true;
                        break;//check identifier type for array type, the next case will check for parameter type if the identifier is a parameter
                    }
                }
            }
            if(IdIsArrayType==false){
                //verified that the array access is not actually an array type
                yyparser.yyerror("Illegal array usage: "+lastString);
            }
            else{
                ///types.add("integer");//list[index] will have integer type
            }
        }
        else if(inParenthesis ==1){
            //types.add("array");//parameters will either be integer type or array type
            ptypes.remove(ptypes.size()-1);
            ptypes.add("array");
        }

    }
    lastToken = "[";
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.LB;
}
else if(yytext().equals("]")){//only 1D integer arrays
    inBrackets = 0; //end the bracket condition
    parenORbrack+=yytext();
    if(declarate == 1){
        //if the current line is an assignment
        ///parenORbrack+=yytext();//add closing bracket
        if(existingType.equals("array")){
            vals.set(ids.indexOf(prevLis),parenORbrack);
        }
        else{
            vals.add(parenORbrack);
        }

    }

    else if(parenORbrack.length()==4){//a variable with specified list index will always be length 4 and no list declaration can be length 4
        boolean contains = false;
        for(int i =0;i<arrayElements.size();i++){
            if(arrayElements.get(i).equals(parenORbrack)){
                contains = true;
                break;
            }
        }
        if (contains==false){
            arrayElements.add(parenORbrack);//if identifier not already contained then you add into the list of IDs
            //vals.add(); //FIX, so if you add something like x[0] get the zeroth index of x list
        }
        //ids.add(parenORbrack);
    }
    else if(parenORbrack.substring(parenORbrack.length()-2,parenORbrack.length()).equals("[]") && inParenthesis==0){
        //signifies empty array, but not inside of a function parameter scope so this is error
        ///yyparser.yyerror("Illegal array usage: "+parenORbrack.charAt(0));
    }
    /*
    else{
        vals.add(parenORbrack);
    }
    */
    ///parenORbrack = "";//reset variable
    lastToken = "]";
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.RB;
}
else if(yytext().equals(",")){
    if(inBrackets==1){
        parenORbrack += yytext(); //add comma
    }
    else if(inParenthesis ==1 && inFunction == 0){
        //this is the case if it is in scope of parenthesis for a function call in Main so the number of parameters can be determined by the number of commas used so for example if one comma is detected then were has to be two parameters
        ParamCounter++;
    }
    lastToken = ",";
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.COMMA;
}
else if(yytext().equals("(")){
    inParenthesis = 1; //set the condition that program is currently within scope
    if(inFunction == 0 && /*inPrint==0 /*added 3/15 && inReturn==0 &&*/ lastToken.equals("identifiers")){
        //not in function definition meaning in the main class
        boolean contains = false;
        for(int i =0;i<functions.size();i++){
            if(functions.get(i).equals(lastString)){
                contains = true;
                break;
            }
        }
        if(contains == false){
            yyparser.yyerror("Function not declared: "+lastString);
        }
        else if(contains == true ){
            //start a parameter counting variable that will ensure the parameter count is the same as the size of the params list
            ParamCounter = 0;//start at zero
            funcHeaderInQuestion=lastString;//this will be the function in question that we want to parameter check for
        }
    }
    else if(inPrint==1){
        funcHeaderInQuestion="";//this is a built in function
    }
    lastToken = "(";
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.LP;
}
else if(yytext().equals(")")){
    inParenthesis = 0;//exit the parenthesis condition
    if(defline==1 && lastToken.equals("(")){
        params.add("00");//zero zero representing last function does not have parameters
    }
    else if(inFunction==0 && functions.contains(funcHeaderInQuestion)){//in Main
        //System.out.println("IN MAIN");
        /*
        if(params.get(0).equals("00")){
            if(ParamCounter != 0){
                //so this case is in Main, the params arraylist states there are no parameters and the parameter counter should be zero
                //if not equal to zero then this is a parameter length error
                yyparser.yyerror("Illegal number of parameters for function "+)
            }
        }*/
        for(int i =0;i<scopes.size();i++){
            String[] temp = scopes.get(i).split("\n"); //take each miniparagraph and split it
            //for(int j = 0;j<temp.length;j++){
            if(temp[0].equals(funcHeaderInQuestion)){
                //function name matches what is found, then check parameter count
                String[] temp2 = temp[1].split(" ");//split by space so the length of this array will be the number of parameters associated with the corresponding function
                if(temp2[0].equals("00") ){
                    if(ParamCounter!=0 || !lastToken.equals("(") ){
                        //if last token was not open parenthesis then that means there was just one thing in the parenthesis when not supposed to actually have anything in there
                        //check yacc
                        ///yyparser.yyerror("Illegal number of parameters for function "+funcHeaderInQuestion); //no parameters should have zero in the counter
                    }
                }
                else if( (ParamCounter+1) != temp2.length){
                    ///yyparser.yyerror("Illegal number of parameters for function "+funcHeaderInQuestion);
                }
            }
            //}
        }
    }
    ParamCounter = 0;//reset counter
    lastToken = ")";
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.RP;
}
else if(yytext().equals(":")){
    lastToken = ":";
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.COLON;
}
else if(yytext().equals("=")){
    declarate = 1;
    if(parenORbrack.length()==4){
        //this assignment is assigning an array, so first search through ids to find the index of the array in the arraylist, then the corresponding index will match with the value in vals
        int ind = 0;
        for(int i = 0;i<ids.size();i++){
            if(ids.get(i).equals(parenORbrack.substring(0,1))){
                ind = i;//find index corresponding to the array
            }
        }
        ids.add(parenORbrack);//adds array access identifier such as x[0], this will correspond to the value on the right side of the upcoming assignment
        ///int inum = Integer.parseInt(parenORbrack.substring(2,3));//get the index number
        ///System.out.println(vals.get(ind).substring(inum*2+1,inum*2+1+1) );//get value from ORIGINAL array
    }
    else if(ids.contains(lastString)){
        //the Identifier being assigned already exists so check the corresponding type first
        try{//try to access a type with the matching index of the last identifier but if it have index out of bounds error then we know it is a new Identifier
            existingType = types.get(ids.indexOf(lastString));
        }
        catch(Exception e){
            existingType="";
        }
    }
    lastToken = "=";
    parenORbrack="";//reset special string storage variable
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.ASSIGN;
}
else if(yytext().equals(".")){
    lastToken = ".";
    yyparser.yylval=new ParserVal(yytext()); //send to yacc
    return Parser.DOT;
}
//yyparser.yylval=new ParserVal(yytext()); //send to yacc
}

{Comment}    {/*ignore*/}
{WhiteSpace} {/*ignore*/}
{LineTerminator}  { /*System.out.println("lineterminator...");*/ linecount++;declarate = 0;defline=0;BOL = 1;inPrint=0;arrayAccess = false;parenORbrack="";inReturn=0;boolexp=0;existingType="";}
///[\n] {System.out.println("lineterminator...");linecount++;declarate = 0;defline=0;BOL = 1;inPrint=0;arrayAccess=false;parenORbrack="";inReturn=0;boolexp=0;existingType="";}
{EOF}  {System.out.println("EOF");}
.      {System.out.println("Reached end of Lex specification.");}
