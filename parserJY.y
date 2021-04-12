//Jason Yin parser with byacc (java) LR, to run type in java Parser <inputfilename>
//identifying patterns in the code is important for semantics
//certain procedure call generated code will be able to calculate values to store immediates immediately
%{
import java.io.*;
import java.util.*;
import java.lang.*;
import java.nio.file.*;
import java.io.FileWriter;//assignment 4
import java.io.IOException;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.Scanner;
%}
%token CLASS_T MAIN_T COLON END_T CLASS_ID DEF_T ID LP RP COMMA LB RB PRINT_T /*ASSIGN*/ INPUT_T WHILE_T IF_T ELSE_T RETURN_T DOT /*EQ NE LT LE GT GE AND OR NOT PLUS MINUS MULT*/ INT_LIT TRUE_T FALSE_T
//%token <obj> TRUE_T
%token <sval> TRUE_T
%token <sval> FALSE_T
%token <ival> INT_LIT
%token <sval> ID LB RB LP RP COMMA ASSIGN CLASS_ID DOT COLON CLASS_T MAIN_T END_T DEF_T PRINT_T INPUT_T WHILE_T IF_T ELSE_T RETURN_T
//%type <obj> exp /*parameters int_list /*statements statement param_list*/
//%type <ival> exp
%type <sval> exp int_list param_list parameters optional_else

%nonassoc ASSIGN
%nonassoc OR
%nonassoc AND
%nonassoc LT LE GT GE EQ NE
%right NOT
%left PLUS MINUS
%left MULT

%%
program : class_list
 ;
class_list : class_list class
 | class
 ;
class : CLASS_T MAIN_T COLON function_list {/*after functions,do main mython*/ /*try{ FileWriter mySFile = new FileWriter(outputname,true);
            if(not_in_main==0){//not in main is false meaning it is true that in main
                mySFile.write("\t.text\n");
                mySFile.write(".globl mython\n");
                mySFile.write("\t.type mython, @function\n");
                mySFile.write("mython:\n");
                mySFile.write("\tpushq %rbx\n");//procedure call/return control flow at the start
                mySFile.write("\tpushq %rbp\n");
                mySFile.write("\tpushq %r12\n");
                mySFile.write("\tpushq %r13\n");
                mySFile.write("\tpushq %r14\n");
                mySFile.write("\tpushq %r15\n");
                mySFile.write("\tsubq $128, %rsp\n");
                mySFile.close();//ALWAYS remember to close after write
            }}
            catch(IOException e){System.out.println("WRITE ERROR FOR MAIN MYTHON!");}*/startMython(); } statements END_T {}
 | CLASS_T CLASS_ID COLON { //FOR STACK_OBJ
 stackobjTracker +=1;//objClassInitiator($2);//made helper method because code was getting too long for yyparse
 /*try{
    FileWriter mySFile = new FileWriter(outputname,true);
    mySFile.write("\t.text\n");
    mySFile.write("globl "+$2+"_construct\n");
    mySFile.write("\t.type   "+$2+"_construct, @function\n");
    mySFile.write($2+"_construct:\n");//constructor label
    mySFile.write("\tpushq %rbx\n");//procedure call/return control flow at the start
    mySFile.write("\tpushq %rbp\n");
    mySFile.write("\tpushq %r12\n");
    mySFile.write("\tpushq %r13\n");
    mySFile.write("\tpushq %r14\n");
    mySFile.write("\tpushq %r15\n");
    mySFile.write("\tsubq $128, %rsp\n");

    mySFile.write("\tmovl $9, %r10d\n");
    mySFile.write("\tmovl %r10d, 0(%rdi)\n"); // max = 9
    mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case printf)
    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
    mySFile.write("\tmovq %r8, 96(%rsp)\n");
    mySFile.write("\tmovq %r9, 104(%rsp)\n");
    mySFile.write("\tmovq %r10, 112(%rsp)\n");
    mySFile.write("\tmovq %r11, 120(%rsp)\n");
    mySFile.write("\tmovl $400, %edi\n");
    mySFile.write("\tcall malloc\n");
    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
    mySFile.write("\tmovq 72(%rsp), %rsi\n");
    mySFile.write("\tmovq 80(%rsp), %rdx\n");
    mySFile.write("\tmovq 88(%rsp), %rcx\n");
    mySFile.write("\tmovq 96(%rsp), %r8\n");
    mySFile.write("\tmovq 104(%rsp), %r9\n");
    mySFile.write("\tmovq 112(%rsp), %r10\n");
    mySFile.write("\tmovq 120(%rsp), %r11\n");
    mySFile.write("\tmovq %rax, 4(%rdi)\n"); //space for stack
    mySFile.write("\tmovl $0,(%rax)\n");//initialize 9 locations to zero
    mySFile.write("\tmovl $0,4(%rax)\n");
    mySFile.write("\tmovl $0,8(%rax)\n");
    mySFile.write("\tmovl $0,12(%rax)\n");
    mySFile.write("\tmovl $0,16(%rax)\n");
    mySFile.write("\tmovl $0,20(%rax)\n");
    mySFile.write("\tmovl $0,24(%rax)\n");
    mySFile.write("\tmovl $0,28(%rax)\n");
    mySFile.write("\tmovl $0,32(%rax)\n");
    mySFile.write("\tmovl $0, %r10d\n");
    mySFile.write("\tmovl %r10d, 12(%rdi)\n"); //stack top = 0

    mySFile.write("."+$2+"_construct_return:\n");
    mySFile.write("\taddq $128, %rsp\n");
    mySFile.write("\tpopq %r15\n");
    mySFile.write("\tpopq %r14\n");
    mySFile.write("\tpopq %r13\n");
    mySFile.write("\tpopq %r12\n");
    mySFile.write("\tpopq %rbp\n");
    mySFile.write("\tpopq %rbx\n");
    mySFile.write("\tret\n");
    mySFile.write("\t.size   "+$2+"_construct, .-"+$2+"_construct\n");

    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR CLASS ID");
 }*/ currclassID = $2;//keep track of the class ID name for writing to .s file
 } optional_constructor function_list END_T {System.out.println("classid: "+$2);stackobjTracker-=1;currclassID="";
 try{
    FileWriter mySFile = new FileWriter(outputname,true);
    //mySFile.write("\t.text\n");
    //mySFile.write("globl");
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR CLASS ID");
 }
 }
 ;
optional_constructor: CLASS_ID COLON {objClassInitiator($1);} assign_list {/*class constructor gets printed here*/}
 |
 ;
function_list : function_list function
 |
 ;
function : DEF_T ID LP parameters RP COLON {not_in_main+=1;System.out.print("params:");System.out.println(prm);
if(stackobjTracker>0){//the stackobjTracker is a int that keeps track of whether in the scope of an object class like stack
    //function within another object
    //includes parameters FIXed?
    System.out.println("object function with params:"+$2);objectFunctionParams($2,currclassID);//pass in the function ID and then the class ID
}
else{
try{
    FileWriter mySFile = new FileWriter(outputname, true);
    mySFile.write("\t.text\n");
    mySFile.write(".globl "+$2+"\n");
    mySFile.write("\t.type   "+$2+", @function\n");
    mySFile.write($2+":\n");
    mySFile.write("\tpushq %rbx\n");
    mySFile.write("\tpushq %rbp\n");
    mySFile.write("\tpushq %r12\n");
    mySFile.write("\tpushq %r13\n");
    mySFile.write("\tpushq %r14\n");
    mySFile.write("\tpushq %r15\n");
    mySFile.write("\tsubq $128, %rsp\n");
    mySFile.close();
}
catch(IOException e){
    System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMS");
}}
}statements {not_in_main-=1;
    if(stackobjTracker>0){
        //after statements of a function with params you must perform the _return: label and return lines
        //FIXed?
        objectFunctionReturn($2,currclassID);
    }
    else{

try{
    FileWriter mySFile = new FileWriter(outputname,true);
    mySFile.write("."+$2+"_return:\n");//function return
    mySFile.write("\taddq $128, %rsp\n");
    mySFile.write("\tpopq %r15\n");
    mySFile.write("\tpopq %r14\n");
    mySFile.write("\tpopq %r13\n");
    mySFile.write("\tpopq %r12\n");
    mySFile.write("\tpopq %rbp\n");
    mySFile.write("\tpopq %rbx\n");
    mySFile.write("\tret\n");
    mySFile.write("\t.size   "+$2+", .-"+$2+"\n");
    mySFile.close();
}
catch(IOException e){
    System.out.println("WRITE ERROR FOR FUNCTION RETURN w/ PARAMS");
}}
}END_T { System.out.println("function: "+$2+", args: "+$4);assignA($2,$4); local_table.clear();prm.clear();/*ADDED 4/5 clear param arraylist*/}//add to function table, clear the local_table
 | DEF_T ID LP RP COLON {not_in_main+=1;//no shift reduce error for this part, this is a function header with no params
 if(stackobjTracker>0){
    //function declared in a separate object class , but no parameters
    //FIXed?
    objectFunctionNoParams($2,currclassID);
 }
 else{
 try{
    FileWriter mySFile = new FileWriter(outputname,true);
    mySFile.write("\t.text\n");
    mySFile.write(".globl "+$2+"\n");
    mySFile.write("\t.type   "+$2+", @function\n");
    mySFile.write($2+":\n");
    mySFile.write("\tpushq %rbx\n");
    mySFile.write("\tpushq %rbp\n");
    mySFile.write("\tpushq %r12\n");
    mySFile.write("\tpushq %r13\n");
    mySFile.write("\tpushq %r14\n");
    mySFile.write("\tpushq %r15\n");
    mySFile.write("\tsubq $128, %rsp\n");
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR FUNCTION w/ NO PARAMS");
 }
 }
 }statements {System.out.println("function: "+$2+", args: none");assignA($2,"");not_in_main-=1;//not_in_main basically keeps track of whether or not in the main scope
 if(stackobjTracker>0){
    //within scope of object class and this is a function return label of a object function
    objectFunctionReturn($2,currclassID);//fixed?
 }
 else{
 try{ //what is written at the end of a function with no parameters
    FileWriter mySFile = new FileWriter(outputname,true);
    mySFile.write("."+$2+"_return:\n");
    mySFile.write("\taddq $128, %rsp\n");
    mySFile.write("\tpopq %r15\n");
    mySFile.write("\tpopq %r14\n");
    mySFile.write("\tpopq %r13\n");
    mySFile.write("\tpopq %r12\n");
    mySFile.write("\tpopq %rbp\n");
    mySFile.write("\tpopq %rbx\n");
    mySFile.write("\tret\n");
    mySFile.write("\t.size   "+$2+", .-"+$2+"\n");
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR FUNCTION w/ NO PARAMS RETURN");
 }}
 }END_T   {local_table.clear();} //add blank string to function table. function table maps a function ID to list of parameters, and this case does not have parameters
 ;
parameters : parameters COMMA ID {$$+=$2+$3;prm.add($3);} //zero arguments will be null
 | parameters COMMA ID LB RB {$$+=$2+$3+$4+$5;prm.add($3+$4+$5);} //this is where the string representing the parameters will be created
 | ID   {/*$$=lookup(new ParserVal($1.ival));*/$$="";$$+=$1;prm.add($1);}
 | ID LB RB {$$="";$$+=$1+$2+$3;prm.add($$);}
 ;
statements : statements statement   {}
 | statement
 ;
statement : condition_stmt  {}
 | while_stmt
 | return_stmt
 | call_stmt
 | print_stmt
 | input_stmt
 | assignment_stmt {}
 ;
print_stmt : PRINT_T exp    {/*System.out.println("print: "+$2); if(isNumeric($2)==false && !lexer.params.contains($2) && !lexer.ids.contains($2) ){yyerror("Print expects integer type");}*/  if(isNumeric($2) && registers.containsValue(Integer.parseInt($2))){//if registers contains value then search for that existing register
for(String key : registers.keySet()){//for first case when an array is encountered each int lit in the list is loaded to a register because of the int lit production
            if(registers.get(key)==Integer.parseInt($2) ){
                try{
                    FileWriter mySFile = new FileWriter(outputname,true);
                    mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case printf)
                    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
                    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
                    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
                    mySFile.write("\tmovq %r8, 96(%rsp)\n");
                    mySFile.write("\tmovq %r9, 104(%rsp)\n");
                    mySFile.write("\tmovq %r10, 112(%rsp)\n");
                    mySFile.write("\tmovq %r11, 120(%rsp)\n");

                    mySFile.write("\tmovl "+key+", "+"%esi\n");//esi holds second parameter, this key corresponds to the register name that holds the value of the exp in the print
                    SpecialRegisters.replace("%esi",registers.get(key));//update special register value, not completely necessary actually
                    mySFile.write("\tmovq S1(%rip), %rdi\n");//rdi is first parameter, these parameters are specific to the printf function call
                    mySFile.write("\tmovl $0, %eax\n");//move 0 to return register because printf has no return value
                    mySFile.write("\tcall printf\n");//make the function call

                    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
                    mySFile.write("\tmovq 72(%rsp), %rsi\n");
                    mySFile.write("\tmovq 80(%rsp), %rdx\n");
                    mySFile.write("\tmovq 88(%rsp), %rcx\n");
                    mySFile.write("\tmovq 96(%rsp), %r8\n");
                    mySFile.write("\tmovq 104(%rsp), %r9\n");
                    mySFile.write("\tmovq 112(%rsp), %r10\n");
                    mySFile.write("\tmovq 120(%rsp), %r11\n");
                    mySFile.close();//close file whenever you do the try-catch with mySFile writing
                    break;
                }
                catch(IOException e){
                    System.out.println("WRITE ERROR FOR PRINT INT INSTR!");
                }
            }
        } }
        else if(isNumeric($2) && !registers.containsValue(Integer.parseInt($2))){//this second case is for numeric values that may not have been stored within a register, so sometimes for cases involving a value taken from an array[index] case
            try{
                    FileWriter mySFile = new FileWriter(outputname,true);
                    mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case printf)
                    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
                    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
                    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
                    mySFile.write("\tmovq %r8, 96(%rsp)\n");
                    mySFile.write("\tmovq %r9, 104(%rsp)\n");
                    mySFile.write("\tmovq %r10, 112(%rsp)\n");
                    mySFile.write("\tmovq %r11, 120(%rsp)\n");

                    mySFile.write("\tmovl $"+$2+", "+"%esi\n");//esi holds second parameter, this key corresponds to the register name that holds the value of the exp in the print
                    SpecialRegisters.replace("%esi",Integer.parseInt($2));//update special register value, not completely necessary actually
                    mySFile.write("\tmovq S1(%rip), %rdi\n");//rdi is first parameter, these parameters are specific to the printf function call
                    mySFile.write("\tmovl $0, %eax\n");//move 0 to return register because printf has no return value
                    mySFile.write("\tcall printf\n");//make the function call

                    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
                    mySFile.write("\tmovq 72(%rsp), %rsi\n");
                    mySFile.write("\tmovq 80(%rsp), %rdx\n");
                    mySFile.write("\tmovq 88(%rsp), %rcx\n");
                    mySFile.write("\tmovq 96(%rsp), %r8\n");
                    mySFile.write("\tmovq 104(%rsp), %r9\n");
                    mySFile.write("\tmovq 112(%rsp), %r10\n");
                    mySFile.write("\tmovq 120(%rsp), %r11\n");
                    mySFile.close();//close file whenever you do the try-catch with mySFile writing
                    break;
                }
                catch(IOException e){
                    System.out.println("WRITE ERROR FOR PRINT INT INSTR!");
                }
        }
        else if(isNumeric($2)==false && ($2.equals("true") || $2.equals("false")) ){//$2 not equal to 000 or p-op
            //boolean case for printing, the above if statement is for ints
            int ans = -1;
            if($2.equals("true")){
                ans = 1;
            }
            else if($2.equals("false")){
                ans=0;
            }
            for(String key : registers.keySet()){
            if(registers.get(key)==ans ){
                try{
                    FileWriter mySFile = new FileWriter(outputname,true);
                    mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case printf)
                    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
                    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
                    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
                    mySFile.write("\tmovq %r8, 96(%rsp)\n");
                    mySFile.write("\tmovq %r9, 104(%rsp)\n");
                    mySFile.write("\tmovq %r10, 112(%rsp)\n");
                    mySFile.write("\tmovq %r11, 120(%rsp)\n");

                    mySFile.write("\tmovl "+key+", "+"%esi\n");//esi holds second parameter, this key corresponds to the register name that holds the value of the exp in the print
                    SpecialRegisters.replace("%esi",registers.get(key));//update special register value, not completely necessary actually
                    mySFile.write("\tmovq S1(%rip), %rdi\n");//rdi is first parameter, these parameters are specific to the printf function call
                    mySFile.write("\tmovl $0, %eax\n");//move 0 to return register because printf has no return value
                    mySFile.write("\tcall printf\n");//make the function call

                    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
                    mySFile.write("\tmovq 72(%rsp), %rsi\n");
                    mySFile.write("\tmovq 80(%rsp), %rdx\n");
                    mySFile.write("\tmovq 88(%rsp), %rcx\n");
                    mySFile.write("\tmovq 96(%rsp), %r8\n");
                    mySFile.write("\tmovq 104(%rsp), %r9\n");
                    mySFile.write("\tmovq 112(%rsp), %r10\n");
                    mySFile.write("\tmovq 120(%rsp), %r11\n");
                    mySFile.close();//close file whenever you do the try-catch with mySFile
                    break;
                }
                catch(IOException e){
                    System.out.println("WRITE ERROR FOR PRINT BOOL INSTR!");
                }
            }
        }
        }
        else if($2.equals("p-op")){
            //move r10d to esi for printing
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case printf)
                mySFile.write("\tmovq %rsi, 72(%rsp)\n");
                mySFile.write("\tmovq %rdx, 80(%rsp)\n");
                mySFile.write("\tmovq %rcx, 88(%rsp)\n");
                mySFile.write("\tmovq %r8, 96(%rsp)\n");
                mySFile.write("\tmovq %r9, 104(%rsp)\n");
                mySFile.write("\tmovq %r10, 112(%rsp)\n");
                mySFile.write("\tmovq %r11, 120(%rsp)\n");
                mySFile.write("\tmovl %r10d, %esi\n"); //hard coded r10d
                mySFile.write("\tmovl S1(%rip), %edi\n");
                mySFile.write("\tmovl $0, %eax\n");
                mySFile.write("\tcall printf\n");//make the function call

                mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
                mySFile.write("\tmovq 72(%rsp), %rsi\n");
                mySFile.write("\tmovq 80(%rsp), %rdx\n");
                mySFile.write("\tmovq 88(%rsp), %rcx\n");
                mySFile.write("\tmovq 96(%rsp), %r8\n");
                mySFile.write("\tmovq 104(%rsp), %r9\n");
                mySFile.write("\tmovq 112(%rsp), %r10\n");
                mySFile.write("\tmovq 120(%rsp), %r11\n");
                mySFile.close();
            }catch(IOException e){
                System.out.println("WRITE ERROR WITH PRINT SPCIAL");
            }
        }
        else if(!isNumeric($2)){
            //printing some identifier/function
            if(symbol_table.containsKey($2)){
                //identifier in the global scope
                try{
                    FileWriter mySFile = new FileWriter(outputname,true);
                    mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case printf)
                    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
                    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
                    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
                    mySFile.write("\tmovq %r8, 96(%rsp)\n");
                    mySFile.write("\tmovq %r9, 104(%rsp)\n");
                    mySFile.write("\tmovq %r10, 112(%rsp)\n");
                    mySFile.write("\tmovq %r11, 120(%rsp)\n");
                    mySFile.write("\tmovl "+$2+"(%rip), %esi\n");//global variable so use rip
                    mySFile.write("\tmovl S1(%rip), %edi\n");
                    mySFile.write("\tmovl $0, %eax\n");
                    mySFile.write("\tcall printf\n");//make the function call

                    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
                    mySFile.write("\tmovq 72(%rsp), %rsi\n");
                    mySFile.write("\tmovq 80(%rsp), %rdx\n");
                    mySFile.write("\tmovq 88(%rsp), %rcx\n");
                    mySFile.write("\tmovq 96(%rsp), %r8\n");
                    mySFile.write("\tmovq 104(%rsp), %r9\n");
                    mySFile.write("\tmovq 112(%rsp), %r10\n");
                    mySFile.write("\tmovq 120(%rsp), %r11\n");
                    mySFile.close();
                }
                catch(IOException e){
                    System.out.println("WRITE ERROR WITH PRINT GLOBAL VAR");
                }
            }
            else if(local_table.containsKey($2)){
                //identifier in the local scope
                try{
                    FileWriter mySFile = new FileWriter(outputname,true);
                    mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case printf)
                    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
                    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
                    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
                    mySFile.write("\tmovq %r8, 96(%rsp)\n");
                    mySFile.write("\tmovq %r9, 104(%rsp)\n");
                    mySFile.write("\tmovq %r10, 112(%rsp)\n");
                    mySFile.write("\tmovq %r11, 120(%rsp)\n");
                    mySFile.write("\tmovl $"+local_table.get($2)+", %esi\n");//local
                    mySFile.write("\tmovl S1(%rip), %edi\n");
                    mySFile.write("\tmovl $0, %eax\n");
                    mySFile.write("\tcall printf\n");//make the function call

                    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
                    mySFile.write("\tmovq 72(%rsp), %rsi\n");
                    mySFile.write("\tmovq 80(%rsp), %rdx\n");
                    mySFile.write("\tmovq 88(%rsp), %rcx\n");
                    mySFile.write("\tmovq 96(%rsp), %r8\n");
                    mySFile.write("\tmovq 104(%rsp), %r9\n");
                    mySFile.write("\tmovq 112(%rsp), %r10\n");
                    mySFile.write("\tmovq 120(%rsp), %r11\n");
                    mySFile.close();
                }
                catch(IOException e){
                    System.out.println("WRITE ERROR WITH PRINT LOCAL VAR");
                }
            }
            else if($2.equals("f-op")){
                //function identifier
                //take the value in eax and move to esi for printf call
                try{
                    FileWriter mySFile = new FileWriter(outputname, true);
                    mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case printf)
                    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
                    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
                    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
                    mySFile.write("\tmovq %r8, 96(%rsp)\n");
                    mySFile.write("\tmovq %r9, 104(%rsp)\n");
                    mySFile.write("\tmovq %r10, 112(%rsp)\n");
                    mySFile.write("\tmovq %r11, 120(%rsp)\n");
                    mySFile.write("\tmovl %eax, %esi\n");//return value so get eax and move to esi
                    mySFile.write("\tmovl S1(%rip), %edi\n");
                    mySFile.write("\tmovl $0, %eax\n");
                    mySFile.write("\tcall printf\n");//make the function call

                    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
                    mySFile.write("\tmovq 72(%rsp), %rsi\n");
                    mySFile.write("\tmovq 80(%rsp), %rdx\n");
                    mySFile.write("\tmovq 88(%rsp), %rcx\n");
                    mySFile.write("\tmovq 96(%rsp), %r8\n");
                    mySFile.write("\tmovq 104(%rsp), %r9\n");
                    mySFile.write("\tmovq 112(%rsp), %r10\n");
                    mySFile.write("\tmovq 120(%rsp), %r11\n");
                    mySFile.close();
                }
                catch(IOException e){
                    System.out.println("WRITE ERROR WITH PRINT FUNCTION RETURN");
                }
            }
        }
        }//$2(exp) is untyped?
 ;
input_stmt : ID ASSIGN INPUT_T  {//assignB($1,$3);assignB($1,"0000");
try{
    if(!symbol_table.containsKey($1) && not_in_main==0){ //input variable within main of the program
    FileWriter w = new FileWriter(outputname, true);
    w.write("\t.data\n");
    w.write("\t.align 4\n");
    w.write("\t.size "+$1+", 4\n");
    w.write($1+":\t.long 0\n");
    w.write("\t.text\n");

    w.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case scanf)
    w.write("\tmovq %rsi, 72(%rsp)\n");
    w.write("\tmovq %rdx, 80(%rsp)\n");
    w.write("\tmovq %rcx, 88(%rsp)\n");
    w.write("\tmovq %r8, 96(%rsp)\n");
    w.write("\tmovq %r9, 104(%rsp)\n");
    w.write("\tmovq %r10, 112(%rsp)\n");
    w.write("\tmovq %r11, 120(%rsp)\n");

    w.write("\tmovl $mython_input, %esi\n"); //parameter 2 in %rsi/esi
    w.write("\tmovq S0(%rip), %rdi\n"); //parameter 1 in %rdi/edi
    w.write("\tmovl $0, %eax\n");
    w.write("\tcall __isoc99_scanf\n");

    w.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
    w.write("\tmovq 72(%rsp), %rsi\n");
    w.write("\tmovq 80(%rsp), %rdx\n");
    w.write("\tmovq 88(%rsp), %rcx\n");
    w.write("\tmovq 96(%rsp), %r8\n");
    w.write("\tmovq 104(%rsp), %r9\n");
    w.write("\tmovq 112(%rsp), %r10\n");
    w.write("\tmovq 120(%rsp), %r11\n");

    w.write("\tmovl mython_input(%rip),%eax\n");
    w.write("\tmovl %eax, "+$1+"(%rip)\n");
    w.close();
    }
    else if(not_in_main!=0 && !local_table.containsKey($1)){
        //input variable not within the main scope of the program basically it is in a function scope, not yet defined so set it up FIX
        //FIXed?
        localVarInput($1);System.out.println("local input taken");
    }
}
catch(IOException e){
    System.out.println("WRITE ERROR WITH INPUT");
}assignB($1,$3);assignB($1,"0000");//then add to symbol table so next time the ID is contained as a key for the HashMap symbol table
}//four zeros represent input
 ;
while_stmt : WHILE_T {
//print label such as WHILE0: before the exp code
startWhile();
} exp COLON {beforeWhileStmts($3);
//FIXED

} statements {afterWhileStmts();} END_T {/*if(isNumeric($2)){yyerror("While statement requires boolean condition");}*/endWhile();}
 ;
condition_stmt : IF_T exp COLON {/*not_in_main+=1;*/
 //need to check exp whether it is zero or one so use cmpl with zero and create a variable to keep track of IF labels
 //first if exp is p-op then find register with max int value
 String tempreg="";
 if(ifStack.size()==1){
    tempcounter++;//if stack is at least size 1 then add to the counter when an if statement is parsed because this will be nested case
    IFlabel++;
 }
 ifStack.push(1);
 //IMPORTANT: this commented out code works however I had a code too large problem and this code is not completely necessary, just covers an absolute true or false case
 //update I worked around the issue and uncommented the two if and else if blocks below to handle true and false
 if($2.equals("true")){//
    try{
     FileWriter mySFile = new FileWriter(outputname, true);
     mySFile.write("\tcmpl $0,$1\n");
     mySFile.write("\tje IF"+String.valueOf(IFlabel)+"\n");
     mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR WITH IF END");
    }
 }
 else if($2.equals("false")){
    try{
     FileWriter mySFile = new FileWriter(outputname, true);
     mySFile.write("\tcmpl $0,$0\n");
     mySFile.write("\tje IF"+String.valueOf(IFlabel)+"\n");
     mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR WITH IF END");
    }
 }
 else if($2.equals("p-op")){
    for(String k:registers.keySet()){
        if(registers.get(k)==2147483647){
            //find register matching max int value
            tempreg = k;
            break;
        }
    }
    try{
     FileWriter mySFile = new FileWriter(outputname,true);
     mySFile.write("\tcmpl $0,"+tempreg+"\n");
     mySFile.write("\tje IF"+String.valueOf(IFlabel )+"\n");//so for the first if statement it will have label IF0 and use ++ to setup the write for jmp IF1
freeReg(tempreg);//added 4/7

     mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR WITH IF");
 }
 }

 } statements {//added 4/6
 try{
     FileWriter mySFile = new FileWriter(outputname, true);
     ///mySFile.write("\tjmp ."+lexer.functions.get(lexer.functions.size()-1)+"_return\n");//added 4/6
     mySFile.write("\tjmp IF"+String.valueOf(IFlabel )+"\n"); //System.out.println($7);

        if(ifStack.size()==1 && tempcounter!=0){

     mySFile.write("IF"+String.valueOf(IFlabel-tempcounter-1)+":#bruh\n");
     IFlabel++;
        }
        else if(ifStack.size()>1){
           // mySFile.write("IF"+String.valueOf(IFlabel-tempcounter)+":\n");//added 4/7, a stack for nested ifs
           mySFile.write("IF"+String.valueOf(IFlabel++)+":#placeholder\n");
        }
        else{
            mySFile.write("IF"+String.valueOf(IFlabel++)+":#placeholder\n");
        }
     mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR WITH IF END");
 }
 } optional_else END_T  {if(isNumeric($2)){yyerror("If statement requires boolean condition"); /*ifnested-=1;*/} //notinmain-=1
 //after the IF write jmp return and jmp IFlabel++

 if(ifStack.size()==1){
    tempcounter = 0;
 }
 ifStack.pop();

 }
 ;
optional_else : ELSE_T COLON {//$$="exists";
try{
    FileWriter mySFile = new FileWriter(outputname, true);
    ///mySFile.write("IF"+String.valueOf(IFlabel)+":\n");
    //mySFile.write("\tjmp ."+lexer.functions.get(lexer.functions.size()-1)+"_return\n");
    mySFile.close();
}
catch(IOException e){
    System.out.println("WRITE ERROR FOR ELSE");
}
} statements {
try{
    FileWriter mySFile = new FileWriter(outputname, true);
    mySFile.write("IF"+String.valueOf(IFlabel)+":\n");
    ///mySFile.write("\tjmp ."+lexer.functions.get(lexer.functions.size()-1)+"_return\n");
    mySFile.close();
}
catch(IOException e){
    System.out.println("WRITE ERROR FOR ELSE");
}
}//no condition for else
 |
 ;//optional else could be epsilon
assignment_stmt : ID ASSIGN exp {/*if(isNumeric($3)){assignB($1,$3);}else{assignB($1,$3);}*/ System.out.println("assignment stmt: "+$1+"="+$3); //weird NOTE:For some reason I started getting a yacc warning for this line, but I had never received that warning previously before. it just started happening and I don't know why
if(isNumeric($3) && not_in_main==0){//Global integer variable case
    //integer case
    //for example the movl $5, %r10d line will be covered in the production of expr: int_lit
    try{
        FileWriter mySFile = new FileWriter(outputname,true);
        if(!symbol_table.containsKey($1)){
        mySFile.write("\t.data\n");
        mySFile.write("\t.align 4\n");
        mySFile.write("\t.size "+$1+", 4\n");
        mySFile.write($1+":\t.long 0\n");
        mySFile.write("\t.text\n");
        }
        String temp = "";
        for(String k : registers.keySet()){
            if(registers.get(k)==Integer.parseInt($3)){
                temp = k;
                break;//find register of corresponding value
            }
        }
        mySFile.write("\tmovl "+temp+", "+$1+"(%rip)\n");//global data
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR WITH GLOBAL INTEGER ASSIGNMENT");
    }
}
else if(not_in_main==0 && isNumeric($3)==false && $3.equals("true")  ){
    //non integer case, specifically boolean case true
    //for example the movl $1, %r10d line will be covered in the production of expr: TRUE
    try{
        FileWriter mySFile = new FileWriter(outputname,true);
        if(!symbol_table.containsKey($1)){
        mySFile.write("\t.data\n");
        mySFile.write("\t.align 4\n");
        mySFile.write("\t.size "+$1+", 4\n");
        mySFile.write($1+":\t.long 0\n");
        mySFile.write("\t.text\n");
        }
        //String temp = "%r10d";//hard coded to use r10d for boolean globals
        String temp = "";
        for(String k : registers.keySet()){
            if(registers.get(k)==1 ){
                temp = k;
                break;//find register of corresponding value
            }
        }
        mySFile.write("\tmovl "+temp+", "+$1+"(%rip)\n");//global data
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR WITH GLOBAL BOOLEAN TRUE ASSIGNMENT");
    }
}
else if(not_in_main==0 && isNumeric($3)==false && $3.equals("false")  ){
    //non integer case, specifically boolean case false
    //for example the movl $0, %r10d line will be covered in the production of expr: FALSE
    try{
        FileWriter mySFile = new FileWriter(outputname,true);
        if(!symbol_table.containsKey($1)){
        mySFile.write("\t.data\n");
        mySFile.write("\t.align 4\n");
        mySFile.write("\t.size "+$1+", 4\n");
        mySFile.write($1+":\t.long 0\n");
        mySFile.write("\t.text\n");
        }
        String temp = "";
        for(String k : registers.keySet()){
            if(registers.get(k)==0/*Integer.parseInt($3)*/){
                temp = k;
                break;//find register of corresponding value
            }
        }
        mySFile.write("\tmovl "+temp+", "+$1+"(%rip)\n");//global data
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR WITH GLOBAL BOOLEAN FALSE ASSIGNMENT");
    }
}//if(isNumeric($3)){assignB($1,$3);}else{assignB($1,$3);}
else if(!isNumeric($3) && $3.equals("f-op") && not_in_main==0){
    //global variable assignment to a return value(in main)
    try{
        FileWriter mySFile = new FileWriter(outputname, true);//don't make duplicate labels
        if(!symbol_table.containsKey($1)){ //remember to check if symbol already exists in the table so you don't write multiple duplicate labels in the .s file
        mySFile.write("\t.data\n");
        mySFile.write("\t.align 4\n");
        mySFile.write("\t.size "+$1+", 4\n");
        mySFile.write($1+":\t.long 0\n");
        mySFile.write("\t.text\n");
        }
        mySFile.write("\tmovl %eax, "+$1+"(%rip)\n");//store global data
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR GLOBAL VAR ASSIGNED TO RETURN VAL");
    }
}
else if(!isNumeric($3) && $3.equals("f-op") && not_in_main!=0){
    //local variable assignment to a return value (this case is a local var of a function)
    //take eax and move to stack offset, first check if $1 is already defined local var so check stackOffsetInfo.contains($1)
    //FIX
    if(stackOffsetInfo.containsKey($1)){//added 4/9
        ///calcLocalStackOffset($1);
        try{
        FileWriter mySFile = new FileWriter(outputname ,true);
        mySFile.write("\tmovl %eax, "+String.valueOf(calcLocalStackOffset($1)*4)+"(%rsp)\n");//take edi and put it in the stack offset
        mySFile.close();
        //rspOffset+=4;//increment offset of the stack pointer by 4, this needs to be reset at the end of the function
        //stackOffsetInfo.put($1,-2147483647);
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR LOCAL VAR ASSIGNED TO RETURN VAL");
    }
    }
    else{
    try{
        FileWriter mySFile = new FileWriter(outputname ,true);
        mySFile.write("\tmovl %eax, "+String.valueOf(rspOffset)+"(%rsp)\n");//take edi and put it in the stack offset
        mySFile.close();
        rspOffset+=4;//increment offset of the stack pointer by 4, this needs to be reset at the end of the function
        stackOffsetInfo.put($1,-2147483647);
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR LOCAL VAR ASSIGNED TO RETURN VAL");
    }
    }
}
else if(!isNumeric($3) && $3.equals("p-op")){ //&& not_in_main!=0 this is assumed by the p-op which only parameters live in functions
    //local variable assigned to a p-op (parameter operation or just a parameter)
    System.out.println("HELLLLOOO");System.out.println(prm+","+$3);
    if(prm.contains($3)){
        //a parameter so check which index and take corresponding argument register to stack offset
        if(prm.indexOf($3)==0){
            //first argument
            try{
                FileWriter mySFile = new FileWriter(outputname ,true);
                mySFile.write("\tmovl %edi, "+String.valueOf(rspOffset)+"(%rsp)\n");//take edi and put it in the stack offset
                mySFile.close();
                rspOffset+=4;//increment offset of the stack pointer by 4, this needs to be reset at the end of the function
                stackOffsetInfo.put($1,-2147483648);
                ///stackOffsetInfo.put($1,"p-op");
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR LOCAL VAR ASSIGNED TO PARAM OR PARAM OPERATION");
            }
        }
        else if(prm.indexOf($3)==1){
            //second arg
            try{
                FileWriter mySFile = new FileWriter(outputname ,true);
                mySFile.write("\tmovl %esi, "+String.valueOf(rspOffset)+"(%rsp)\n");//take edi and put it in the stack offset
                mySFile.close();
                rspOffset+=4;//increment offset of the stack pointer by 4, this needs to be reset at the end of the function
                stackOffsetInfo.put($1,-2147483648);
                //stackOffsetInfo.put($1,"p-op");
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR LOCAL VAR ASSIGNED TO PARAM OR PARAM OPERATION");
            }
        }
        else if(prm.indexOf($3)==2){
            //third arg
            try{
                FileWriter mySFile = new FileWriter(outputname ,true);
                mySFile.write("\tmovl %edx, "+String.valueOf(rspOffset)+"(%rsp)\n");//take edi and put it in the stack offset
                mySFile.close();
                rspOffset+=4;//increment offset of the stack pointer by 4, this needs to be reset at the end of the function
                stackOffsetInfo.put($1,-2147483648);
                //stackOffsetInfo.put($1,"p-op");
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR LOCAL VAR ASSIGNED TO PARAM OR PARAM OPERATION");
            }
        }
        else if(prm.indexOf($3)==3){
            //fourth arg
            try{
                FileWriter mySFile = new FileWriter(outputname ,true);
                mySFile.write("\tmovl %ecx, "+String.valueOf(rspOffset)+"(%rsp)\n");//take edi and put it in the stack offset
                mySFile.close();
                rspOffset+=4;//increment offset of the stack pointer by 4, this needs to be reset at the end of the function
                stackOffsetInfo.put($1,-2147483648);
                //stackOffsetInfo.put($1,"p-op");
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR LOCAL VAR ASSIGNED TO PARAM OR PARAM OPERATION");
            }
        }
        else if(prm.indexOf($3)==4){
            //fifth arg
            try{
                FileWriter mySFile = new FileWriter(outputname ,true);
                mySFile.write("\tmovl %r8d, "+String.valueOf(rspOffset)+"(%rsp)\n");//take edi and put it in the stack offset
                mySFile.close();
                rspOffset+=4;//increment offset of the stack pointer by 4, this needs to be reset at the end of the function
                stackOffsetInfo.put($1,-2147483648);
                //stackOffsetInfo.put($1,"p-op");
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR LOCAL VAR ASSIGNED TO PARAM OR PARAM OPERATION");
            }
        }
    }
    else{
        //not a parameter but a result of an operation using parameters, then use r10d and move r10d to stack offset
        try{
                FileWriter mySFile = new FileWriter(outputname ,true);
                mySFile.write("\tmovl %r10d, "+String.valueOf(rspOffset)+"(%rsp)\n");//take edi and put it in the stack offset
                mySFile.close();
                rspOffset+=4;//increment offset of the stack pointer by 4, this needs to be reset at the end of the function
                stackOffsetInfo.put($1,-2147483648);//change to p-op
                //stackOffsetInfo.put($1,"p-op");
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR LOCAL VAR ASSIGNED TO PARAM OR PARAM OPERATION");
            }
    }
}
else if(not_in_main!=0 && isNumeric($3)){
    //numeric local variable assignment, put in local table and load to some offset
    try{
        FileWriter mySFile = new FileWriter(outputname ,true);
        mySFile.write("\tmovl $"+String.valueOf($3)+", "+String.valueOf(rspOffset)+"(%rsp)\n");//take edi and put it in the stack offset
        mySFile.close();
        rspOffset+=4;//increment offset of the stack pointer by 4, this needs to be reset at the end of the function
        stackOffsetInfo.put($1,Integer.parseInt($3));//to get the offset of the stored value for the variable you perform stackOffsetInfo.indexOf($1)*4
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR LOCAL VAR ASSIGNED TO numeric value");
    }
    //local_table.put($1,$3); this is done below
}
else if(not_in_main!=0 && !isNumeric($3)){
    System.out.println("4/9");//FIX
    NonNumLocalVar($3,$1);//helper method
}
if(not_in_main!=0){local_table.put($1,$3);/*must store information about stack offset of local varsstackOffsetInfo.put($1,rspOffset);*/}//not in main so use local table, this table will clear after the def function END_T is parsed
else if(not_in_main==0){assignB($1,$3);}//in main so use symbol table
} //if statement does not really matter because value added as string regardless
 | ID LB exp RB ASSIGN exp {String temp =lookup($1);/*assignB($1+$2+$3+$4,$6);*/String res = "";res+="[";
 if(not_in_main==0){
    //global array
    if(symbol_table.containsKey($1)){
        //check for existence of the array identifier and then modify the string value so that the index of exp is changed
        String x = symbol_table.get($1);//lookup and .get do the same thing for the symbol table
        x = x.substring(1,x.length()-1);
        String [] ans = x.split("\\.");//either period or comma If I recall correctly I separated with periods
        ans[Integer.parseInt($3)] = $6;//set the proper index to the new value but then must build a new string to replace the $1 key in the symbol table
        for(int i = 0;i<ans.length;i++){
            res+=ans[i];
            if(i!=ans.length-1){
                res+=".";
            }
        }
        res+="]";
        symbol_table.replace($1,res);//replace the old ID key in the symbol table with the new set of ints for the array
        //now produce assembly code to modify that index of the array
        //first find int literal stored in a register for the exp in $3, then move the ID(%rip) to rax , then find the next register that stores the int literal of $6 and move accordingly
        String inx = "";
        String assignedTo="";
        for(String key:registers.keySet()){
            if(registers.get(key) == Integer.parseInt($3)){
                inx = key;
            }
            else if(registers.get(key)==Integer.parseInt($6)){
                assignedTo = key;
            }
            if(!inx.equals("") && !assignedTo.equals("")){
                break;
            }
        }
        try{
                FileWriter mySFile = new FileWriter(outputname ,true);
                mySFile.write("\tmovq "+$1+"(%rip),%rax\n");
                if(inx.equals("%ebx")){
                    inx = "%rbx";
                }
                else if(inx.equals("%ebp")){
                    inx = "%rbp";
                }
                else{
                    inx = inx.substring(0,4);
                }
                mySFile.write("\tmovl "+assignedTo+", (%rax,"+inx+",4)\n");//modify correct index
                mySFile.close();

        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR ID[num] ASSIGN exp");
        }
    }//printMap(registers);
 }
 else if(not_in_main!=0){
    //local array
    if(local_table.containsKey($1)){
        String x = local_table.get($1);
        x= x.substring(1,x.length()-1);
        String [] ans = x.split("\\.");
        ans[Integer.parseInt($3)] = $6;
        for(int i = 0;i<ans.length;i++){
            res+=ans[i];
            if(i!=ans.length-1){
                res+=".";
            }
        }
        res+="]";
        local_table.replace($1,res);
        String inx = "";
        String assignedTo="";
        for(String key:registers.keySet()){
            if(registers.get(key) == Integer.parseInt($3)){
                inx = key;
            }
            else if(registers.get(key)==Integer.parseInt($6)){
                assignedTo = key;
            }
            if(!inx.equals("") && !assignedTo.equals("")){
                break;
            }
        }
        try{
                FileWriter mySFile = new FileWriter(outputname ,true);//FIX
                //mySFile.write("\tmovq "+$1+"(%rip),%rax\n"); //To do
                //mySFile.write("\tmovl "+assignedTo+", (%rax,"+inx+",4)\n");//modify correct index
                mySFile.close();

        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR ID[num] ASSIGN exp (local case)");
        }
    }
 }
 } //array index, make a new assign operation on the symbol table
 | ID ASSIGN LB int_list RB {String result = $3+$4+$5;
 if(not_in_main==0){
    //global array case
    assignB($1,result);//add to symbol_table global
    //int_list will be separated by periods
    try{
        FileWriter mySFile = new FileWriter (outputname, true);
        mySFile.write("\t.data\n");
        mySFile.write("\t.align 8\n");
        mySFile.write("\t.size "+$1+", 8\n");
        mySFile.write($1+":\t.zero 8\n");
        mySFile.write("\t.text\n");
        mySFile.write("\tmovl $400, %edi\n");
        mySFile.write("\tcall malloc\n");
        mySFile.write("\tmovq %rax, "+$1+"(%rip)\n");
        int offset = 0;
        for(int i = 0;i<$4.split("\\.").length ;i++){
            mySFile.write("\tmovl $"+$4.split("\\.")[i] +","+Integer.toString(offset)+"(%rax)\n");//load each part of the array into (rax)
            offset+=4;
        }
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR GLOBAL ARRAY ASSIGNMENT");
    }
 }
 else if(not_in_main!=0){
    //assignA($1,result);//local array case FIX
 }
 } //variable assigned to array, for some reason the keys for the hashtable taken from yacc are always NULL?! (FIXED)
 | ID ASSIGN CLASS_ID {}//objects, FIX
 ;
 assign_list : assign_list assignment_stmt
 |
 ;
return_stmt : RETURN_T exp  {/*if(isNumeric($2)==false && !lexer.params.contains($2) && $2!=null){yyerror("Return expects integer type");}*/
if(isNumeric($2)){//numeric return value (not identifier)
    String movetorax="";
    for(String k:registers.keySet()){
        if(registers.get(k)==Integer.parseInt($2)){
            movetorax = k;
            break;
        }
    }
    try{
        FileWriter mySFile = new FileWriter(outputname, true);
        mySFile.write("\tmovl "+movetorax+", %eax\n");
        mySFile.write("\tjmp ."+ lexer.functions.get(lexer.functions.size()-1)+"_return\n");
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR RETURN NUMBERS CASE");
    }
}
else if(!isNumeric($2)){
    //not a numeric return value (so identifier/param cases)
    if($2.equals("true")){//move 1 to eax
        //the exp:ID() or exp:ID(params) case will handle the stack restoring and parameter loading and call before this eax handling
        try{
        FileWriter mySFile = new FileWriter(outputname, true);
        mySFile.write("\tmovl $1, %eax\n");
        mySFile.write("\tjmp ."+ lexer.functions.get(lexer.functions.size()-1)+"_return\n");
        mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR RETURN NON NUMERIC CASE");
        }
    }
    else if($2.equals("false")){//move 0 to eax and jmp
        try{
        FileWriter mySFile = new FileWriter(outputname, true);
        mySFile.write("\tmovl $0, %eax\n");
        mySFile.write("\tjmp ."+ lexer.functions.get(lexer.functions.size()-1)+"_return\n");
        mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR RETURN NON NUMERIC CASE");
        }
    }
    else if($2.equals("p-op")){
        //r10d move to eax because purposely set r10d to have results of any operations that include parameter values or function return values
        try{
        FileWriter mySFile = new FileWriter(outputname, true);
        mySFile.write("\tmovl %r10d, %eax\n");
        mySFile.write("\tjmp ."+ lexer.functions.get(lexer.functions.size()-1)+"_return\n");
        mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR RETURN NON NUMERIC CASE");
        }
    }
    else if($2.equals("f-op")){
        //move eax to eax? FIX
        System.out.println("return result of a function");
        returnFunctionResult();
    }
    else if(prm.contains($2)){
        //if the return value is just a parameter, then find the appropriate register to return
        ///System.out.println("RETURN VALUE IS A PARAMETER");
        int q = prm.indexOf($2);
        if(q==0){
            //first parameter so take edi and move to eax
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl %edi,%eax\n");
                mySFile.write("\tjmp ."+ lexer.functions.get(lexer.functions.size()-1)+"_return\n");
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR RETURN VAL OF PARAM");
            }
        }
        else if(q==1){
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl %esi,%eax\n");
                mySFile.write("\tjmp ."+ lexer.functions.get(lexer.functions.size()-1)+"_return\n");
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR RETURN VAL OF PARAM");
            }
        }
        else if(q==2){
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl %edx,%eax\n");
                mySFile.write("\tjmp ."+ lexer.functions.get(lexer.functions.size()-1)+"_return\n");
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR RETURN VAL OF PARAM");
            }
        }
        else if(q==3){
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl %ecx,%eax\n");
                mySFile.write("\tjmp ."+ lexer.functions.get(lexer.functions.size()-1)+"_return\n");
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR RETURN VAL OF PARAM");
            }
        }
        else if(q==4){
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl %r8d,%eax\n");
                mySFile.write("\tjmp ."+ lexer.functions.get(lexer.functions.size()-1)+"_return\n");
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR RETURN VAL OF PARAM");
            }
        }
    }
    else if(local_table.containsKey($2)){
        //local variable
        //make helper method
        System.out.println("RETURN RESULT of local variable");
        returnLocalVar($2);
    }
}
}
 ;
call_stmt : ID LP RP    {if(lexer.functions.contains($1)){if(function_table.get($1).length()!=0 ){yyerror("Illegal num of parameters for function "+$1);}}
/*call statement without parameters*/
try{
    FileWriter mySFile = new FileWriter(outputname, true);
    mySFile.write("\tmovq %rdi, 64(%rsp)\n");
    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
    mySFile.write("\tmovq %r8, 96(%rsp)\n");
    mySFile.write("\tmovq %r9, 104(%rsp)\n");
    mySFile.write("\tmovq %r10, 112(%rsp)\n");
    mySFile.write("\tmovq %r11, 120(%rsp)\n");
    mySFile.write("\tcall "+$1+"\n");
    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
    mySFile.write("\tmovq 72(%rsp), %rsi\n");
    mySFile.write("\tmovq 80(%rsp), %rdx\n");
    mySFile.write("\tmovq 88(%rsp), %rcx\n");
    mySFile.write("\tmovq 96(%rsp), %r8\n");
    mySFile.write("\tmovq 104(%rsp), %r9\n");
    mySFile.write("\tmovq 112(%rsp), %r10\n");
    mySFile.write("\tmovq 120(%rsp), %r11\n");
    mySFile.close();
}
catch(IOException e){
    System.out.println("ERROR WITH WRITE IN CALL STMT OF FUNCTION W/ NO PARAMS!");
}
}//{if(lexer.functions.contains($1)){if(function_table.get($1).length()!=0 ){yyerror("Illegal num of parameters for function "+$1);}}}//report param errors here
 | ID LP param_list RP  {/*System.out.println($3);*/if(lexer.functions.contains($1)){if(function_table.get($1).split(",").length != $3.split(",").length){yyerror("Illegal num of parameters for function "+$1);}else{/*length could be same if 1 or no params*/ if( (function_table.get($1).length()==0&&$3.length()==1) || (function_table.get($1).length()==1&&$3.length()==0) ){yyerror("Illegal num of parameters for function "+$1);} } for(int i = 0;i<$3.split(",").length;i++){if($3.split(",")[i].equals("true")||$3.split(",")[i].equals("false") ){yyerror("Illegal parameter type: Integer or array expected");} } }
 System.out.println("parameter list for a call statement: "+$3);System.out.println(lexer.functions);System.out.println(prm);System.out.println(function_table.get($1));System.out.println($3);//use split later
 //call statement with parameters so need to load parameters (can load up to five parameters for this program)
 //if(function_table.get($1).split(",").length==1){//redo this check param_list not whatever set param from function table
 if($3.split(",").length==1){
    //case with one parameter only
    //if(isNumeric(function_table.get($1))){
    if(isNumeric($3)){
        //numeric parameter so no need to search symbol table
        /*String temp = nextAvailReg(Integer.parseInt(function_table.get($1)));
        if(temp.equals("")){//get a register
            for(String key : registers.keySet()){
                //free a register if none are currently available
                freeReg(key);
                temp=key;
                registers.replace(key,Integer.parseInt(function_table.get($1)));
                break;
            }
        }*/
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading 1 argument into rdi
            mySFile.write("\tmovq %rsi, 72(%rsp)\n");
            mySFile.write("\tmovq %rdx, 80(%rsp)\n");
            mySFile.write("\tmovq %rcx, 88(%rsp)\n");
            mySFile.write("\tmovq %r8, 96(%rsp)\n");
            mySFile.write("\tmovq %r9, 104(%rsp)\n");
            mySFile.write("\tmovq %r10, 112(%rsp)\n");
            mySFile.write("\tmovq %r11, 120(%rsp)\n");
            //mySFile.write("\tmovl $"+function_table.get($1)+", %edi\n");//move constant int to argument register
            mySFile.write("\tmovl $"+$3+", %edi\n");
            mySFile.write("\tcall "+$1+"\n");
            mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
            mySFile.write("\tmovq 72(%rsp), %rsi\n");
            mySFile.write("\tmovq 80(%rsp), %rdx\n");
            mySFile.write("\tmovq 88(%rsp), %rcx\n");
            mySFile.write("\tmovq 96(%rsp), %r8\n");
            mySFile.write("\tmovq 104(%rsp), %r9\n");
            mySFile.write("\tmovq 112(%rsp), %r10\n");
            mySFile.write("\tmovq 120(%rsp), %r11\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (NO IDS)");
        }
    }
    //else if(!isNumeric(function_table.get($1))){
    else if(!isNumeric($3)){//param is a variable identifier so must search the symbol table for the value to load into arg reg
        //if not numeric then need to find the identifier's value
        //System.out.println(lexer.ids);
        //System.out.println(lexer.vals);
        //symbol_table.get(function_table.get($1));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading 1 argument into rdi
            mySFile.write("\tmovq %rsi, 72(%rsp)\n");
            mySFile.write("\tmovq %rdx, 80(%rsp)\n");
            mySFile.write("\tmovq %rcx, 88(%rsp)\n");
            mySFile.write("\tmovq %r8, 96(%rsp)\n");
            mySFile.write("\tmovq %r9, 104(%rsp)\n");
            mySFile.write("\tmovq %r10, 112(%rsp)\n");
            mySFile.write("\tmovq %r11, 120(%rsp)\n");
            mySFile.write("\tmovl $"+symbol_table.get(function_table.get($1))+", %edi\n");//move constant int to argument register
            mySFile.write("\tcall "+$1+"\n");
            mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
            mySFile.write("\tmovq 72(%rsp), %rsi\n");
            mySFile.write("\tmovq 80(%rsp), %rdx\n");
            mySFile.write("\tmovq 88(%rsp), %rcx\n");
            mySFile.write("\tmovq 96(%rsp), %r8\n");
            mySFile.write("\tmovq 104(%rsp), %r9\n");
            mySFile.write("\tmovq 112(%rsp), %r10\n");
            mySFile.write("\tmovq 120(%rsp), %r11\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (ONE ID param)");
        }
    }
 }
 else if (function_table.get($1).split(",").length==2 || $3.split(",").length==2){//two arguments case
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (2 args)");
    }
    //case with loading two parameters, arg 0 and arg 1
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (2 args)");
    }
 }
 else if (function_table.get($1).split(",").length==3 || $3.split(",").length==3){//three arguments case, use OR because sometimes a parameter may be array that has commas
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (3 args)");
    }
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[2])){
        //third argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[2]+", %edx\n");//edx is third argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[2])){
        //third argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[2])+", %edx\n");//edx is third argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (3 args)");
    }
 }
 else if (function_table.get($1).split(",").length==4 || $3.split(",").length==4){//four arguments case
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (4 args)");
    }
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[2])){
        //third argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[2]+", %edx\n");
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[2])){
        //third argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[2])+", %edx\n");// passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[3])){
        //fourth argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[3]+", %ecx\n");//ecx is 4th argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[3])){
        //fourth argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[3])+", %ecx\n");//ecx is 4th argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (4 args)");
    }
 }
 else if (function_table.get($1).split(",").length==5 || $3.split(",").length==5){//five arguments case
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (5 args)");
    }
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[2])){
        //third argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[2]+", %edx\n");
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[2])){
        //third argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[2])+", %edx\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[3])){
        //fourth argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[3]+", %ecx\n");//ecx is 4th argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[3])){
        //fourth argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[3])+", %ecx\n");//passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[4])){
        //fifth argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[4]+", %r8d\n");//r8d is 5th argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[4])){
        //fifth argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[4])+", %r8d\n");//passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (5 args)");
    }
 }
 }
 | ID DOT ID LP RP
 | ID DOT ID LP param_list RP
 ;
exp : exp EQ exp    {$$ = String.valueOf($1==$3); //FIX
String r1="";String r2="";String tempreg="";

 if(registers.containsValue(Integer.parseInt($1)) && registers.containsValue(Integer.parseInt($3))){
    for(String k:registers.keySet()){
        if(registers.get(k)==Integer.parseInt($1)){
            r1=k;//dest register
        }
        else if(registers.get(k)==Integer.parseInt($3)){
            r2=k;//src register
        }
        if(!r1.equals("") && !r2.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
    }
    int result=0;
    if($$.equals("true")){
        result = 1;
    }
    try{
        FileWriter w = new FileWriter(outputname,true);
        w.write("\tcmpl "+r2+", "+r1+"\n");//r1 is the destination
        w.write("\tsete %al\n");
        //destination cases:
        if(r1.equals("%ebx")){
            w.write("\tmovzbq %al,%rbx\n");
            registers.replace("%ebx",result);//update appropriate register with result of booleans
        }
        else if(r1.equals("%ebp")){
            w.write("\tmovzbq %al,%rbp\n");
            registers.replace("%ebp",result);
        }
        else{
            String t = r1.substring(0,4);
            w.write("\tmovzbq %al,"+t+"\n");
            registers.replace(r1,result);
        }
        w.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR <");
    }
 }}//parser value cannot be converted to string?
 | exp NE exp   {$$=String.valueOf($1!=$3); //FIX
 String r1="";String r2="";String tempreg="";

 //set below to elif and above added to handle parameter cases 4/6^
 if(registers.containsValue(Integer.parseInt($1)) && registers.containsValue(Integer.parseInt($3))){
    for(String k:registers.keySet()){
        if(registers.get(k)==Integer.parseInt($1)){
            r1=k;//dest register
        }
        else if(registers.get(k)==Integer.parseInt($3)){
            r2=k;//src register
        }
        if(!r1.equals("") && !r2.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
    }
    int result=0;
    if($$.equals("true")){
        result = 1;
    }
    try{
        FileWriter w = new FileWriter(outputname,true);
        w.write("\tcmpl "+r2+", "+r1+"\n");//r1 is the destination
        w.write("\tsetne %al\n");
        //destination cases:
        if(r1.equals("%ebx")){
            w.write("\tmovzbq %al,%rbx\n");
            registers.replace("%ebx",result);//update appropriate register with result of booleans
        }
        else if(r1.equals("%ebp")){
            w.write("\tmovzbq %al,%rbp\n");
            registers.replace("%ebp",result);
        }
        else{
            String t = r1.substring(0,4);
            w.write("\tmovzbq %al,"+t+"\n");
            registers.replace(r1,result);
        }
        w.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR <>");
    }
 }} //use String.valueOf(boolean) to convert boolean to string
 | exp LT exp   {/*$$=$1<$3; System.out.println($3);*/ if(!isNumeric($1) || !isNumeric($3)){if(!lexer.params.contains($1)&&!isNumeric($1)){yyerror("Less than operator expects integers");}else if(!lexer.params.contains($3)&&!isNumeric($3)){yyerror("Less than operator expects integers");}/*yyerror("Less than operator expects integers");*/}else{$$=String.valueOf(Integer.parseInt($1)<Integer.parseInt($3));}
 String r1="";String r2="";String tempreg="";
 if(prm.contains($1) || prm.contains($3)){//added 4/6 to handle parameter cases like in if1.my
    //if there are parameters present, maybe for boolean comparisons hard set the code to use r11d for saving result of (operations) p-op
    //cover cases for if $1 is a parameter and $3 isn't, $1 is not and $3 is parameter, both are parameters
    if(prm.contains($1) && isNumeric($3)){//parameter case but also global/local var case
        $$="p-op";//FINISH THESE CASES
        int x1 = prm.indexOf($1);
        if(x1==0){
            r1 = "%edi";
        }
        else if(x1==1){
            r1 = "%esi";
        }
        else if(x1==2){
            r1 = "%edx";
        }
        else if(x1==3){
            r1 = "%ecx";
        }
        else if(x1==4){
            r1= "%r8d"; // up to 5 args
        }
        for(String k:registers.keySet()){ //get the numeric register

        if(registers.get(k)==Integer.parseInt($3)){
            r2=k;//the numeric register
        }
        if( !r2.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
        }
        ///tempreg = nextAvailReg(2147483647);//maximum integer value
        ///if(tempreg.equals("") || tempreg.equals(r2)){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                if(!k.equals(r2) && registers.get(k)==-2147483648){//don't override the previous register that was found with the numeric value
                tempreg=k;
                //freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
            if(tempreg.equals("")){
                //when no avail register is found then just free one that isn't r2
                for(String k :registers.keySet()){
                    if(!k.equals(r2)){
                        freeReg(k);
                        tempreg = k;
                        registers.replace(k,2147483647);
                        break;
                    }
                }
            }
        ///}
        //now take cmpl $3,$1
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n");
            mySFile.write("\tsetl %al\n");
            if(tempreg.equals("%ebx")){
                mySFile.write("\tmovzbq %al,%rbx\n");
                //registers.replace("%ebx",result);//update appropriate register with result of booleans
                registers.replace("%ebx",2147483647);//special value to signify a p-op
            }
            else if(tempreg.equals("%ebp")){
                mySFile.write("\tmovzbq %al,%rbp\n");
                //registers.replace("%ebp",result);
                registers.replace("%ebp",2147483647);
            }
            else{
                String t = tempreg.substring(0,4);
                mySFile.write("\tmovzbq %al,"+t+"\n");
                //registers.replace(r1,result);
                registers.replace(tempreg,2147483647);
            }
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH < with params");
        }
    }
    else if(prm.contains($3) && isNumeric($1)){
        $$="p-op";//second case where $1 is numeric and $3 is a parameter
        int x2 = prm.indexOf($3);
        if(x2==0){
            r2 = "%edi";
        }
        else if(x2==1){
            r2 = "%esi";
        }
        else if(x2==2){
            r2 = "%edx";
        }
        else if(x2==3){
            r2 = "%ecx";
        }
        else if(x2==4){
            r2= "%r8d"; // up to 5 args
        }
        for(String k:registers.keySet()){ //get the numeric register

        if(registers.get(k)==Integer.parseInt($1)){
            r1=k;//the numeric register
        }
        if( !r1.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
        }
        /*old : tempreg = nextAvailReg(2147483647);//maximum integer value
        if(tempreg.equals("") || tempreg.equals(r1)){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                if(!k.equals(r1)){//don't override the previous register that was found with the numeric value
                tempreg=k;
                freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
        }*/
        for(String k:registers.keySet()){ //get a register to use for tempreg
                if(!k.equals(r2) && registers.get(k)==-2147483648){//don't override the previous register that was found with the numeric value
                tempreg=k;
                //freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
            if(tempreg.equals("")){
                //when no avail register is found then just free one that isn't r2 and set that as tempreg
                for(String k :registers.keySet()){
                    if(!k.equals(r2)){
                        freeReg(k);
                        tempreg = k;
                        registers.replace(k,2147483647);
                        break;
                    }
                }
            }
        //now take cmpl $3,$1 (ex. $1>=$3)
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n"); //always do r2 then r1 because the comparison will be r1>=r2
            mySFile.write("\tsetl %al\n");
            if(tempreg.equals("%ebx")){
                mySFile.write("\tmovzbq %al,%rbx\n");
                //registers.replace("%ebx",result);//update appropriate register with result of booleans
                registers.replace("%ebx",2147483647);//special value to signify a p-op
            }
            else if(tempreg.equals("%ebp")){
                mySFile.write("\tmovzbq %al,%rbp\n");
                //registers.replace("%ebp",result);
                registers.replace("%ebp",2147483647);
            }
            else{
                String t = tempreg.substring(0,4);
                mySFile.write("\tmovzbq %al,"+t+"\n");
                //registers.replace(r1,result);
                registers.replace(tempreg,2147483647);
            }
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH < with params");
        }
    }
    else if (prm.contains($1)&& prm.contains($3)){
        //both are parameter case
        int x1=prm.indexOf($1);int x2=prm.indexOf($3);
        if(x1==0){
            r1 = "%edi";
        }
        else if(x1==1){
            r1 = "%esi";
        }
        else if(x1==2){
            r1 = "%edx";
        }
        else if(x1==3){
            r1 = "%ecx";
        }
        else if(x1==4){
            r1= "%r8d"; // up to 5 args
        }
        if(x2==0){
            r2 = "%edi";
        }
        else if(x2==1){
            r2 = "%esi";
        }
        else if(x2==2){
            r2 = "%edx";
        }
        else if(x2==3){
            r2 = "%ecx";
        }
        else if(x2==4){
            r2= "%r8d"; // up to 5 args
        }
        //compl $3,$1 and setge %al and movzbq %al,%reg
        tempreg = nextAvailReg(2147483647);//maximum integer value
        if(tempreg.equals("")){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                tempreg=k;
                freeReg(k);
                registers.replace(k,2147483647);
                break;
            }
        }
        $$="p-op";
        try{
            FileWriter mySFile = new FileWriter (outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n");
            mySFile.write("\tsetl %al\n");
            //destination cases:
        if(tempreg.equals("%ebx")){
            mySFile.write("\tmovzbq %al,%rbx\n");
            //registers.replace("%ebx",result);//update appropriate register with result of booleans
            registers.replace("%ebx",2147483647);//special value to signify a p-op
        }
        else if(tempreg.equals("%ebp")){
            mySFile.write("\tmovzbq %al,%rbp\n");
            //registers.replace("%ebp",result);
            registers.replace("%ebp",2147483647);
        }
        else{
            String t = tempreg.substring(0,4);
            mySFile.write("\tmovzbq %al,"+t+"\n");
            //registers.replace(r1,result);
            registers.replace(tempreg,2147483647);
        }
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR < param case");
        }
    }
 }
 //make if into elif below and new code added above 4/6^
 else if(registers.containsValue(Integer.parseInt($1)) && registers.containsValue(Integer.parseInt($3))){
    for(String k:registers.keySet()){
        if(registers.get(k)==Integer.parseInt($1)){
            r1=k;//dest register
        }
        else if(registers.get(k)==Integer.parseInt($3)){
            r2=k;//src register
        }
        if(!r1.equals("") && !r2.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
    }
    int result=0;
    if($$.equals("true")){
        result = 1;
    }
    try{
        FileWriter w = new FileWriter(outputname,true);
        w.write("\tcmpl "+r2+", "+r1+"\n");//r1 is the destination
        w.write("\tsetl %al\n");
        //destination cases:
        if(r1.equals("%ebx")){
            w.write("\tmovzbq %al,%rbx\n");
            registers.replace("%ebx",result);//update appropriate register with result of booleans
        }
        else if(r1.equals("%ebp")){
            w.write("\tmovzbq %al,%rbp\n");
            registers.replace("%ebp",result);
        }
        else{
            String t = r1.substring(0,4);
            w.write("\tmovzbq %al,"+t+"\n");
            registers.replace(r1,result);
        }
        w.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR <");
    }
 }
 }
 | exp LE exp   {/*$$=$1<=$3;*/if(!isNumeric($1) || !isNumeric($3)){if(!lexer.params.contains($1)&&!isNumeric($1)){yyerror("Less than or equal to operator expects integers");}else if(!lexer.params.contains($3)&&!isNumeric($3)){yyerror("Less than or equal to operator expects integers");}}else{$$=String.valueOf(Integer.parseInt($1)<=Integer.parseInt($3));}
 String r1="";String r2="";String tempreg="";
 if(prm.contains($1) || prm.contains($3)){//added 4/6 to handle parameter cases like in if1.my
    //if there are parameters present, maybe for boolean comparisons hard set the code to use r11d for saving result of (operations) p-op
    //cover cases for if $1 is a parameter and $3 isn't, $1 is not and $3 is parameter, both are parameters
    if(prm.contains($1) && isNumeric($3)){//parameter case but also global/local var case
        $$="p-op";//FINISH THESE CASES
        int x1 = prm.indexOf($1);
        if(x1==0){
            r1 = "%edi";
        }
        else if(x1==1){
            r1 = "%esi";
        }
        else if(x1==2){
            r1 = "%edx";
        }
        else if(x1==3){
            r1 = "%ecx";
        }
        else if(x1==4){
            r1= "%r8d"; // up to 5 args
        }
        for(String k:registers.keySet()){ //get the numeric register

        if(registers.get(k)==Integer.parseInt($3)){
            r2=k;//the numeric register
        }
        if( !r2.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
        }
        ///tempreg = nextAvailReg(2147483647);//maximum integer value
        ///if(tempreg.equals("") || tempreg.equals(r2)){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                if(!k.equals(r2) && registers.get(k)==-2147483648){//don't override the previous register that was found with the numeric value
                tempreg=k;
                //freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
            if(tempreg.equals("")){
                //when no avail register is found then just free one that isn't r2
                for(String k :registers.keySet()){
                    if(!k.equals(r2)){
                        freeReg(k);
                        tempreg = k;
                        registers.replace(k,2147483647);
                        break;
                    }
                }
            }
        ///}
        //now take cmpl $3,$1
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n");
            mySFile.write("\tsetle %al\n");
            if(tempreg.equals("%ebx")){
                mySFile.write("\tmovzbq %al,%rbx\n");
                //registers.replace("%ebx",result);//update appropriate register with result of booleans
                registers.replace("%ebx",2147483647);//special value to signify a p-op
            }
            else if(tempreg.equals("%ebp")){
                mySFile.write("\tmovzbq %al,%rbp\n");
                //registers.replace("%ebp",result);
                registers.replace("%ebp",2147483647);
            }
            else{
                String t = tempreg.substring(0,4);
                mySFile.write("\tmovzbq %al,"+t+"\n");
                //registers.replace(r1,result);
                registers.replace(tempreg,2147483647);
            }
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH <= with params");
        }
    }
    else if(prm.contains($3) && isNumeric($1)){
        $$="p-op";//second case where $1 is numeric and $3 is a parameter
        int x2 = prm.indexOf($3);
        if(x2==0){
            r2 = "%edi";
        }
        else if(x2==1){
            r2 = "%esi";
        }
        else if(x2==2){
            r2 = "%edx";
        }
        else if(x2==3){
            r2 = "%ecx";
        }
        else if(x2==4){
            r2= "%r8d"; // up to 5 args
        }
        for(String k:registers.keySet()){ //get the numeric register

        if(registers.get(k)==Integer.parseInt($1)){
            r1=k;//the numeric register
        }
        if( !r1.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
        }
        /*old : tempreg = nextAvailReg(2147483647);//maximum integer value
        if(tempreg.equals("") || tempreg.equals(r1)){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                if(!k.equals(r1)){//don't override the previous register that was found with the numeric value
                tempreg=k;
                freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
        }*/
        for(String k:registers.keySet()){ //get a register to use for tempreg
                if(!k.equals(r2) && registers.get(k)==-2147483648){//don't override the previous register that was found with the numeric value
                tempreg=k;
                //freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
            if(tempreg.equals("")){
                //when no avail register is found then just free one that isn't r2 and set that as tempreg
                for(String k :registers.keySet()){
                    if(!k.equals(r2)){
                        freeReg(k);
                        tempreg = k;
                        registers.replace(k,2147483647);
                        break;
                    }
                }
            }
        //now take cmpl $3,$1 (ex. $1>=$3)
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n"); //always do r2 then r1 because the comparison will be r1>=r2
            mySFile.write("\tsetle %al\n");
            if(tempreg.equals("%ebx")){
                mySFile.write("\tmovzbq %al,%rbx\n");
                //registers.replace("%ebx",result);//update appropriate register with result of booleans
                registers.replace("%ebx",2147483647);//special value to signify a p-op
            }
            else if(tempreg.equals("%ebp")){
                mySFile.write("\tmovzbq %al,%rbp\n");
                //registers.replace("%ebp",result);
                registers.replace("%ebp",2147483647);
            }
            else{
                String t = tempreg.substring(0,4);
                mySFile.write("\tmovzbq %al,"+t+"\n");
                //registers.replace(r1,result);
                registers.replace(tempreg,2147483647);
            }
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH <= with params");
        }
    }
    else if (prm.contains($1)&& prm.contains($3)){
        //both are parameter case
        int x1=prm.indexOf($1);int x2=prm.indexOf($3);
        if(x1==0){
            r1 = "%edi";
        }
        else if(x1==1){
            r1 = "%esi";
        }
        else if(x1==2){
            r1 = "%edx";
        }
        else if(x1==3){
            r1 = "%ecx";
        }
        else if(x1==4){
            r1= "%r8d"; // up to 5 args
        }
        if(x2==0){
            r2 = "%edi";
        }
        else if(x2==1){
            r2 = "%esi";
        }
        else if(x2==2){
            r2 = "%edx";
        }
        else if(x2==3){
            r2 = "%ecx";
        }
        else if(x2==4){
            r2= "%r8d"; // up to 5 args
        }
        //compl $3,$1 and setge %al and movzbq %al,%reg
        tempreg = nextAvailReg(2147483647);//maximum integer value
        if(tempreg.equals("")){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                tempreg=k;
                freeReg(k);
                registers.replace(k,2147483647);
                break;
            }
        }
        $$="p-op";
        try{
            FileWriter mySFile = new FileWriter (outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n");
            mySFile.write("\tsetle %al\n");
            //destination cases:
        if(tempreg.equals("%ebx")){
            mySFile.write("\tmovzbq %al,%rbx\n");
            //registers.replace("%ebx",result);//update appropriate register with result of booleans
            registers.replace("%ebx",2147483647);//special value to signify a p-op
        }
        else if(tempreg.equals("%ebp")){
            mySFile.write("\tmovzbq %al,%rbp\n");
            //registers.replace("%ebp",result);
            registers.replace("%ebp",2147483647);
        }
        else{
            String t = tempreg.substring(0,4);
            mySFile.write("\tmovzbq %al,"+t+"\n");
            //registers.replace(r1,result);
            registers.replace(tempreg,2147483647);
        }
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR <= param case");
        }
    }
 }
 //below changed to elif, new added above ^ 4/6
 else if(registers.containsValue(Integer.parseInt($1)) && registers.containsValue(Integer.parseInt($3))){
    for(String k:registers.keySet()){
        if(registers.get(k)==Integer.parseInt($1)){
            r1=k;//dest register
        }
        else if(registers.get(k)==Integer.parseInt($3)){
            r2=k;//src register
        }
        if(!r1.equals("") && !r2.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
    }
    int result=0;
    if($$.equals("true")){
        result = 1;
    }
    try{
        FileWriter w = new FileWriter(outputname,true);
        w.write("\tcmpl "+r2+", "+r1+"\n");//r1 is the destination
        w.write("\tsetle %al\n");
        //destination cases:
        if(r1.equals("%ebx")){
            w.write("\tmovzbq %al,%rbx\n");
            registers.replace("%ebx",result);//update appropriate register with result of booleans
        }
        else if(r1.equals("%ebp")){
            w.write("\tmovzbq %al,%rbp\n");
            registers.replace("%ebp",result);
        }
        else{
            String t = r1.substring(0,4);
            w.write("\tmovzbq %al,"+t+"\n");
            registers.replace(r1,result);
        }
        w.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR <=");
    }
 }
 }
 | exp GT exp   {/*$$=String.valueOf(Integer.parseInt($1)>Integer.parseInt($3));$$=$1>$3;*/if(!isNumeric($1) || !isNumeric($3)){if(!lexer.params.contains($1)&&!isNumeric($1)){yyerror("Greater than operator expects integers");}else if(!lexer.params.contains($3)&&!isNumeric($3)){yyerror("Greater than operator expects integers");}}else{$$=String.valueOf(Integer.parseInt($1)>Integer.parseInt($3));}
 String r1="";String r2="";String tempreg="";
 if(prm.contains($1) || prm.contains($3)){//added 4/6 to handle parameter cases like in if1.my
    //if there are parameters present, maybe for boolean comparisons hard set the code to use r11d for saving result of (operations) p-op
    //cover cases for if $1 is a parameter and $3 isn't, $1 is not and $3 is parameter, both are parameters
    if(prm.contains($1) && isNumeric($3)){//parameter case but also global/local var case
        $$="p-op";//FINISH THESE CASES
        int x1 = prm.indexOf($1);
        if(x1==0){
            r1 = "%edi";
        }
        else if(x1==1){
            r1 = "%esi";
        }
        else if(x1==2){
            r1 = "%edx";
        }
        else if(x1==3){
            r1 = "%ecx";
        }
        else if(x1==4){
            r1= "%r8d"; // up to 5 args
        }
        for(String k:registers.keySet()){ //get the numeric register

        if(registers.get(k)==Integer.parseInt($3)){
            r2=k;//the numeric register
        }
        if( !r2.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
        }
        ///tempreg = nextAvailReg(2147483647);//maximum integer value
        ///if(tempreg.equals("") || tempreg.equals(r2)){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                if(!k.equals(r2) && registers.get(k)==-2147483648){//don't override the previous register that was found with the numeric value
                tempreg=k;
                //freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
            if(tempreg.equals("")){
                //when no avail register is found then just free one that isn't r2
                for(String k :registers.keySet()){
                    if(!k.equals(r2)){
                        freeReg(k);
                        tempreg = k;
                        registers.replace(k,2147483647);
                        break;
                    }
                }
            }
        ///}
        //now take cmpl $3,$1
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n");
            mySFile.write("\tsetg %al\n");
            if(tempreg.equals("%ebx")){
                mySFile.write("\tmovzbq %al,%rbx\n");
                //registers.replace("%ebx",result);//update appropriate register with result of booleans
                registers.replace("%ebx",2147483647);//special value to signify a p-op
            }
            else if(tempreg.equals("%ebp")){
                mySFile.write("\tmovzbq %al,%rbp\n");
                //registers.replace("%ebp",result);
                registers.replace("%ebp",2147483647);
            }
            else{
                String t = tempreg.substring(0,4);
                mySFile.write("\tmovzbq %al,"+t+"\n");
                //registers.replace(r1,result);
                registers.replace(tempreg,2147483647);
            }
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH > with params");
        }
    }
    else if(prm.contains($3) && isNumeric($1)){
        $$="p-op";//second case where $1 is numeric and $3 is a parameter
        int x2 = prm.indexOf($3);
        if(x2==0){
            r2 = "%edi";
        }
        else if(x2==1){
            r2 = "%esi";
        }
        else if(x2==2){
            r2 = "%edx";
        }
        else if(x2==3){
            r2 = "%ecx";
        }
        else if(x2==4){
            r2= "%r8d"; // up to 5 args
        }
        for(String k:registers.keySet()){ //get the numeric register

        if(registers.get(k)==Integer.parseInt($1)){
            r1=k;//the numeric register
        }
        if( !r1.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
        }
        /*old : tempreg = nextAvailReg(2147483647);//maximum integer value
        if(tempreg.equals("") || tempreg.equals(r1)){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                if(!k.equals(r1)){//don't override the previous register that was found with the numeric value
                tempreg=k;
                freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
        }*/
        for(String k:registers.keySet()){ //get a register to use for tempreg
                if(!k.equals(r2) && registers.get(k)==-2147483648){//don't override the previous register that was found with the numeric value
                tempreg=k;
                //freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
            if(tempreg.equals("")){
                //when no avail register is found then just free one that isn't r2 and set that as tempreg
                for(String k :registers.keySet()){
                    if(!k.equals(r2)){
                        freeReg(k);
                        tempreg = k;
                        registers.replace(k,2147483647);
                        break;
                    }
                }
            }
        //now take cmpl $3,$1 (ex. $1>=$3)
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n"); //always do r2 then r1 because the comparison will be r1>=r2
            mySFile.write("\tsetg %al\n");
            if(tempreg.equals("%ebx")){
                mySFile.write("\tmovzbq %al,%rbx\n");
                //registers.replace("%ebx",result);//update appropriate register with result of booleans
                registers.replace("%ebx",2147483647);//special value to signify a p-op
            }
            else if(tempreg.equals("%ebp")){
                mySFile.write("\tmovzbq %al,%rbp\n");
                //registers.replace("%ebp",result);
                registers.replace("%ebp",2147483647);
            }
            else{
                String t = tempreg.substring(0,4);
                mySFile.write("\tmovzbq %al,"+t+"\n");
                //registers.replace(r1,result);
                registers.replace(tempreg,2147483647);
            }
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH > with params");
        }
    }
    else if (prm.contains($1)&& prm.contains($3)){
        //both are parameter case
        int x1=prm.indexOf($1);int x2=prm.indexOf($3);
        if(x1==0){
            r1 = "%edi";
        }
        else if(x1==1){
            r1 = "%esi";
        }
        else if(x1==2){
            r1 = "%edx";
        }
        else if(x1==3){
            r1 = "%ecx";
        }
        else if(x1==4){
            r1= "%r8d"; // up to 5 args
        }
        if(x2==0){
            r2 = "%edi";
        }
        else if(x2==1){
            r2 = "%esi";
        }
        else if(x2==2){
            r2 = "%edx";
        }
        else if(x2==3){
            r2 = "%ecx";
        }
        else if(x2==4){
            r2= "%r8d"; // up to 5 args
        }
        //compl $3,$1 and setge %al and movzbq %al,%reg
        tempreg = nextAvailReg(2147483647);//maximum integer value
        if(tempreg.equals("")){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                tempreg=k;
                freeReg(k);
                registers.replace(k,2147483647);
                break;
            }
        }
        $$="p-op";
        try{
            FileWriter mySFile = new FileWriter (outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n");
            mySFile.write("\tsetg %al\n");
            //destination cases:
        if(tempreg.equals("%ebx")){
            mySFile.write("\tmovzbq %al,%rbx\n");
            //registers.replace("%ebx",result);//update appropriate register with result of booleans
            registers.replace("%ebx",2147483647);//special value to signify a p-op
        }
        else if(tempreg.equals("%ebp")){
            mySFile.write("\tmovzbq %al,%rbp\n");
            //registers.replace("%ebp",result);
            registers.replace("%ebp",2147483647);
        }
        else{
            String t = tempreg.substring(0,4);
            mySFile.write("\tmovzbq %al,"+t+"\n");
            //registers.replace(r1,result);
            registers.replace(tempreg,2147483647);
        }
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR > param case");
        }
    }
 }
 //old code (from if to else if) below that performs the operation on int lit values that were stored within registers already
 else if(registers.containsValue(Integer.parseInt($1)) && registers.containsValue(Integer.parseInt($3))){
    for(String k:registers.keySet()){
        if(registers.get(k)==Integer.parseInt($1)){
            r1=k;//dest register
        }
        else if(registers.get(k)==Integer.parseInt($3)){
            r2=k;//src register
        }
        if(!r1.equals("") && !r2.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
    }
    int result=0;
    if($$.equals("true")){
        result = 1;
    }
    try{
        FileWriter w = new FileWriter(outputname,true);
        w.write("\tcmpl "+r2+", "+r1+"\n");//r1 is the destination
        w.write("\tsetg %al\n");
        //destination cases:
        if(r1.equals("%ebx")){
            w.write("\tmovzbq %al,%rbx\n");
            registers.replace("%ebx",result);//update appropriate register with result of booleans
        }
        else if(r1.equals("%ebp")){
            w.write("\tmovzbq %al,%rbp\n");
            registers.replace("%ebp",result);
        }
        else{
            String t = r1.substring(0,4);
            w.write("\tmovzbq %al,"+t+"\n");
            registers.replace(r1,result);
        }
        w.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR >");
    }
 }
 }
 | exp GE exp   {/*$$=$1>=$3;*/if(!isNumeric($1) || !isNumeric($3)){if(!lexer.params.contains($1)&&!isNumeric($1)){yyerror("Greater than or equal to operator expects integers");}else if(!lexer.params.contains($3)&&!isNumeric($3)){yyerror("Greater than or equal to operator expects integers");}}else{$$=String.valueOf(Integer.parseInt($1)>=Integer.parseInt($3));}
 String r1="";String r2="";String tempreg = "";
 if(prm.contains($1) || prm.contains($3)){
    //if there are parameters present, maybe for boolean comparisons hard set the code to use r11d for saving result of (operations) p-op
    //cover cases for if $1 is a parameter and $3 isn't, $1 is not and $3 is parameter, both are parameters
    if(prm.contains($1) && isNumeric($3)){//parameter case but also global/local var case
        $$="p-op";//FINISH THESE CASES
        int x1 = prm.indexOf($1);
        if(x1==0){
            r1 = "%edi";
        }
        else if(x1==1){
            r1 = "%esi";
        }
        else if(x1==2){
            r1 = "%edx";
        }
        else if(x1==3){
            r1 = "%ecx";
        }
        else if(x1==4){
            r1= "%r8d"; // up to 5 args
        }
        for(String k:registers.keySet()){ //get the numeric register

        if(registers.get(k)==Integer.parseInt($3)){
            r2=k;//the numeric register
        }
        if( !r2.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
        }
        ///tempreg = nextAvailReg(2147483647);//maximum integer value
        ///if(tempreg.equals("") || tempreg.equals(r2)){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                if(!k.equals(r2) && registers.get(k)==-2147483648){//don't override the previous register that was found with the numeric value
                tempreg=k;
                //freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
            if(tempreg.equals("")){
                //when no avail register is found then just free one that isn't r2
                for(String k :registers.keySet()){
                    if(!k.equals(r2)){
                        freeReg(k);
                        tempreg = k;
                        registers.replace(k,2147483647);
                        break;
                    }
                }
            }
        ///}
        //now take cmpl $3,$1
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n");
            mySFile.write("\tsetge %al\n");
            if(tempreg.equals("%ebx")){
                mySFile.write("\tmovzbq %al,%rbx\n");
                //registers.replace("%ebx",result);//update appropriate register with result of booleans
                registers.replace("%ebx",2147483647);//special value to signify a p-op
            }
            else if(tempreg.equals("%ebp")){
                mySFile.write("\tmovzbq %al,%rbp\n");
                //registers.replace("%ebp",result);
                registers.replace("%ebp",2147483647);
            }
            else{
                String t = tempreg.substring(0,4);
                mySFile.write("\tmovzbq %al,"+t+"\n");
                //registers.replace(r1,result);
                registers.replace(tempreg,2147483647);
            }
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH >= with params");
        }
    }
    else if(prm.contains($3) && isNumeric($1)){
        $$="p-op";//second case where $1 is numeric and $3 is a parameter
        int x2 = prm.indexOf($3);
        if(x2==0){
            r2 = "%edi";
        }
        else if(x2==1){
            r2 = "%esi";
        }
        else if(x2==2){
            r2 = "%edx";
        }
        else if(x2==3){
            r2 = "%ecx";
        }
        else if(x2==4){
            r2= "%r8d"; // up to 5 args
        }
        for(String k:registers.keySet()){ //get the numeric register

        if(registers.get(k)==Integer.parseInt($1)){
            r1=k;//the numeric register
        }
        if( !r1.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
        }
        /*old : tempreg = nextAvailReg(2147483647);//maximum integer value
        if(tempreg.equals("") || tempreg.equals(r1)){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                if(!k.equals(r1)){//don't override the previous register that was found with the numeric value
                tempreg=k;
                freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
        }*/
        for(String k:registers.keySet()){ //get a register to use for tempreg
                if(!k.equals(r2) && registers.get(k)==-2147483648){//don't override the previous register that was found with the numeric value
                tempreg=k;
                //freeReg(k);
                registers.replace(k,2147483647);
                break;
                }
            }
            if(tempreg.equals("")){
                //when no avail register is found then just free one that isn't r2 and set that as tempreg
                for(String k :registers.keySet()){
                    if(!k.equals(r2)){
                        freeReg(k);
                        tempreg = k;
                        registers.replace(k,2147483647);
                        break;
                    }
                }
            }
        //now take cmpl $3,$1 (ex. $1>=$3)
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n"); //always do r2 then r1 because the comparison will be r1>=r2
            mySFile.write("\tsetge %al\n");
            if(tempreg.equals("%ebx")){
                mySFile.write("\tmovzbq %al,%rbx\n");
                //registers.replace("%ebx",result);//update appropriate register with result of booleans
                registers.replace("%ebx",2147483647);//special value to signify a p-op
            }
            else if(tempreg.equals("%ebp")){
                mySFile.write("\tmovzbq %al,%rbp\n");
                //registers.replace("%ebp",result);
                registers.replace("%ebp",2147483647);
            }
            else{
                String t = tempreg.substring(0,4);
                mySFile.write("\tmovzbq %al,"+t+"\n");
                //registers.replace(r1,result);
                registers.replace(tempreg,2147483647);
            }
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH >= with params");
        }
    }
    else if (prm.contains($1)&& prm.contains($3)){
        //both are parameter case
        int x1=prm.indexOf($1);int x2=prm.indexOf($3);
        if(x1==0){
            r1 = "%edi";
        }
        else if(x1==1){
            r1 = "%esi";
        }
        else if(x1==2){
            r1 = "%edx";
        }
        else if(x1==3){
            r1 = "%ecx";
        }
        else if(x1==4){
            r1= "%r8d"; // up to 5 args
        }
        if(x2==0){
            r2 = "%edi";
        }
        else if(x2==1){
            r2 = "%esi";
        }
        else if(x2==2){
            r2 = "%edx";
        }
        else if(x2==3){
            r2 = "%ecx";
        }
        else if(x2==4){
            r2= "%r8d"; // up to 5 args
        }
        //compl $3,$1 and setge %al and movzbq %al,%reg
        tempreg = nextAvailReg(2147483647);//maximum integer value
        if(tempreg.equals("")){//in case no register is available then just find one and free it and set val to maximum positive integer
            for(String k:registers.keySet()){
                tempreg=k;
                freeReg(k);
                registers.replace(k,2147483647);
                break;
            }
        }
        $$="p-op";
        try{
            FileWriter mySFile = new FileWriter (outputname, true);
            mySFile.write("\tcmpl "+r2+", "+r1+"\n");
            mySFile.write("\tsetge %al\n");
            //destination cases:
        if(tempreg.equals("%ebx")){
            mySFile.write("\tmovzbq %al,%rbx\n");
            //registers.replace("%ebx",result);//update appropriate register with result of booleans
            registers.replace("%ebx",2147483647);//special value to signify a p-op
        }
        else if(tempreg.equals("%ebp")){
            mySFile.write("\tmovzbq %al,%rbp\n");
            //registers.replace("%ebp",result);
            registers.replace("%ebp",2147483647);
        }
        else{
            String t = tempreg.substring(0,4);
            mySFile.write("\tmovzbq %al,"+t+"\n");
            //registers.replace(r1,result);
            registers.replace(tempreg,2147483647);
        }
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR >= param case");
        }
    }
 }
 //could make below into an else if, the if block above was added 4/5 ^
 else if(registers.containsValue(Integer.parseInt($1)) && registers.containsValue(Integer.parseInt($3))){
    for(String k:registers.keySet()){
        if(registers.get(k)==Integer.parseInt($1)){
            r1=k;//dest register
        }
        else if(registers.get(k)==Integer.parseInt($3)){
            r2=k;//src register
        }
        if(!r1.equals("") && !r2.equals("")){
            break; //break out of search loop when both temp strings are nonempty
        }
    }
    int result=0;
    if($$.equals("true")){
        result = 1;//to determine the value to use in a call to replace for the registers hashmap
    }
    try{
        FileWriter w = new FileWriter(outputname,true);
        w.write("\tcmpl "+r2+", "+r1+"\n");//r1 is the destination
        w.write("\tsetge %al\n");
        //destination cases:
        if(r1.equals("%ebx")){
            w.write("\tmovzbq %al,%rbx\n");
            registers.replace("%ebx",result);//update appropriate register with result of booleans
        }
        else if(r1.equals("%ebp")){
            w.write("\tmovzbq %al,%rbp\n");
            registers.replace("%ebp",result);
        }
        else{
            String t = r1.substring(0,4);
            w.write("\tmovzbq %al,"+t+"\n");
            registers.replace(r1,result);
        }
        w.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR >=");
    }
 }
 }
 | exp AND exp  {/*$$=$1 && $3;*/if(isNumeric($1) || isNumeric($3)){if(lexer.params.contains($1)&&isNumeric($1)){yyerror("AND operator expects booleans");}else if(lexer.params.contains($3)&&isNumeric($3)){yyerror("AND operator expects booleans");}}else{$$=String.valueOf(Boolean.parseBoolean($1)&&Boolean.parseBoolean($3));}
 int v1=0; int v2=0;String src="";String dest="";
 if($1.equals("true")){
    v1=1;
 }
 if($3.equals("true")){
    v2=1;
 }
 int result=0;
    if($$.equals("true")){
        result = 1;//to determine the value to use in a call to replace for the registers hashmap
    }
 if($1.equals("p-op") || $3.equals("p-op")){
    $$="p-op"; //special value assigned to $$
    if($1.equals("p-op") && $3.equals("p-op")){
        //both param ops, search for two registers with max integer val
        for(String k : registers.keySet()){ //find two registers that were storing the exp information
            if(registers.get(k)==2147483647){
                src = k;
                break;
            }
        }
        for(String k : registers.keySet()){
            if(registers.get(k)==2147483647 && !k.equals(src)){
                dest = k;
                break;
            }
        }
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tand "+src+", "+dest+"\n");
            freeReg(src);
            registers.replace(dest,2147483647);
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR IN AND params");
        }
    }
    else if($1.equals("p-op") && $3.equals("true")){
        //$3 is true boolean case
        $$="p-op";
        for(String k : registers.keySet()){ //find two registers that were storing the exp information
            if(registers.get(k)==2147483647){
                src = k;
                break;
            }
            else if(registers.get(k)==1){
                dest = k;//represents the true
                break;
            }
        }
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tand "+src+", "+dest+"\n");
            freeReg(src);
            registers.replace(dest,2147483647);
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR IN AND params");
        }
    }
    else if($1.equals("p-op") && $3.equals("false")){
        //$3 is false boolean case
        $$="p-op";
        for(String k : registers.keySet()){ //find two registers that were storing the exp information
            if(registers.get(k)==2147483647){
                src = k;
                break;
            }
            else if(registers.get(k)==0){
                dest = k;//represents the false
                break;
            }
        }
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tand "+src+", "+dest+"\n");
            freeReg(src);
            registers.replace(dest,2147483647);
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR IN AND params");
        }
    }
    else if($1.equals("true") && $3.equals("p-op")){
        //$1 is true case
        $$="p-op";
        for(String k : registers.keySet()){ //find two registers that were storing the exp information
            if(registers.get(k)==2147483647){
                dest = k;
                break;
            }
            else if(registers.get(k)==1){
                src = k;//represents the true
                break;
            }
        }
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tand "+src+", "+dest+"\n");
            freeReg(src);
            registers.replace(dest,2147483647);
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR IN AND params");
        }
    }
    else if($1.equals("false") && $3.equals("p-op")){
        //$1 is false case
        $$="p-op";
        for(String k : registers.keySet()){ //find two registers that were storing the exp information
            if(registers.get(k)==2147483647){
                dest = k;//for $3
                break;
            }
            else if(registers.get(k)==0){
                src = k;//represents the false for $1
                break;
            }
        }
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tand "+src+", "+dest+"\n");
            freeReg(src);
            registers.replace(dest,2147483647);
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR IN AND params");
        }
    }
 }
 //can make the if below into else if
 else if(registers.containsValue(v1) && registers.containsValue(v2)){
    for(String k:registers.keySet()){ //look for registers with the values that are looking for, doesn't matter where, Just want the right values to get correct evaluation of operation
        if(registers.get(k)==v1 && src.equals("")){//evade matching reg
            src=k;
        }
        else if(registers.get(k)==v2 && !k.equals(src)){
            dest=k;
        }
        if(!src.equals("") && !dest.equals("")){
            break;
        }
    }
    try{
        //now write the and assembly instr
        //and update the value in the dest register for the Hashmap
        FileWriter w = new FileWriter(outputname, true);
        w.write("\tand "+src+", "+dest+"\n");
        w.close();
        registers.replace(dest,result);//update the record of the new value for destination
        freeReg(src);//can free the other register
    }
    catch(IOException e){
        System.out.println("WRITE ERROR IN AND OP");
    }
 }
 }//handles case of a id or parameter variable name that needs to be distinguished as numeric
 | exp OR exp   {/*$$=$1 || $3;*/if(isNumeric($1) || isNumeric($3)){if(lexer.params.contains($1)&&isNumeric($1)){yyerror("OR operator expects booleans");}else if(lexer.params.contains($3)&&isNumeric($3)){yyerror("OR operator expects booleans");}}else{$$=String.valueOf(Boolean.parseBoolean($1)||Boolean.parseBoolean($3));}
 int v1=0; int v2=0;String src="";String dest="";
 if($1.equals("true")){
    v1=1;
 }
 if($3.equals("true")){
    v2=1;
 }
 int result=0;
    if($$.equals("true")){
        result = 1;//to determine the value to use in a call to replace for the registers hashmap
    }
    if($1.equals("p-op") || $3.equals("p-op")){//added 4/8
    $$="p-op"; //special value assigned to $$
    if($1.equals("p-op") && $3.equals("p-op")){
        //both param ops, search for two registers with max integer val
        for(String k : registers.keySet()){ //find two registers that were storing the exp information
            if(registers.get(k)==2147483647){
                src = k;
                break;
            }
        }
        for(String k : registers.keySet()){
            if(registers.get(k)==2147483647 && !k.equals(src)){
                dest = k;
                break;
            }
        }
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tor "+src+", "+dest+"\n");
            freeReg(src);
            registers.replace(dest,2147483647);
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR IN OR params");
        }
    }
    else if($1.equals("p-op") && $3.equals("true")){
        //$3 is true boolean case
        $$="p-op";
        for(String k : registers.keySet()){ //find two registers that were storing the exp information
            if(registers.get(k)==2147483647){
                src = k;
                break;
            }
            else if(registers.get(k)==1){
                dest = k;//represents the true
                break;
            }
        }
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tor "+src+", "+dest+"\n");
            freeReg(src);
            registers.replace(dest,2147483647);
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR IN OR params");
        }
    }
    else if($1.equals("p-op") && $3.equals("false")){
        //$3 is false boolean case
        $$="p-op";
        for(String k : registers.keySet()){ //find two registers that were storing the exp information
            if(registers.get(k)==2147483647){
                src = k;
                break;
            }
            else if(registers.get(k)==0){
                dest = k;//represents the false
                break;
            }
        }
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tor "+src+", "+dest+"\n");
            freeReg(src);
            registers.replace(dest,2147483647);
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR IN OR params");
        }
    }
    else if($1.equals("true") && $3.equals("p-op")){
        //$1 is true case
        $$="p-op";
        for(String k : registers.keySet()){ //find two registers that were storing the exp information
            if(registers.get(k)==2147483647){
                dest = k;
                break;
            }
            else if(registers.get(k)==1){
                src = k;//represents the true
                break;
            }
        }
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tor "+src+", "+dest+"\n");
            freeReg(src);
            registers.replace(dest,2147483647);
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR IN OR params");
        }
    }
    else if($1.equals("false") && $3.equals("p-op")){
        //$1 is false case
        $$="p-op";
        for(String k : registers.keySet()){ //find two registers that were storing the exp information
            if(registers.get(k)==2147483647){
                dest = k;//for $3
                break;
            }
            else if(registers.get(k)==0){
                src = k;//represents the false for $1
                break;
            }
        }
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tor "+src+", "+dest+"\n");
            freeReg(src);
            registers.replace(dest,2147483647);
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR IN OR params");
        }
    }
 }
//make below into else if and copy pasted from AND above
 else if(registers.containsValue(v1) && registers.containsValue(v2)){
    for(String k:registers.keySet()){ //look for registers with the values that are looking for, doesn't matter where, Just want the right values to get correct evaluation of operation
        if(registers.get(k)==v1 && src.equals("")){//evade matching reg
            src=k;
        }
        else if(registers.get(k)==v2 && !k.equals(src)){
            dest=k;
        }
        if(!src.equals("") && !dest.equals("")){
            break;
        }
    }
    try{
        //now write the and assembly instr
        //and update the value in the dest register for the Hashmap
        FileWriter w = new FileWriter(outputname, true);
        w.write("\tor "+src+", "+dest+"\n");
        w.close();
        registers.replace(dest,result);//update the record of the new value for destination
        freeReg(src);//can free the other register
    }
    catch(IOException e){
        System.out.println("WRITE ERROR IN OR OP");
    }
 }
 }
 | NOT exp {/*exp.type := boolean;*/if(isNumeric($2) || lexer.params.contains($2) ){yyerror("NOT operator expects boolean");} else{$$=String.valueOf( !Boolean.parseBoolean($2) );}
 String d="";int v = -1;int result=0;
 if($2.equals("true")){
    v=1;
 }
 else if($2.equals("false")){
    v=0;//false case
 }
 if($$.equals("true")){
    result=1;
 }
 if(registers.containsValue(v)){
 for(String k:registers.keySet()){
    if(registers.get(k)==v){
        d=k;
        break;
    }
 }

 try{
    FileWriter w = new FileWriter(outputname,true);
    w.write("\tmovl $1,%eax\n");
    w.write("\txor %eax,"+d+"\n");//exclusive or will perform a not
    registers.replace(d,result);//update the value of the register in Hash
    w.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR IN NOT OP");
 }
 }
 }
 | exp PLUS exp {/*commented typechek out for now:if($1!=null && $3!=null && (!isNumeric($1)||!isNumeric($3)) ){if(!lexer.params.contains($1)&&!isNumeric($1)){yyerror("+ operator expects integers");}else if(!lexer.params.contains($3)&&!isNumeric($3)){yyerror("+ operator expects integers");} }  try{if($1!=null && $3!=null){$$=Integer.toString(Integer.parseInt($1)+Integer.parseInt($3));lexer.vals.add($$);}else{$$="00000";lexer.vals.add("00000");} }catch(NumberFormatException e){yyerror("+ operator expects integers");}*/
 /*$$=String.valueOf(Integer.parseInt($1)+Integer.parseInt($3));*/System.out.println("sum: "+$1+"+"+$3+"="+$$); String src="";String dest="";
 if(isNumeric($1) && isNumeric($3)){ //even with array accesses there is an optimization that simply gets the constant value result to place in the proper registers for return/print
 $$=String.valueOf(Integer.parseInt($1)+Integer.parseInt($3));
 for(String k:registers.keySet()){
    if(registers.get(k)==Integer.parseInt($1)){
        src=k;//get first register
        freeReg(k);//free the register that will be the source because we will store answer into dest register
        registers.replace(k,Integer.parseInt($1));//REMEMBER TO DO THIS
        break;
    }
 }
 for(String k:registers.keySet()){
    if(registers.get(k)==Integer.parseInt($3)){
        dest=k;//get first register
        freeReg(k);
        registers.replace(k,Integer.parseInt($$));//set destination register to the sum
        break;
    }
 }
 //register src being "" or dest being "", need to use available register (so load immediate value to avail reg) and then free the source one after this instruction
 if(src.equals("")){
    src = nextAvailReg(Integer.parseInt($1));
    try{
        FileWriter mySFile = new FileWriter(outputname,true);//append
        mySFile.write("\tmovl $"+$1+", "+src+"\n");
        freeReg(src);
        registers.replace(src,Integer.parseInt($1));//remember to update
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR loading values!");

    }
 }
 if(dest.equals("")){
        //printMap(registers);
    dest = nextAvailReg(Integer.parseInt($3));
    try{
        FileWriter mySFile = new FileWriter(outputname,true);//append
        mySFile.write("\tmovl $"+$3+", "+dest+"\n");
        freeReg(dest);
        registers.replace(dest,Integer.parseInt($3));
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR loading values!");

    }
 }
 try{
    FileWriter mySFile = new FileWriter(outputname,true);//append
    mySFile.write("\taddl "+src+", "+dest+"\n");
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR ADD!");

 }
 ///freeReg(src);//free the source
 }
 /*old code
 else if(!isNumeric($1) && !isNumeric($3)){//second case that covers multiplication of two parameters/local vars (within scope of function)
    $$="000";//FIX CASES, check if contained in prm then handle argument loading, else local var? if not_in_main==0 then just check symboltable because in main
    if($1.equals("p-op") && prm.contains($3)){
        //r10d holds the value of the result of $1 param operation
        int ind = prm.indexOf($3);
        $$="p-op";
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            switch(ind){
                case 0:
                mySFile.write("\taddl %edi, %r10d\n");
                break;
                case 1:
                    mySFile.write("\taddl %esi, %r10d\n");
                    break;
                case 2:
                    mySFile.write("\taddl %edx, %r10d\n");
                    break;
                case 3:
                    mySFile.write("\taddl %ecx, %r10d\n");
                    break;
                case 4:
                    mySFile.write("\taddl %r8d, %r10d\n");
                    break;
            }
            registers.replace("%r10d",-2147483647);//replace with max neg val +1
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH ADD OP");
        }
    }
 }
 else if(!isNumeric($1)&& isNumeric($3)){//first exp is a parameter case (within scope of function)
    $$="000";
 }
 else if(isNumeric($1) && !isNumeric($3)){//second exp is a parameter case (within scope of function)
    $$="000";
    System.out.println(prm.contains($3));
    System.out.println(lexer.params);//don't have to do the calculation just set up an argument register
 } */
  else if(!isNumeric($1) && !isNumeric($3)){//second case that covers multiplication of two parameters/local vars (within scope of function)
    $$="000";//FIX CASES, check if contained in prm then handle argument loading else local var? if not_in_main==0 then just check symboltable and function case
    String srce="";String des="";
    if(not_in_main==0){
        //first case handle stuff in main, so these non numeric tokens are identifiers for globals or a function call
        if(symbol_table.containsKey($1)){
            srce = "$"+symbol_table.get($1);
        }
        else if($1.equals("f-op")){
            //function call as exp
            $$="p-op";
            srce = "%eax";
        }
        else if($1.equals("p-op")){
            $$="p-op";
            srce = "%r10d";
        }
        if(symbol_table.containsKey($3)){
            des= "$"+symbol_table.get($3);
        }
        else if($3.equals("f-op")){
            $$ = "p-op";
            des = "%eax";
        }
        else if($3.equals("p-op")){
            $$="p-op";
            des = "%r10d";
        }
        //only case that results in legit value is both a $num case, every other kind of case you can perform the operation and move to r10d after
        if(srce.substring(0,1).equals("$") && des.substring(0,1).equals("$")){
            String tempor = nextAvailReg(Integer.parseInt(local_table.get($1))+ Integer.parseInt(local_table.get($3)) );
            if(tempor.equals("")){
                for(String k:registers.keySet()){
                    freeReg(k);
                    tempor = k;
                    registers.replace(tempor, Integer.parseInt(local_table.get($1))+Integer.parseInt(local_table.get($3)));
                    break;
                }
            }
            //after getting a register to use, move first item to tempor then perform math to store into tempor with the second item
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl "+srce+","+tempor+"\n");//do the math and auto move result to tempor reg
                mySFile.write("\taddl "+des+","+tempor+"\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC ADD");
            }
            $$=String.valueOf( Integer.parseInt(local_table.get($1))+ Integer.parseInt(local_table.get($3)) );
        }
        else{
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                ///mySFile.write("\taddl "+srce+","+des+"\n");
                ///mySFile.write("\tmovl "+des+", %r10d\n");//do the math and auto move result to r10d
                if(des.substring(0,1).equals("$")){
                    //save to srce instead and then move srce to r10d
                    mySFile.write("\taddl "+des+","+srce+"\n");
                    mySFile.write("\tmovl "+srce+", %r10d\n");//do the math and auto move result to r10d
                }
                else{
                mySFile.write("\taddl "+srce+","+des+"\n");
                mySFile.write("\tmovl "+des+", %r10d\n"); }
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC ADD");
            }
            $$="p-op";
        }
    }
    else if(not_in_main!=0){
        //within scope of a function or something
        if(local_table.containsKey($1) && !prm.contains($1)){ //added 4/11 : !prm.contains($1)
            srce = "$"+local_table.get($1);
        }
        else if($1.equals("f-op")){
            //function call as exp
            $$="p-op";
            srce = "%eax";
        }
        else if($1.equals("p-op")){
            $$="p-op";
            srce = "%r10d";
        }
        else if(prm.contains($1)){
            //$1 is a parameter
            $$="p-op";
            if(prm.indexOf($1)==0 ){
                srce = "%edi";
            }
            else if(prm.indexOf($1)==1){
                srce="%esi";
            }
            else if(prm.indexOf($1)==2){
                srce="%edx";
            }
            else if(prm.indexOf($1)==3){
                srce="%ecx";
            }
            else if(prm.indexOf($1)==4){
                srce="%r8d";
            }
        }
        if(local_table.containsKey($3) &&  !prm.contains($1)){
            des= "$"+local_table.get($3);
        }
        else if($3.equals("f-op")){
            $$ = "p-op";
            des = "%eax";
        }
        else if($3.equals("p-op")){
            $$="p-op";
            des = "%r10d";
        }
        else if(prm.contains($3)){
            $$="p-op";
            if(prm.indexOf($3)==0 ){
                des = "%edi";
            }
            else if(prm.indexOf($3)==1){
                des="%esi";
            }
            else if(prm.indexOf($3)==2){
                des="%edx";
            }
            else if(prm.indexOf($3)==3){
                des="%ecx";
            }
            else if(prm.indexOf($3)==4){
                des="%r8d";
            }
        }
        //handle different combinations like two variables, 1 variable and 1 function, 2 functions
        //only case that results in legit value is both a $num case, every other kind of case you can perform the operation and move to r10d after
        if(srce.substring(0,1).equals("$") && des.substring(0,1).equals("$")){
            String tempor = nextAvailReg(Integer.parseInt(local_table.get($1))+Integer.parseInt(local_table.get($3)) );
            if(tempor.equals("")){
                for(String k:registers.keySet()){
                    freeReg(k);
                    tempor = k;
                    registers.replace(tempor, Integer.parseInt(local_table.get($1))+Integer.parseInt(local_table.get($3)));
                    break;
                }
            }
            //after getting a register to use, move first item to tempor then perform math to store into tempor with the second item
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl "+srce+","+tempor+"\n");//do the math and auto move result to tempor reg
                mySFile.write("\taddl "+des+","+tempor+"\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC ADD");
            }
            $$=String.valueOf( Integer.parseInt(local_table.get($1))+ Integer.parseInt(local_table.get($3)) );
        }
        else{
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                //cover case in case des is a number (not a register) so need to instead save to srce
                if(des.substring(0,1).equals("$")){
                    //save to srce instead and then move srce to r10d
                    mySFile.write("\taddl "+des+","+srce+"\n");
                    mySFile.write("\tmovl "+srce+", %r10d\n");//do the math and auto move result to r10d
                }
                else{
                mySFile.write("\taddl "+srce+","+des+"\n");
                mySFile.write("\tmovl "+des+", %r10d\n"); }//do the math and auto move result to r10d
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC ADD");
            }
            $$="p-op";//auto set $$ to p-op because this means the operation was some sort of operation with parameters, identifiers, or functions with one of the previously listed items (functions alone are f-op
        }
    }
 }
 else if(!isNumeric($1)&& isNumeric($3)){//first exp is a parameter case (within scope of function)
    $$="000";
    //copy patsed code from else if below this one just swap instances of $3 with $1 instead:
    if($1.equals("p-op")){//this means that $3 was previously some math operation that consisted of a parameter already or a function call
        //r10d hard coded to store the result so just do imull num and r10d
        $$="p-op";//once a p-op always a p-op
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\taddl $"+$3+", %r10d\n");
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();
            //freeReg("%r10d");//don't use r10d for now so free it
            registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN ADD OP");
        }
    }
    else if(prm.contains($1) && not_in_main!=0){//a parameter and also in the scope of a something like a function or whatever
        int ind = prm.indexOf($1);//tells which parameter position
        $$="p-op";//stands for parameter operation
        if(ind == 0){
            //edi first argument, basically use math operation store into edi then movl from edi to an avail register(might have to free)
            //just use r10d to store the answer for operations that deal with parameters
            //System.out.println("IND IS ZERO");
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$3+", %edi\n");
                mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else if(ind==1){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$3+", %esi\n");
                mySFile.write("\tmovl %esi, %r10d\n");//esi is second argument register
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
        else if(ind ==2){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$3+", %edx\n");
                mySFile.write("\tmovl %edx, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
        else if(ind ==3){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$3+", %ecx\n");
                mySFile.write("\tmovl %ecx, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
        else if (ind==4){
            //5th argument position
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$3+", %r8d\n");
                mySFile.write("\tmovl %r8d, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
    }
    else if(not_in_main!=0 && !prm.contains($1)&& !lexer.functions.contains($1)){
        //not a parameter and not in main so this has to be a local variable use local_table to lookup value
        //local_table.get($1); can't be true or false, first get avail register
        $$ = String.valueOf(Integer.parseInt($3)+Integer.parseInt(local_table.get($1)) );
        //String reg = nextAvailReg(Integer.parseInt($$));
        String reg = "";
        //if(reg.equals("")){
            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($3)){
                    reg = k;
                    break;
                }
            }
        //}
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\taddl $"+local_table.get($1)+", "+reg+"\n");
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN ADD OP");
        }
    }
    else if(/*lexer.functions.contains($1)*/ $1.equals("f-op") && not_in_main!=0){
        //if lexer.functions.contains $1 contains the identifier that means this is a function call and must take the return value
        $$="p-op"; //must call the function use the return value in eax to perform the math then store the result in r10d manually
        //consider function calls with no params and function calls with params within a math operation
        /*ACTUALLY, handle this within the exp:ID() case...if(prm.get(lexer.functions.indexOf($3)).length==0){
            //function call with no parameter loading required
        }*/
        try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$3+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");//manually move product into r10d
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
    }
    else if(not_in_main==0){
        //within main, so just use symbol table or function call
        if(/*lexer.functions.contains($1)*/$1.equals("f-op") ){
            //function call case here, consider it a p-op case and move result to r10d
            $$="p-op";
            //that means the return value is in eax
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$3+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");
                mySFile.close();//p-op assume result stored in r10d
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
        else {
            //symbol table case here, cover cases for integers because you can't do math on boolean or a whole array but can do on elements of an array
            //symbol_table.get($3)
            $$=String.valueOf(Integer.parseInt($3)+Integer.parseInt(symbol_table.get($1)));
            String reg = "";

            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($3)){//since $1 was numeric meaning an int lit that means it had to have been saved in a register somewhere
                    reg = k;
                    break;
                }
            }
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+symbol_table.get($1)+", "+reg+"\n");
                //mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
    }
 }
 else if(isNumeric($1) && !isNumeric($3)){//second exp is a parameter case/identifier/function call (within scope of function check by checking prm and not_in_main)
    $$="000";//placeholder, can ignore
    if($3.equals("p-op")){//this means that $3 was previously some math operation that consisted of a parameter already or a function call
        //r10d hard coded to store the result so just do imull num and r10d
        $$="p-op";//once a p-op always a p-op
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\taddl $"+$1+", %r10d\n");
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();
            //freeReg("%r10d");//don't use r10d for now so free it
            registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN ADD OP");
        }
    }
    else if(prm.contains($3) && not_in_main!=0){//a parameter and also in the scope of a something like a function or whatever
        int ind = prm.indexOf($3);//tells which parameter position
        $$="p-op";//stands for parameter operation
        if(ind == 0){
            //edi first argument, basically use math operation store into edi then movl from edi to an avail register(might have to free)
            //just use r10d to store the answer for operations that deal with parameters
            //System.out.println("IND IS ZERO");
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$1+", %edi\n");
                mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
        else if(ind==1){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$1+", %esi\n");
                mySFile.write("\tmovl %esi, %r10d\n");//esi is second argument register
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
        else if(ind ==2){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$1+", %edx\n");
                mySFile.write("\tmovl %edx, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
        else if(ind ==3){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$1+", %ecx\n");
                mySFile.write("\tmovl %ecx, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
        else if (ind==4){
            //5th argument position
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$1+", %r8d\n");
                mySFile.write("\tmovl %r8d, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
    }
    else if(not_in_main!=0 && !prm.contains($3)&& !$3.equals("f-op")/* !lexer.functions.contains($3)*/){
        //not a parameter and not in main so this has to be a local variable use local_table to lookup value
        //local_table.get($3); can't be true or false, first get avail register
        $$ = String.valueOf(Integer.parseInt($1)+Integer.parseInt(local_table.get($3)) );
        //String reg = nextAvailReg(Integer.parseInt($$));
        String reg = "";
        //if(reg.equals("")){
            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($1)){
                    reg = k;
                    break;
                }
            }
        //}
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\taddl $"+local_table.get($3)+", "+reg+"\n");
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN ADD OP");
        }
    }
    else if( $3.equals("f-op") && not_in_main!=0){//function call within a function
        //if lexer.functions.contains $3 contains the identifier that means this is a function call and must take the return value
        $$="p-op"; //must call the function use the return value in eax to perform the math then store the result in r10d manually
        //consider function calls with no params and function calls with params within a math operation
        /*ACTUALLY, handle this within the exp:ID() case...if(prm.get(lexer.functions.indexOf($3)).length==0){
            //function call with no parameter loading required
        }*/
        try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$1+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");//manually move product into r10d
                mySFile.close();
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
    }
    else if(not_in_main==0){
        //within main, so just use symbol table or function call
        if(/*lexer.functions.contains($3)*/ $3.equals("f-op")){
            //function call case here, consider it a p-op case and move result to r10d
            $$="p-op";//just set to p-op meaning result will be in r10d
            //that means the return value is in eax
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+$1+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");
                mySFile.close();//p-op assume result stored in r10d
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
        else {
            //symbol table case here, cover cases for integers because you can't do math on boolean or a whole array but can do on elements of an array
            //symbol_table.get($3)
            $$=String.valueOf(Integer.parseInt($1)+Integer.parseInt(symbol_table.get($3)));
            String reg = "";

            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($1)){//since $1 was numeric meaning an int lit that means it had to have been saved in a register somewhere
                    reg = k;
                    break;
                }
            }
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\taddl $"+symbol_table.get($3)+", "+reg+"\n");
                //mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN ADD OP");
            }
        }
    }
    //System.out.println(prm.contains($3));
    //System.out.println(lexer.params);//don't have to do the calculation just set up an argument register
 }
 } //check $1 and $3 for isNumeric
 | exp MINUS exp    {/*$$=new ParserVal($1.ival-$3.ival); $$=Integer.toString(Integer.parseInt($1)-Integer.parseInt($3));*/ /*if($1!=null && $3!=null && (!isNumeric($1)||!isNumeric($3)) ){if(!lexer.params.contains($1)&&!isNumeric($1)){yyerror("- operator expects integers");}else if(!lexer.params.contains($3)&&!isNumeric($3)){yyerror("- operator expects integers");} }  try{if($1!=null && $3!=null){$$=Integer.toString(Integer.parseInt($1)-Integer.parseInt($3));lexer.vals.add($$);}else{$$="00000";lexer.vals.add("00000");} }catch(NumberFormatException e){yyerror("- operator expects integers");}*/
 /*$$=String.valueOf(Integer.parseInt($1)-Integer.parseInt($3));*/System.out.println("difference: "+$$); String src="";String dest="";
 if(isNumeric($1) && isNumeric($3)){
 $$=String.valueOf(Integer.parseInt($1)-Integer.parseInt($3));
 for(String k:registers.keySet()){
    if(registers.get(k)==Integer.parseInt($1)){
        src=k;//get first register
        ///freeReg(k);//free the register that will be the source because we will store answer into dest register
        registers.replace(k,Integer.parseInt($1));
        break;
    }
 }
 for(String k:registers.keySet()){
    if(registers.get(k)==Integer.parseInt($3)){
        dest=k;//get first register
        ///registers.replace(k,Integer.parseInt($$));//set destination register to the sum
        registers.replace(k,Integer.parseInt($3));
        break;
    }
 }
 //register src being "" or dest being "", need to use available register (so load immediate value to avail reg) and then free the source one after this instruction
 if(src.equals("")){
    src = nextAvailReg(Integer.parseInt($1));
    try{
        FileWriter mySFile = new FileWriter(outputname,true);//append
        mySFile.write("\tmovl $"+$1+", "+src+"\n");
        registers.replace(src,Integer.parseInt($1));//remember to update
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR loading values!");

    }
 }
 if(dest.equals("")){
    dest = nextAvailReg(Integer.parseInt($3));
    try{
        FileWriter mySFile = new FileWriter(outputname,true);//append
        mySFile.write("\tmovl $"+$3+", "+dest+"\n");
        registers.replace(dest,Integer.parseInt($3));//remember to update
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR loading values!");

    }
 }
 try{
    FileWriter mySFile = new FileWriter(outputname,true);//append
    if(registers.get(dest)-registers.get(src)==Integer.parseInt($$)){
        mySFile.write("\tsubl "+src+", "+dest+"\n");
        freeReg(src);
        registers.replace(dest,Integer.parseInt($$));
    }
    else{
        mySFile.write("\tsubl "+dest+", "+src+"\n");
        freeReg(dest);
        registers.replace(src,Integer.parseInt($$));
    }
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR SUBTRACTION!");

 }
 }
 /*old code
 else if(!isNumeric($1) && !isNumeric($3)){//second case that covers multiplication of two parameters/local vars (within scope of function)
    $$="000";//FIX CASES, check if contained in prm then handle argument loading else local var? if not_in_main==0 then just check symboltable

 }
 else if(!isNumeric($1)&& isNumeric($3)){//first exp is a parameter case (within scope of function)
    $$="000";
 }
 else if(isNumeric($1) && !isNumeric($3)){//second exp is a parameter case (within scope of function)
    $$="000";
    System.out.println(prm.contains($3));
    System.out.println(lexer.params);//don't have to do the calculation just set up an argument register
 }*/
  else if(!isNumeric($1) && !isNumeric($3)){//second case that covers multiplication of two parameters/local vars (within scope of function)
    $$="000";//FIX CASES, check if contained in prm then handle argument loading else local var? if not_in_main==0 then just check symboltable and function case
    String srce="";String des="";
    if(not_in_main==0){
        //first case handle stuff in main, so these non numeric tokens are identifiers for globals or a function call
        if(symbol_table.containsKey($1)){
            srce = "$"+symbol_table.get($1);
        }
        else if($1.equals("f-op")){
            //function call as exp
            $$="p-op";
            srce = "%eax";
        }
        else if($1.equals("p-op")){
            $$="p-op";
            srce = "%r10d";
        }
        if(symbol_table.containsKey($3)){
            des= "$"+symbol_table.get($3);
        }
        else if($3.equals("f-op")){
            $$ = "p-op";
            des = "%eax";
        }
        else if($3.equals("p-op")){
            $$="p-op";
            des = "%r10d";
        }
        //only case that results in legit value is both a $num case, every other kind of case you can perform the operation and move to r10d after
        if(srce.substring(0,1).equals("$") && des.substring(0,1).equals("$")){
            String tempor = nextAvailReg(Integer.parseInt(local_table.get($1))- Integer.parseInt(local_table.get($3)) );
            if(tempor.equals("")){
                for(String k:registers.keySet()){
                    freeReg(k);
                    tempor = k;
                    registers.replace(tempor, Integer.parseInt(local_table.get($1))-Integer.parseInt(local_table.get($3)));
                    break;
                }
            }
            //after getting a register to use, move first item to tempor then perform math to store into tempor with the second item
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl "+srce+","+tempor+"\n");//do the math and auto move result to tempor reg
                mySFile.write("\tsubl "+des+","+tempor+"\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC sub");
            }
            $$=String.valueOf( Integer.parseInt(local_table.get($1))- Integer.parseInt(local_table.get($3)) );
        }
        else{
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                //mySFile.write("\tsubl "+srce+","+des+"\n");
                if(des.substring(0,1).equals("$")){
                    //save to srce instead and then move srce to r10d
                    mySFile.write("\tsubl "+des+","+srce+"\n");//i don't think subtraction will have this issue
                    mySFile.write("\tmovl "+srce+", %r10d\n");//do the math and auto move result to r10d
                }else if(srce.substring(0,1).equals("$")){
                mySFile.write("\tsubl "+srce+","+des+"\n");//reverse the order for subtraction
                mySFile.write("\timull $-1,"+des+"\n");
                mySFile.write("\tmovl "+des+", %r10d\n");}//do the math and auto move result to r10d
                else{
                    //neither is constant
                    mySFile.write("\tsubl "+des+","+srce+"\n");//i don't think subtraction will have this issue
                    mySFile.write("\tmovl "+srce+", %r10d\n");//do the math and auto move result to r10d
                }
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC ADD");
            }
            $$="p-op";
        }
    }
    else if(not_in_main!=0){
        //within scope of a function or something
        if(local_table.containsKey($1) && !prm.contains($1)){
            srce = "$"+local_table.get($1);
        }
        else if($1.equals("f-op")){
            //function call as exp
            $$="p-op";
            srce = "%eax";
        }
        else if($1.equals("p-op")){
            $$="p-op";
            srce = "%r10d";
        }
        else if(prm.contains($1)){
            //$1 is a parameter
            $$="p-op";
            if(prm.indexOf($1)==0 ){
                srce = "%edi";
            }
            else if(prm.indexOf($1)==1){
                srce="%esi";
            }
            else if(prm.indexOf($1)==2){
                srce="%edx";
            }
            else if(prm.indexOf($1)==3){
                srce="%ecx";
            }
            else if(prm.indexOf($1)==4){
                srce="%r8d";
            }
        }
        if(local_table.containsKey($3) && !prm.contains($1)){
            des= "$"+local_table.get($3);
        }
        else if($3.equals("f-op")){
            $$ = "p-op";
            des = "%eax";
        }
        else if($3.equals("p-op")){
            $$="p-op";
            des = "%r10d";
        }
        else if(prm.contains($3)){
            $$="p-op";
            if(prm.indexOf($3)==0 ){
                des = "%edi";
            }
            else if(prm.indexOf($3)==1){
                des="%esi";
            }
            else if(prm.indexOf($3)==2){
                des="%edx";
            }
            else if(prm.indexOf($3)==3){
                des="%ecx";
            }
            else if(prm.indexOf($3)==4){
                des="%r8d";
            }
        }
        //handle different combinations like two variables, 1 variable and 1 function, 2 functions
        //only case that results in legit value is both a $num case, every other kind of case you can perform the operation and move to r10d after
        if(srce.substring(0,1).equals("$") && des.substring(0,1).equals("$")){
            String tempor = nextAvailReg(Integer.parseInt(local_table.get($1))-Integer.parseInt(local_table.get($3)) );
            if(tempor.equals("")){
                for(String k:registers.keySet()){
                    freeReg(k);
                    tempor = k;
                    registers.replace(tempor, Integer.parseInt(local_table.get($1))-Integer.parseInt(local_table.get($3)));
                    break;
                }
            }
            //after getting a register to use, move first item to tempor then perform math to store into tempor with the second item
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl "+srce+","+tempor+"\n");//do the math and auto move result to tempor reg
                mySFile.write("\tsubl "+des+","+tempor+"\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC sub");
            }
            $$=String.valueOf( Integer.parseInt(local_table.get($1))- Integer.parseInt(local_table.get($3)) );
        }
        else{
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                ///mySFile.write("\tsubl "+des+","+srce+"\n");//reverse the order in order to do $1-$3
                ///mySFile.write("\tmovl "+srce+", %r10d\n");//do the math and auto move result to r10d
                if(des.substring(0,1).equals("$")){
                    //save to srce instead and then move srce to r10d
                    mySFile.write("\tsubl "+des+","+srce+"\n");//i don't think subtraction will have this issue
                    mySFile.write("\tmovl "+srce+", %r10d\n");//do the math and auto move result to r10d
                }else if(srce.substring(0,1).equals("$")){
                mySFile.write("\tsubl "+srce+","+des+"\n");//reverse the order for subtraction
                mySFile.write("\timull $-1,"+des+"\n");
                mySFile.write("\tmovl "+des+", %r10d\n");}//do the math and auto move result to r10d
                else{
                    //neither is constant
                    mySFile.write("\tsubl "+des+","+srce+"\n");//i don't think subtraction will have this issue
                    mySFile.write("\tmovl "+srce+", %r10d\n");//do the math and auto move result to r10d
                }
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC sub");
            }
            $$="p-op";
        }
    }
 }
 else if(!isNumeric($1)&& isNumeric($3)){//first exp is a parameter case (within scope of function)
    $$="000";
    //copy patsed code from else if below this one just swap instances of $3 with $1 instead:
    if($1.equals("p-op")){//this means that $3 was previously some math operation that consisted of a parameter already or a function call
        //r10d hard coded to store the result so just do imull num and r10d
        $$="p-op";//once a p-op always a p-op
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\tsubl $"+$3+", %r10d\n");
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();
            //freeReg("%r10d");//don't use r10d for now so free it
            registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN sub OP");
        }
    }
    else if(prm.contains($1) && not_in_main!=0){//a parameter and also in the scope of a something like a function or whatever
        int ind = prm.indexOf($1);//tells which parameter position
        $$="p-op";//stands for parameter operation
        if(ind == 0){
            //edi first argument, basically use math operation store into edi then movl from edi to an avail register(might have to free)
            //just use r10d to store the answer for operations that deal with parameters
            //System.out.println("IND IS ZERO");
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$3+", %edi\n");
                mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN sub OP");
            }
        }
        else if(ind==1){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$3+", %esi\n");
                mySFile.write("\tmovl %esi, %r10d\n");//esi is second argument register
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN sub OP");
            }
        }
        else if(ind ==2){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$3+", %edx\n");
                mySFile.write("\tmovl %edx, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN sub OP");
            }
        }
        else if(ind ==3){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$3+", %ecx\n");
                mySFile.write("\tmovl %ecx, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN sub OP");
            }
        }
        else if (ind==4){
            //5th argument position
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$3+", %r8d\n");
                mySFile.write("\tmovl %r8d, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN sub OP");
            }
        }
    }
    else if(not_in_main!=0 && !prm.contains($1)&& !lexer.functions.contains($1)){
        //not a parameter and not in main so this has to be a local variable use local_table to lookup value
        //local_table.get($1); can't be true or false, first get avail register
        $$ = String.valueOf( Integer.parseInt(local_table.get($1))-Integer.parseInt($3) );
        //String reg = nextAvailReg(Integer.parseInt($$));
        String reg = "";
        //if(reg.equals("")){
            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($3)){
                    reg = k;
                    break;
                }
            }
        //}
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\tsubl $"+local_table.get($1)+", "+reg+"\n");//reorder for subtraction, well actually since operation is performed in the other way like $3-$1 then just flip the sign afterward
            mySFile.write("\timull $-1, "+reg+"\n");//flip the sign of the difference
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN sub OP");
        }
    }
    else if(/*lexer.functions.contains($1)*/ $1.equals("f-op") && not_in_main!=0){
        //if lexer.functions.contains $1 contains the identifier that means this is a function call and must take the return value
        $$="p-op"; //must call the function use the return value in eax to perform the math then store the result in r10d manually
        //consider function calls with no params and function calls with params within a math operation
        /*ACTUALLY, handle this within the exp:ID() case...if(prm.get(lexer.functions.indexOf($3)).length==0){
            //function call with no parameter loading required
        }*/
        try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$3+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");//manually move product into r10d
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN sub OP");
            }
    }
    else if(not_in_main==0){
        //within main, so just use symbol table or function call
        if(/*lexer.functions.contains($1)*/$1.equals("f-op") ){
            //function call case here, consider it a p-op case and move result to r10d
            $$="p-op";
            //that means the return value is in eax
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$3+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");
                mySFile.close();//p-op assume result stored in r10d
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN sub OP");
            }
        }
        else {
            //symbol table case here, cover cases for integers because you can't do math on boolean or a whole array but can do on elements of an array
            //symbol_table.get($3)
            $$=String.valueOf( Integer.parseInt(symbol_table.get($1))-Integer.parseInt($3));
            String reg = "";

            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($3)){//since $3 was numeric meaning an int lit that means it had to have been saved in a register somewhere
                    reg = k;
                    break;
                }
            }
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+symbol_table.get($1)+", "+reg+"\n");// since this is $3-$1 just flip the sign after
                mySFile.write("\timull $-1, "+reg+"\n");
                //mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN SUB OP");
            }
        }
    }
 }
 else if(isNumeric($1) && !isNumeric($3)){//second exp is a parameter case/identifier/function call (within scope of function check by checking prm and not_in_main)
    $$="000";//placeholder, can ignore
    if($3.equals("p-op")){//this means that $3 was previously some math operation that consisted of a parameter already or a function call
        //r10d hard coded to store the result so just do imull num and r10d
        $$="p-op";//once a p-op always a p-op
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\tsubl $"+$1+", %r10d\n");//this is doing $3=$3-$1 so flip the sign to get $1-$3
            mySFile.write("\timull $-1, %r10d\n");
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();
            //freeReg("%r10d");//don't use r10d for now so free it
            registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN sub OP");
        }
    }
    else if(prm.contains($3) && not_in_main!=0){//a parameter and also in the scope of a something like a function or whatever
        int ind = prm.indexOf($3);//tells which parameter position
        $$="p-op";//stands for parameter operation
        if(ind == 0){
            //edi first argument, basically use math operation store into edi then movl from edi to an avail register(might have to free)
            //just use r10d to store the answer for operations that deal with parameters
            //System.out.println("IND IS ZERO");
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$1+", %edi\n");
                mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.write("\timull $-1, %r10d\n");//flip sign for correct subtraction
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN SUB OP");
            }
        }
        else if(ind==1){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$1+", %esi\n");
                mySFile.write("\tmovl %esi, %r10d\n");//esi is second argument register
                mySFile.write("\timull $-1, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN SUB OP");
            }
        }
        else if(ind ==2){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$1+", %edx\n");
                mySFile.write("\tmovl %edx, %r10d\n");
                mySFile.write("\timull $-1, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN SUB OP");
            }
        }
        else if(ind ==3){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$1+", %ecx\n");
                mySFile.write("\tmovl %ecx, %r10d\n");
                mySFile.write("\timull $-1, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN SUB OP");
            }
        }
        else if (ind==4){
            //5th argument position
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$1+", %r8d\n");
                mySFile.write("\tmovl %r8d, %r10d\n");
                mySFile.write("\timull $-1, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN sub OP");
            }
        }
    }
    else if(not_in_main!=0 && !prm.contains($3)&& !$3.equals("f-op")/* !lexer.functions.contains($3)*/){
        //not a parameter and not in main so this has to be a local variable use local_table to lookup value
        //local_table.get($3); can't be true or false, first get avail register
        $$ = String.valueOf(Integer.parseInt($1)-Integer.parseInt(local_table.get($3)) );
        //String reg = nextAvailReg(Integer.parseInt($$));
        String reg = "";
        //if(reg.equals("")){
            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($1)){
                    reg = k;
                    break;
                }
            }
        //}
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\tsubl $"+local_table.get($3)+", "+reg+"\n"); //this is ok because it is $1=$1-$3
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN sub OP");
        }
    }
    else if( $3.equals("f-op") && not_in_main!=0){//function call within a function
        //if lexer.functions.contains $3 contains the identifier that means this is a function call and must take the return value
        $$="p-op"; //must call the function use the return value in eax to perform the math then store the result in r10d manually
        //consider function calls with no params and function calls with params within a math operation
        /*ACTUALLY, handle this within the exp:ID() case...if(prm.get(lexer.functions.indexOf($3)).length==0){
            //function call with no parameter loading required
        }*/
        try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$1+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");//manually move product into r10d
                mySFile.write("\timull $-1, %r10d\n");//flip sign
                mySFile.close();
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN SUB OP");
            }
    }
    else if(not_in_main==0){
        //within main, so just use symbol table or function call
        if(/*lexer.functions.contains($3)*/ $3.equals("f-op")){
            //function call case here, consider it a p-op case and move result to r10d
            $$="p-op";//just set to p-op meaning result will be in r10d
            //that means the return value is in eax
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+$1+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");
                mySFile.write("\timull $-1, %r10d\n");
                mySFile.close();//p-op assume result stored in r10d
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN sub OP");
            }
        }
        else {
            //symbol table case here, cover cases for integers because you can't do math on boolean or a whole array but can do on elements of an array
            //symbol_table.get($3)
            $$=String.valueOf(Integer.parseInt($1)-Integer.parseInt(symbol_table.get($3)));
            String reg = "";

            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($1)){//since $1 was numeric meaning an int lit that means it had to have been saved in a register somewhere
                    reg = k;
                    break;
                }
            }
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\tsubl $"+symbol_table.get($3)+", "+reg+"\n"); //$1=$1-$3
                //mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN SUB OP");
            }
        }
    }
    //System.out.println(prm.contains($3));
    //System.out.println(lexer.params);//don't have to do the calculation just set up an argument register
 }
 }
 | exp MULT exp {/*$$=new ParserVal($1.ival*$3.ival);  $$=$1*$3;$$=Integer.toString(Integer.parseInt($1)*Integer.parseInt($3));*/ /*if($1!=null && $3!=null && (!isNumeric($1)||!isNumeric($3)) ){if(!lexer.params.contains($1)&&!isNumeric($1)){yyerror("* operator expects integers");}else if(!lexer.params.contains($3)&&!isNumeric($3)){yyerror("* operator expects integers");} }  try{if($1!=null && $3!=null){$$=Integer.toString(Integer.parseInt($1)*Integer.parseInt($3));lexer.vals.add($$);}else{$$="00000";lexer.vals.add("00000");} }catch(NumberFormatException e){yyerror("* operator expects integers");}*/
 /*$$=String.valueOf(Integer.parseInt($1)*Integer.parseInt($3));*/System.out.println("product: "+$1+"*"+$3+"="+$$); String src="";String dest="";
 //cover cases where 1. both exp are numeric, 2. both exp are identifiers, 3. first exp is numeric only, 4. second exp is numeric only
 if(isNumeric($1) && isNumeric($3)){//first case that covers no parameter/identifier case (within main scope or within a function)
 $$=String.valueOf(Integer.parseInt($1)*Integer.parseInt($3));
 for(String k:registers.keySet()){
    if(registers.get(k)==Integer.parseInt($1)){
        src=k;//get first register
        freeReg(k);//free the register that will be the source because we will store answer into dest register
        registers.replace(k,Integer.parseInt($1));
        break;
    }
 }
 for(String k:registers.keySet()){
    if(registers.get(k)==Integer.parseInt($3)){
        dest=k;//get first register
        freeReg(k);
        registers.replace(k,Integer.parseInt($$));//set destination register to the sum
        break;
    }
 }
 //register src being "" or dest being "", need to use available register (so load immediate value to avail reg) and then free the source one after this instruction
 if(src.equals("")){
    src = nextAvailReg(Integer.parseInt($1));
    try{
        FileWriter mySFile = new FileWriter(outputname,true);//append
        mySFile.write("\tmovl $"+$1+", "+src+"\n");
        registers.replace(src,Integer.parseInt($1));//remember to update
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR loading values!");

    }
 }
 if(dest.equals("")){
    dest = nextAvailReg(Integer.parseInt($3));
    try{
        FileWriter mySFile = new FileWriter(outputname,true);//append
        mySFile.write("\tmovl $"+$3+", "+dest+"\n");
        registers.replace(dest,Integer.parseInt($3));//remember to update
        mySFile.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR FOR loading values!");

    }
 }
 try{
    FileWriter mySFile = new FileWriter(outputname,true);//append
    mySFile.write("\timull "+src+", "+dest+"\n");
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR MULTIPLY!");

 }
 freeReg(src);
 }
 else if(!isNumeric($1) && !isNumeric($3)){//second case that covers multiplication of two parameters/local vars (within scope of function)
    $$="000";//FIX CASES, check if contained in prm then handle argument loading else local var? if not_in_main==0 then just check symboltable and function case
    String srce="";String des="";
    if(not_in_main==0){
        //first case handle stuff in main, so these non numeric tokens are identifiers for globals or a function call
        if(symbol_table.containsKey($1) && !prm.contains($1)){
            srce = "$"+symbol_table.get($1);
        }
        else if($1.equals("f-op")){
            //function call as exp
            $$="p-op";
            srce = "%eax";
        }
        else if($1.equals("p-op")){
            $$="p-op";
            srce = "%r10d";
        }
        if(symbol_table.containsKey($3) && !prm.contains($1)){
            des= "$"+symbol_table.get($3);
        }
        else if($3.equals("f-op")){
            $$ = "p-op";
            des = "%eax";
        }
        else if($3.equals("p-op")){
            $$="p-op";
            des = "%r10d";
        }
        //only case that results in legit value is both a $num case, every other kind of case you can perform the operation and move to r10d after
        if(srce.substring(0,1).equals("$") && des.substring(0,1).equals("$")){
            String tempor = nextAvailReg(Integer.parseInt(local_table.get($1))* Integer.parseInt(local_table.get($3)) );
            if(tempor.equals("")){
                for(String k:registers.keySet()){
                    freeReg(k);
                    tempor = k;
                    registers.replace(tempor, Integer.parseInt(local_table.get($1))*Integer.parseInt(local_table.get($3)));
                    break;
                }
            }
            //after getting a register to use, move first item to tempor then perform math to store into tempor with the second item
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl "+srce+","+tempor+"\n");//do the math and auto move result to tempor reg
                mySFile.write("\timull "+des+","+tempor+"\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC MULT");
            }
            $$=String.valueOf( Integer.parseInt(local_table.get($1))* Integer.parseInt(local_table.get($3)) );
        }
        else{
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                ///mySFile.write("\timull "+srce+","+des+"\n");
                ///mySFile.write("\tmovl "+des+", %r10d\n");//do the math and auto move result to r10d
                if(des.substring(0,1).equals("$")){
                    //save to srce instead and then move srce to r10d
                    mySFile.write("\timull "+des+","+srce+"\n");
                    mySFile.write("\tmovl "+srce+", %r10d\n");//do the math and auto move result to r10d
                }
                else{
                mySFile.write("\timull "+srce+","+des+"\n");
                mySFile.write("\tmovl "+des+", %r10d\n"); }
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC MULT");
            }
            $$="p-op";
        }
    }
    else if(not_in_main!=0){
        //within scope of a function or something
        if(local_table.containsKey($1)){
            srce = "$"+local_table.get($1);
        }
        else if($1.equals("f-op")){
            //function call as exp
            $$="p-op";
            srce = "%eax";
        }
        else if($1.equals("p-op")){
            $$="p-op";
            srce = "%r10d";
        }
        else if(prm.contains($1)){
            //$1 is a parameter
            $$="p-op";
            if(prm.indexOf($1)==0 ){
                srce = "%edi";
            }
            else if(prm.indexOf($1)==1){
                srce="%esi";
            }
            else if(prm.indexOf($1)==2){
                srce="%edx";
            }
            else if(prm.indexOf($1)==3){
                srce="%ecx";
            }
            else if(prm.indexOf($1)==4){
                srce="%r8d";
            }
        }
        if(local_table.containsKey($3)){
            des= "$"+local_table.get($3);
        }
        else if($3.equals("f-op")){
            $$ = "p-op";
            des = "%eax";
        }
        else if($3.equals("p-op")){
            $$="p-op";
            des = "%r10d";
        }
        else if(prm.contains($3)){
            $$="p-op";
            if(prm.indexOf($3)==0 ){
                des = "%edi";
            }
            else if(prm.indexOf($3)==1){
                des="%esi";
            }
            else if(prm.indexOf($3)==2){
                des="%edx";
            }
            else if(prm.indexOf($3)==3){
                des="%ecx";
            }
            else if(prm.indexOf($3)==4){
                des="%r8d";
            }
        }
        //handle different combinations like two variables, 1 variable and 1 function, 2 functions
        //only case that results in legit value is both a $num case, every other kind of case you can perform the operation and move to r10d after
        if(srce.substring(0,1).equals("$") && des.substring(0,1).equals("$")){
            String tempor = nextAvailReg(Integer.parseInt(local_table.get($1))* Integer.parseInt(local_table.get($3)) );
            if(tempor.equals("")){
                for(String k:registers.keySet()){
                    freeReg(k);
                    tempor = k;
                    registers.replace(tempor, Integer.parseInt(local_table.get($1))*Integer.parseInt(local_table.get($3)));
                    break;
                }
            }
            //after getting a register to use, move first item to tempor then perform math to store into tempor with the second item
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl "+srce+","+tempor+"\n");//do the math and auto move result to tempor reg
                mySFile.write("\timull "+des+","+tempor+"\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC MULT");
            }
            $$=String.valueOf( Integer.parseInt(local_table.get($1))* Integer.parseInt(local_table.get($3)) );
        }
        else{
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                if(des.substring(0,1).equals("$")){
                    //save to srce instead and then move srce to r10d
                    mySFile.write("\timull "+des+","+srce+"\n");
                    mySFile.write("\tmovl "+srce+", %r10d\n");//do the math and auto move result to r10d
                }else{
                mySFile.write("\timull "+srce+","+des+"\n");
                mySFile.write("\tmovl "+des+", %r10d\n"); }//do the math and auto move result to r10d

                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR TWO NON NUMERIC MULT");
            }
            $$="p-op";
        }
    }
 }
 else if(!isNumeric($1)&& isNumeric($3)){//first exp is a parameter case (within scope of function)
    $$="000";
    //copy patsed code from else if below this one just swap instances of $3 with $1 instead:
    if($1.equals("p-op")){//this means that $3 was previously some math operation that consisted of a parameter already or a function call
        //r10d hard coded to store the result so just do imull num and r10d
        $$="p-op";//once a p-op always a p-op
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\timull $"+$3+", %r10d\n");
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();
            //freeReg("%r10d");//don't use r10d for now so free it
            registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN MULT OP");
        }
    }
    else if(prm.contains($1) && not_in_main!=0){//a parameter and also in the scope of a something like a function or whatever
        int ind = prm.indexOf($1);//tells which parameter position
        $$="p-op";//stands for parameter operation
        if(ind == 0){
            //edi first argument, basically use math operation store into edi then movl from edi to an avail register(might have to free)
            //just use r10d to store the answer for operations that deal with parameters
            //System.out.println("IND IS ZERO");
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$3+", %edi\n");
                mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else if(ind==1){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$3+", %esi\n");
                mySFile.write("\tmovl %esi, %r10d\n");//esi is second argument register
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else if(ind ==2){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$3+", %edx\n");
                mySFile.write("\tmovl %edx, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else if(ind ==3){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$3+", %ecx\n");
                mySFile.write("\tmovl %ecx, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else if (ind==4){
            //5th argument position
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$3+", %r8d\n");
                mySFile.write("\tmovl %r8d, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
    }
    else if(not_in_main!=0 && !prm.contains($1)&& !lexer.functions.contains($1)){
        //not a parameter and not in main so this has to be a local variable use local_table to lookup value
        //local_table.get($1); can't be true or false, first get avail register
        $$ = String.valueOf(Integer.parseInt($3)*Integer.parseInt(local_table.get($1)) );
        //String reg = nextAvailReg(Integer.parseInt($$));
        String reg = "";
        //if(reg.equals("")){
            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($3)){
                    reg = k;
                    break;
                }
            }
        //}
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\timull $"+local_table.get($1)+", "+reg+"\n");
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN MULT OP");
        }
    }
    else if(/*lexer.functions.contains($1)*/ $1.equals("f-op") && not_in_main!=0){
        //if lexer.functions.contains $1 contains the identifier that means this is a function call and must take the return value
        $$="p-op"; //must call the function use the return value in eax to perform the math then store the result in r10d manually
        //consider function calls with no params and function calls with params within a math operation
        /*ACTUALLY, handle this within the exp:ID() case...if(prm.get(lexer.functions.indexOf($3)).length==0){
            //function call with no parameter loading required
        }*/
        try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$3+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");//manually move product into r10d
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
    }
    else if(not_in_main==0){
        //within main, so just use symbol table or function call
        if(/*lexer.functions.contains($1)*/$1.equals("f-op") ){
            //function call case here, consider it a p-op case and move result to r10d
            $$="p-op";
            //that means the return value is in eax
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$3+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");
                mySFile.close();//p-op assume result stored in r10d
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else {
            //symbol table case here, cover cases for integers because you can't do math on boolean or a whole array but can do on elements of an array
            //symbol_table.get($3)
            $$=String.valueOf(Integer.parseInt($3)*Integer.parseInt(symbol_table.get($1)));
            String reg = "";

            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($3)){//since $1 was numeric meaning an int lit that means it had to have been saved in a register somewhere
                    reg = k;
                    break;
                }
            }
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+symbol_table.get($1)+", "+reg+"\n");
                //mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
    }
 }
 else if(isNumeric($1) && !isNumeric($3)){//second exp is a parameter case/identifier/function call (within scope of function check by checking prm and not_in_main)
    $$="000";//placeholder, can ignore
    if($3.equals("p-op")){//this means that $3 was previously some math operation that consisted of a parameter already or a function call
        //r10d hard coded to store the result so just do imull num and r10d
        $$="p-op";//once a p-op always a p-op
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\timull $"+$1+", %r10d\n");
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();
            //freeReg("%r10d");//don't use r10d for now so free it
            registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN MULT OP");
        }
    }
    else if(prm.contains($3) && not_in_main!=0){//a parameter and also in the scope of a something like a function or whatever
        int ind = prm.indexOf($3);//tells which parameter position
        $$="p-op";//stands for parameter operation
        if(ind == 0){
            //edi first argument, basically use math operation store into edi then movl from edi to an avail register(might have to free)
            //just use r10d to store the answer for operations that deal with parameters
            //System.out.println("IND IS ZERO");
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$1+", %edi\n");
                mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else if(ind==1){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$1+", %esi\n");
                mySFile.write("\tmovl %esi, %r10d\n");//esi is second argument register
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else if(ind ==2){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$1+", %edx\n");
                mySFile.write("\tmovl %edx, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else if(ind ==3){
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$1+", %ecx\n");
                mySFile.write("\tmovl %ecx, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else if (ind==4){
            //5th argument position
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$1+", %r8d\n");
                mySFile.write("\tmovl %r8d, %r10d\n");
                mySFile.close();
                //freeReg("%r10d");//don't use r10d for now so free it
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free
                //mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
    }
    else if(not_in_main!=0 && !prm.contains($3)&& !$3.equals("f-op")/* !lexer.functions.contains($3)*/){
        //not a parameter and not in main so this has to be a local variable use local_table to lookup value
        //local_table.get($3); can't be true or false, first get avail register
        $$ = String.valueOf(Integer.parseInt($1)*Integer.parseInt(local_table.get($3)) );
        //String reg = nextAvailReg(Integer.parseInt($$));
        String reg = "";
        //if(reg.equals("")){
            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($1)){
                    reg = k;
                    break;
                }
            }
        //}
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("\timull $"+local_table.get($3)+", "+reg+"\n");
            //mySFile.write("\tmovl %edi, %r10d\n");
            mySFile.close();

        }
        catch(IOException e){
            System.out.println("WRITE ERROR IN MULT OP");
        }
    }
    else if( $3.equals("f-op") && not_in_main!=0){//function call within a function
        //if lexer.functions.contains $3 contains the identifier that means this is a function call and must take the return value
        $$="p-op"; //must call the function use the return value in eax to perform the math then store the result in r10d manually
        //consider function calls with no params and function calls with params within a math operation
        /*ACTUALLY, handle this within the exp:ID() case...if(prm.get(lexer.functions.indexOf($3)).length==0){
            //function call with no parameter loading required
        }*/
        try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$1+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");//manually move product into r10d
                mySFile.close();
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
    }
    else if(not_in_main==0){
        //within main, so just use symbol table or function call
        if(/*lexer.functions.contains($3)*/ $3.equals("f-op")){
            //function call case here, consider it a p-op case and move result to r10d
            $$="p-op";//just set to p-op meaning result will be in r10d
            //that means the return value is in eax
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+$1+", %eax\n");
                mySFile.write("\tmovl %eax, %r10d\n");
                mySFile.close();//p-op assume result stored in r10d
                registers.replace("%r10d",-2147483647);//+1 of max neg val, this means it is not free

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
        else {
            //symbol table case here, cover cases for integers because you can't do math on boolean or a whole array but can do on elements of an array
            //symbol_table.get($3)
            $$=String.valueOf(Integer.parseInt($1)*Integer.parseInt(symbol_table.get($3)));
            String reg = "";

            for(String k:registers.keySet()){
                if(registers.get(k)==Integer.parseInt($1)){//since $1 was numeric meaning an int lit that means it had to have been saved in a register somewhere
                    reg = k;
                    break;
                }
            }
            try{
                FileWriter mySFile = new FileWriter(outputname,true);
                mySFile.write("\timull $"+symbol_table.get($3)+", "+reg+"\n");
                //mySFile.write("\tmovl %edi, %r10d\n");
                mySFile.close();

            }
            catch(IOException e){
                System.out.println("WRITE ERROR IN MULT OP");
            }
        }
    }
    //System.out.println(prm.contains($3));
    //System.out.println(lexer.params);//don't have to do the calculation just set up an argument register
 }
 }
 | MINUS exp    {/*$$=Integer.toString(-1*Integer.parseInt($2)); */ if($2!=null && !isNumeric($2) ){if(!lexer.params.contains($2)&&!isNumeric($2)){yyerror("Negative operator expects integers");} }  try{if($2!=null ){$$=Integer.toString(-1*Integer.parseInt($2));lexer.vals.add($$);}else{$$="00000";lexer.vals.add("00000");} }catch(NumberFormatException e){yyerror("Negative operator expects integers");}
 $$=String.valueOf(Integer.parseInt($2)*-1);System.out.println("negative op: "+$$); String src="$-1";String dest="";
 for(String k:registers.keySet()){
    if(registers.get(k)==Integer.parseInt($2)){
        src=k;//get first register
        //freeReg(k);//free the register that will be the source because we will store answer into dest register
        registers.replace(k,Integer.parseInt($$));//negative $$
        break;
    }
 }

 try{
    FileWriter mySFile = new FileWriter(outputname,true);//append
    mySFile.write("\tnegl "+src+"\n");
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR NEGATIVE OP!");

 }
 }
 | LP exp RP    {/*$$=new ParserVal($2.ival);*/ $$=$2;}
 | ID LB exp RB {/*look up the array ID in table and get proper index*/ /*System.out.println($1);System.out.println(lexer.vals.get(lexer.ids.indexOf($1)));$$=lexer.vals.get(lexer.ids.indexOf($1)).substring(Integer.parseInt($3)*2+1,Integer.parseInt($3)*2+2);*/$$="00";
 if(not_in_main==0){
    //global case
    String arr = symbol_table.get($1);
    System.out.println(arr);
    arr = arr.substring(1,arr.length()-1);//remove the brackets, now i believe the int_list will be separated by periods
    System.out.println(arr);
    //System.out.println(arr.split("."));
    String[] ans =arr.split("\\."); //get each individual index and use $3 to get correct element
    System.out.println(ans.length);
    if(isNumeric($3)){
        //$3 should be an int lit for an index and access that index to be set to $$
        //System.out.println("here:"+$3);
        //System.out.println(ans[0]);
        //System.out.println(arr.split(".")[1]);
        $$ = ans[Integer.parseInt($3)];//index out of bound?
    }
 }
 else if(not_in_main!=0){
    //local var case
    if(!prm.contains($1) && !lexer.params.contains($1)){//added a check for lexer.params because prm include the [] symbols which fail in the string comparison
            //System.out.println(lexer.params);
    String arr = local_table.get($1);//not array parameter case?Local array case FIX
    arr = arr.substring(1,arr.length()-1);
    String[] ans = arr.split("\\.");
    if(isNumeric($3)){
        $$ = ans[Integer.parseInt($3)];
    }
    }
    else if(prm.contains($1) || lexer.params.contains($1)){
        //parameter array case
    }
    /*else if(!isNumeric($3)){
        System.out.println("non numeric index:"+$3);
    }*/
 }
 }//use substring so basically the index*2 +1 will get you the index of the array string of the proper value, instead use 00 to denote indexed array values as an integer
 | ID LP RP {$$=$1;$$="00";$$="f-op";/*if(lexer.functions.contains($1)){if(function_table.get($1).length()!=0 ){yyerror("Illegal num of parameters for function "+$1);}}*/
 //just make a function call
 noParamFuncCall($1);//moved it all to helper function
 /*try{
    FileWriter mySFile = new FileWriter(outputname,true);
    //mySFile.write("");
    mySFile.write("\tmovq %rdi, 64(%rsp)\n");
    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
    mySFile.write("\tmovq %r8, 96(%rsp)\n");
    mySFile.write("\tmovq %r9, 104(%rsp)\n");
    mySFile.write("\tmovq %r10, 112(%rsp)\n");
    mySFile.write("\tmovq %r11, 120(%rsp)\n");
    mySFile.write("\tcall "+$1+"\n");
    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
    mySFile.write("\tmovq 72(%rsp), %rsi\n");
    mySFile.write("\tmovq 80(%rsp), %rdx\n");
    mySFile.write("\tmovq 88(%rsp), %rcx\n");
    mySFile.write("\tmovq 96(%rsp), %r8\n");
    mySFile.write("\tmovq 104(%rsp), %r9\n");
    mySFile.write("\tmovq 112(%rsp), %r10\n");
    mySFile.write("\tmovq 120(%rsp), %r11\n");
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR for exp:ID()");
 }*/
 } //no params for function identifier, functions return integers just use placeholder double zero
 | ID LP param_list RP  {$$=$1;$$="00";$$="f-op";/*if(lexer.functions.contains($1)){if(function_table.get($1).split(",").length != $3.split(",").length){yyerror("Illegal num of parameters for function "+$1);}else{ if( (function_table.get($1).length()==0&&$3.length()==1) || (function_table.get($1).length()==1&&$3.length()==0) ){yyerror("Illegal num of parameters for function "+$1);} } }*/ /*System.out.println("paramlist --> "+$3);if(lexer.scopes.get(lexer.functions.indexOf($1)).split("\n")[1].equals("00")){if($3.length()!=0){yyerror("Illegal num of parameters for function "+$1);} }else{if($3.split(",").length!=lexer.scopes.get(lexer.functions.indexOf($1)).split("\n")[1].split(" ").length ){yyerror("Illegal num of parameters for function "+$1);} } */
 //split the param_list by comma and load into appropriate registers before the call, parameters can be global local or int lit so cover cases
 /*if($3.split(",").length==0){
    //1 parameter case
 }*/
 if(not_in_main==0){//for the global scope (added kinda late)
  if($3.split(",").length==1){
    //case with one parameter only
    //if(isNumeric(function_table.get($1))){
    if(isNumeric($3)){
        //numeric parameter so no need to search symbol table
        /*String temp = nextAvailReg(Integer.parseInt(function_table.get($1)));
        if(temp.equals("")){//get a register
            for(String key : registers.keySet()){
                //free a register if none are currently available
                freeReg(key);
                temp=key;
                registers.replace(key,Integer.parseInt(function_table.get($1)));
                break;
            }
        }*/
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading 1 argument into rdi
            mySFile.write("\tmovq %rsi, 72(%rsp)\n");
            mySFile.write("\tmovq %rdx, 80(%rsp)\n");
            mySFile.write("\tmovq %rcx, 88(%rsp)\n");
            mySFile.write("\tmovq %r8, 96(%rsp)\n");
            mySFile.write("\tmovq %r9, 104(%rsp)\n");
            mySFile.write("\tmovq %r10, 112(%rsp)\n");
            mySFile.write("\tmovq %r11, 120(%rsp)\n");
            //mySFile.write("\tmovl $"+function_table.get($1)+", %edi\n");//move constant int to argument register
            mySFile.write("\tmovl $"+$3+", %edi\n");
            mySFile.write("\tcall "+$1+"\n");
            mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
            mySFile.write("\tmovq 72(%rsp), %rsi\n");
            mySFile.write("\tmovq 80(%rsp), %rdx\n");
            mySFile.write("\tmovq 88(%rsp), %rcx\n");
            mySFile.write("\tmovq 96(%rsp), %r8\n");
            mySFile.write("\tmovq 104(%rsp), %r9\n");
            mySFile.write("\tmovq 112(%rsp), %r10\n");
            mySFile.write("\tmovq 120(%rsp), %r11\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (NO IDS)");
        }
    }
    //else if(!isNumeric(function_table.get($1))){
    else if(!isNumeric($3)){//param is a variable identifier so must search the symbol table for the value to load into arg reg
        //if not numeric then need to find the identifier's value
        //System.out.println(lexer.ids);
        //System.out.println(lexer.vals);
        //symbol_table.get(function_table.get($1));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading 1 argument into rdi
            mySFile.write("\tmovq %rsi, 72(%rsp)\n");
            mySFile.write("\tmovq %rdx, 80(%rsp)\n");
            mySFile.write("\tmovq %rcx, 88(%rsp)\n");
            mySFile.write("\tmovq %r8, 96(%rsp)\n");
            mySFile.write("\tmovq %r9, 104(%rsp)\n");
            mySFile.write("\tmovq %r10, 112(%rsp)\n");
            mySFile.write("\tmovq %r11, 120(%rsp)\n");
            mySFile.write("\tmovl $"+symbol_table.get(function_table.get($1))+", %edi\n");//move constant int to argument register
            mySFile.write("\tcall "+$1+"\n");
            mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
            mySFile.write("\tmovq 72(%rsp), %rsi\n");
            mySFile.write("\tmovq 80(%rsp), %rdx\n");
            mySFile.write("\tmovq 88(%rsp), %rcx\n");
            mySFile.write("\tmovq 96(%rsp), %r8\n");
            mySFile.write("\tmovq 104(%rsp), %r9\n");
            mySFile.write("\tmovq 112(%rsp), %r10\n");
            mySFile.write("\tmovq 120(%rsp), %r11\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (ONE ID param)");
        }
    }
 }
 else if (function_table.get($1).split(",").length==2 || $3.split(",").length==2){//two arguments case
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (2 args)");
    }
    //case with loading two parameters, arg 0 and arg 1
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (2 args)");
    }
 }
 else if (function_table.get($1).split(",").length==3 || $3.split(",").length==3){//three arguments case, use OR because sometimes a parameter may be array that has commas
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (3 args)");
    }
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[2])){
        //third argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[2]+", %edx\n");//edx is third argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[2])){
        //third argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[2])+", %edx\n");//edx is third argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (3 args)");
    }
 }
 else if (function_table.get($1).split(",").length==4 || $3.split(",").length==4){//four arguments case
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (4 args)");
    }
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[2])){
        //third argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[2]+", %edx\n");
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[2])){
        //third argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[2])+", %edx\n");// passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[3])){
        //fourth argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[3]+", %ecx\n");//ecx is 4th argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[3])){
        //fourth argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[3])+", %ecx\n");//ecx is 4th argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (4 args)");
    }
 }
 else if (function_table.get($1).split(",").length==5 || $3.split(",").length==5){//five arguments case
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (5 args)");
    }
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[2])){
        //third argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[2]+", %edx\n");
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[2])){
        //third argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[2])+", %edx\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[3])){
        //fourth argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[3]+", %ecx\n");//ecx is 4th argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[3])){
        //fourth argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[3])+", %ecx\n");//passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[4])){
        //fifth argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[4]+", %r8d\n");//r8d is 5th argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[4])){
        //fifth argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+symbol_table.get($3.split(",")[4])+", %r8d\n");//passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (5 args)");
    }
 }
    }
 else if(not_in_main!=0){
        //check if any current function params are within the $3 param_list
        //paramAsParam($3);
    //local scope case of a function call so check local table to load possible parameters
    if($3.split(",").length==1){
    //case with one parameter only
    //if(isNumeric(function_table.get($1))){
    if(isNumeric($3)){
        //numeric parameter so no need to search symbol table
        /*String temp = nextAvailReg(Integer.parseInt(function_table.get($1)));
        if(temp.equals("")){//get a register
            for(String key : registers.keySet()){
                //free a register if none are currently available
                freeReg(key);
                temp=key;
                registers.replace(key,Integer.parseInt(function_table.get($1)));
                break;
            }
        }*/
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading 1 argument into rdi
            mySFile.write("\tmovq %rsi, 72(%rsp)\n");
            mySFile.write("\tmovq %rdx, 80(%rsp)\n");
            mySFile.write("\tmovq %rcx, 88(%rsp)\n");
            mySFile.write("\tmovq %r8, 96(%rsp)\n");
            mySFile.write("\tmovq %r9, 104(%rsp)\n");
            mySFile.write("\tmovq %r10, 112(%rsp)\n");
            mySFile.write("\tmovq %r11, 120(%rsp)\n");
            //mySFile.write("\tmovl $"+function_table.get($1)+", %edi\n");//move constant int to argument register
            mySFile.write("\tmovl $"+$3+", %edi\n");
            mySFile.write("\tcall "+$1+"\n");
            mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
            mySFile.write("\tmovq 72(%rsp), %rsi\n");
            mySFile.write("\tmovq 80(%rsp), %rdx\n");
            mySFile.write("\tmovq 88(%rsp), %rcx\n");
            mySFile.write("\tmovq 96(%rsp), %r8\n");
            mySFile.write("\tmovq 104(%rsp), %r9\n");
            mySFile.write("\tmovq 112(%rsp), %r10\n");
            mySFile.write("\tmovq 120(%rsp), %r11\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (NO IDS)");
        }
    }
    //else if(!isNumeric(function_table.get($1))){
    else if(!isNumeric($3)){//param is a variable identifier so must search the symbol table for the value to load into arg reg
        //if not numeric then need to find the identifier's value
        //System.out.println(lexer.ids);
        //System.out.println(lexer.vals);
        //symbol_table.get(function_table.get($1));
        //check if a passed parameter is a parameter of the current function 4/8 for file6
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading 1 argument into rdi
            mySFile.write("\tmovq %rsi, 72(%rsp)\n");
            mySFile.write("\tmovq %rdx, 80(%rsp)\n");
            mySFile.write("\tmovq %rcx, 88(%rsp)\n");
            mySFile.write("\tmovq %r8, 96(%rsp)\n");
            mySFile.write("\tmovq %r9, 104(%rsp)\n");
            mySFile.write("\tmovq %r10, 112(%rsp)\n");
            mySFile.write("\tmovq %r11, 120(%rsp)\n");
            mySFile.close();
            if(paramAsParam($3)==false){
            mySFile.write("\tmovl $"+local_table.get(function_table.get($1))+", %edi\n");}else{paramLoadParam($3);}//move constant int to argument register
            FileWriter mySFile2=new FileWriter(outputname,true);//reopen the file
            mySFile2.write("\tcall "+$1+"\n");
            mySFile2.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
            mySFile2.write("\tmovq 72(%rsp), %rsi\n");
            mySFile2.write("\tmovq 80(%rsp), %rdx\n");
            mySFile2.write("\tmovq 88(%rsp), %rcx\n");
            mySFile2.write("\tmovq 96(%rsp), %r8\n");
            mySFile2.write("\tmovq 104(%rsp), %r9\n");
            mySFile2.write("\tmovq 112(%rsp), %r10\n");
            mySFile2.write("\tmovq 120(%rsp), %r11\n");
            mySFile2.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (ONE ID param)");
        }
    }
 }
 else if (function_table.get($1).split(",").length==2 || $3.split(",").length==2){//two arguments case
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (2 args)");
    }
    //case with loading two parameters, arg 0 and arg 1
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            /*if(!prm.contains($3.split(",")[0]) && isNumeric(local_table.get($3.split(",")[0])) ){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[0])+", %edi\n");}else{paramLoadParam($3);}*/
            if(!prm.contains($3.split(",")[0]) && isNumeric(local_table.get($3.split(",")[0]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[0])+", %edi\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[0])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[0]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }
            ///mySFile.write("\tmovl $"+local_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);

            if(/*paramAsParam($3)==false*/!prm.contains($3.split(",")[1]) && isNumeric(local_table.get($3.split(",")[1]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[1])+", %esi\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[1])){paramLoadParam($3);System.out.println("first");}
            else if(!isNumeric(local_table.get($3.split(",")[1]))){
                //local table contains non numeric value
                //System.out.println("2nd");
                paramLoadLocalVar($3);
            }

            ///mySFile.write("\tmovl $"+local_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (2 args)");
    }
 }
 // IMPORTANT PLEASE READ: Cases below cover loading parameters for cases where there are 3,4,or 5 parameters to be loaded. The code base got too large and java would give an error when compiling.  I had to comment the code out so function parameter loading with 3 or more parameters may not be stable.
 else if (function_table.get($1).split(",").length==3 || $3.split(",").length==3){//three arguments case, use OR because sometimes a parameter may be array that has commas
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (3 args)");
    }
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            /*if(!prm.contains($3.split(",")[0]) && isNumeric(local_table.get($3.split(",")[0]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[0])+", %edi\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[0])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[0]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            /*if(!prm.contains($3.split(",")[1]) && isNumeric(local_table.get($3.split(",")[1]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[1])+", %esi\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[1])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[1]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[2])){
        //third argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[2]+", %edx\n");//edx is third argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[2])){
        //third argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[2])+", %edx\n");//edx is third argument register, passed parameters should not be booleans
            /*if(!prm.contains($3.split(",")[2]) && isNumeric(local_table.get($3.split(",")[2]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[2])+", %edx\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[2])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[2]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (3 args)");
    }
 }
 else if (function_table.get($1).split(",").length==4 || $3.split(",").length==4){//four arguments case
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (4 args)");
    }
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            //NOTE: this code comment below is needed for cases where parameters of current function are loaded as parameters of subsequent function call, or if some special local variable is used as parameter, BUT java compiler gives error for code being too long :(
            /*if(!prm.contains($3.split(",")[0]) && isNumeric(local_table.get($3.split(",")[0]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[0])+", %edi\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[0])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[0]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            /*if(!prm.contains($3.split(",")[1]) && isNumeric(local_table.get($3.split(",")[1]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[1])+", %esi\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[1])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[1]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[2])){
        //third argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[2]+", %edx\n");
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[2])){
        //third argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[2])+", %edx\n");// passed parameters should not be booleans
            /*if(!prm.contains($3.split(",")[2]) && isNumeric(local_table.get($3.split(",")[2]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[2])+", %edx\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[2])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[2]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[3])){
        //fourth argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[3]+", %ecx\n");//ecx is 4th argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[3])){
        //fourth argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[3])+", %ecx\n");//ecx is 4th argument register, passed parameters should not be booleans
            /*if(!prm.contains($3.split(",")[3]) && isNumeric(local_table.get($3.split(",")[3]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[3])+", %ecx\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[3])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[3]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (4 args)");
    }
 }
 else if (function_table.get($1).split(",").length==5 || $3.split(",").length==5){//five arguments case, some code commented out because code base too long but earlier cases of loading less parameters are more fault tolerant and flexible
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tmovq %rdi, 64(%rsp)\n");//setup for a procedure call with loading arguments
        mySFile.write("\tmovq %rsi, 72(%rsp)\n");
        mySFile.write("\tmovq %rdx, 80(%rsp)\n");
        mySFile.write("\tmovq %rcx, 88(%rsp)\n");
        mySFile.write("\tmovq %r8, 96(%rsp)\n");
        mySFile.write("\tmovq %r9, 104(%rsp)\n");
        mySFile.write("\tmovq %r10, 112(%rsp)\n");
        mySFile.write("\tmovq %r11, 120(%rsp)\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION W/ PARAMETERS (5 args)");
    }
    if(isNumeric($3.split(",")[0])){//used to be function_table.get($1).split(",")[0]
        //check cases for each argument where each argument can be either numeric or identifier
        //this is the first argument numeric case
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[0]+", %edi\n");//edi is first argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[0])){
        //first argument is identifier
        //System.out.println("ids and vals:");System.out.println(lexer.ids);System.out.println(lexer.vals);System.out.println(symbol_table.get(function_table.get($1).split(",")[0]));
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            ///mySFile.write("\tmovl $"+local_table.get($3.split(",")[0])+", %edi\n");//edi is first argument register, use symbol table to lookup the identifier
            if(!prm.contains($3.split(",")[0]) && isNumeric(local_table.get($3.split(",")[0]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[0])+", %edi\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[0])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[0]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[1])){
        //second argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[1]+", %esi\n");//esi is second argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[1])){
        //second argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[1])+", %esi\n");//esi is second argument register, passed parameters should not be booleans
            /*if(!prm.contains($3.split(",")[1]) && isNumeric(local_table.get($3.split(",")[1]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[1])+", %esi\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[1])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[1]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[2])){
        //third argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[2]+", %edx\n");

            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[2])){
        //third argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[2])+", %edx\n");//esi is second argument register, passed parameters should not be booleans
            /*if(!prm.contains($3.split(",")[2]) && isNumeric(local_table.get($3.split(",")[2]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[2])+", %edx\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[2])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[2]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[3])){
        //fourth argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[3]+", %ecx\n");//ecx is 4th argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[3])){
        //fourth argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[3])+", %ecx\n");//passed parameters should not be booleans
            /*if(!prm.contains($3.split(",")[3]) && isNumeric(local_table.get($3.split(",")[3]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[3])+", %ecx\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[3])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[3]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    if(isNumeric($3.split(",")[4])){
        //fifth argument is numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+$3.split(",")[4]+", %r8d\n");//r8d is 5th argument register
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    else if(!isNumeric($3.split(",")[4])){
        //fifth argument is not numeric
        try{
            FileWriter mySFile=new FileWriter(outputname,true);
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[4])+", %r8d\n");//passed parameters should not be booleans
            /*if(!prm.contains($3.split(",")[4]) && isNumeric(local_table.get($3.split(",")[4]))){
            mySFile.write("\tmovl $"+local_table.get($3.split(",")[4])+", %r8d\n");}else if(paramAsParam($3)&& prm.contains($3.split(",")[4])){paramLoadParam($3);}
            else if(!isNumeric(local_table.get($3.split(",")[4]))){
                //local table contains non numeric value
                paramLoadLocalVar($3);
            }*/
            //mySFile.write("\tcall "+$1+"\n");
            mySFile.close();
        }catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMETERS");
        }
    }
    //after call is made
    try{
        FileWriter mySFile=new FileWriter(outputname,true);
        mySFile.write("\tcall "+$1+"\n");//make the call and then do some cleaning up after the call
        mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
        mySFile.write("\tmovq 72(%rsp), %rsi\n");
        mySFile.write("\tmovq 80(%rsp), %rdx\n");
        mySFile.write("\tmovq 88(%rsp), %rcx\n");
        mySFile.write("\tmovq 96(%rsp), %r8\n");
        mySFile.write("\tmovq 104(%rsp), %r9\n");
        mySFile.write("\tmovq 112(%rsp), %r10\n");
        mySFile.write("\tmovq 120(%rsp), %r11\n");
        mySFile.close();
    }catch(IOException e){
        System.out.println("WRITE ERROR FOR FUNCTION RETURN W/ PARAMETERS (5 args)");
    }
 }
 }
 } //recursion? //can split param_list by commas to see how many parameters and compare that with the information found in scopes//some params for function identifier, functions return integers, IF FUNCTION ID then 00 ELSE Parameter then 000
 | ID DOT ID LP RP  {}//object calling function dot notation lines
 | ID DOT ID LP param_list RP   {}
 | INT_LIT  {System.out.println("int_lit: "+Integer.toString($1));$$=Integer.toString($1);String temp=nextAvailReg($1);if(temp.equals("")){/*free a register*/
 for(String k:registers.keySet()){
    //registers.replace(k,-2147483648);
    freeReg(k);
    temp=k;
    registers.replace(temp,$1);
    break;
 }
 }/*move int lit to a register*/try{FileWriter mySFile = new FileWriter(outputname,true);mySFile.write("\tmovl $"+Integer.toString($1)+", "+temp+"\n");/*printMap(registers);*/mySFile.close();}catch(IOException e){System.out.println("WRITE ERROR FOR INT LIT!");} }
 | ID   {$$=lookup($1);System.out.println("id:"+$1+",val:"+$$);/*if(lexer.functions.contains($1)){yyerror("Illegal function usage: "+$1);}if(lookup($1)==null){if(lexer.ids.contains($1)){$$=lexer.vals.get(lexer.ids.indexOf($1));}else if(lexer.params.contains($1)){$$="000";} }*/
 //identifier can be int, boolean, or int array so cover the cases. May come back to split into global identifier/function scope identifiers
 int temp = -1;//System.out.println(not_in_main);System.out.println($$);System.out.println(lexer.params);
 if(not_in_main==0){//added this to cover local or global case of $$ (avoid null pointer)
    $$ = lookup($1);
 }
 else if(not_in_main!=0){
    if(local_table.containsKey($1)){$$ = local_table.get($1);}
    ///else if(prm.contains($1)){$$=prm.get(prm.indexOf($1));}//added 4/9
 }
 if(prm.contains($1)){//if the identifier is a parameter (meaning currently in the scope of a function
    $$=prm.get(prm.indexOf($1));//set $$ as the identifier itself
    System.out.println("spotted: "+$$);
 }
 if(not_in_main==0 && isNumeric(lookup($1)) ){//integer case for an identifier, when found in the main scope
    temp = Integer.parseInt(lookup($1));
    String dest = nextAvailReg(temp);
    if(dest.equals("")){
        for(String k:registers.keySet()){
            freeReg(k);
            dest = k;
            registers.replace(dest,temp);
            break;//free some register to use for storing a identifier
        }
    }
    try{
        FileWriter w = new FileWriter(outputname,true);
        w.write("\tmovl "+$1+"(%rip),"+dest+"\n");
        w.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR WITH INT ID");
    }
 }
 else if(not_in_main == 0 && !isNumeric(lookup($1)) ){
    //boolean case
    if(lookup($1).equals("true")){
        temp = 1;
    }
    else if(lookup($1).equals("false")){
        temp=0;
    }
    String dest = nextAvailReg(temp);
    if(dest.equals("")){
        for(String k:registers.keySet()){
            freeReg(k);
            dest = k;
            registers.replace(dest,temp);
            break;//free some register to use for storing a identifier
        }
    }
    try{
        FileWriter w = new FileWriter(outputname,true);
        w.write("\tmovl "+$1+"(%rip),"+dest+"\n");
        w.close();
    }
    catch(IOException e){
        System.out.println("WRITE ERROR WITH BOOL ID");
    }
 }

 }//lookup the value if possible, but if it is null then search the arraylists that have been setup
 | TRUE_T   {/*$$=(boolean)$1;*/$1=String.valueOf(true);$$="true"; String temp = nextAvailReg(1);
 if(temp.equals("")){
    //must free a register if no register is provided, make that freed register the register that will be used to store a 1
    for(String k : registers.keySet()){
        freeReg(k);
        temp=k;
        registers.replace(temp,1);
        break;
    }
 }
 //registers.replace("%r10d",1);//use r10d for booleans
 try{
    FileWriter mySFile = new FileWriter(outputname,true);
    mySFile.write("\tmovl $1, "+temp+"\n");
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR TRUE_T");
 }
 }
 | FALSE_T  {/*$$=(boolean)$1;*/$1=String.valueOf(false);$$="false";String temp = nextAvailReg(0);
 if(temp.equals("")){
    //must free a register
    for(String k : registers.keySet()){
        freeReg(k);
        temp=k;
        registers.replace(temp,0);//ADDed this because if there is no register available then free a register and store value there using replace
        break;
    }
 }
 try{
    FileWriter mySFile = new FileWriter(outputname,true);
    mySFile.write("\tmovl $0, "+temp+"\n");
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR FALSE_T");
 }
 }
;
int_list : int_list COMMA INT_LIT   {if($2==null){$$+=Integer.toString($3);}else{/*$$+=$2+Integer.toString($3);*/$$+="."+Integer.toString($3);}}//instead of comma use period (.)
 | INT_LIT {$$="";$$+=Integer.toString($1);}
 ;
param_list : param_list COMMA exp   {$$+=$2+$3;}
 | exp  {$$="";$$+=$1;}
 ;
//00-func ID
//000-Param
//0000-input
%%

/* Byacc/J expects a member method int yylex(). We need to provide one
   through this mechanism. See the jflex manual for more information. */

	/* reference to the lexer object */
	private static scannerJY lexer;
	static int not_in_main = 0;
	static int stackobjTracker = 0;
	static String outputname = "";//will store the name of the output file that will have to be appended to
    static int error_check=0;
    static ArrayList<ArrayList<Object>> table = new ArrayList<>(); //2d table
    //static HashMap symbol_table = new HashMap();//symbol table data structure here
    static HashMap<String,String> symbol_table =new HashMap();
    //static ArrayList<String> arrayElementValues = new ArrayList<>();
    static HashMap<String,String> function_table = new HashMap();
    static HashMap<String,Integer> registers = new HashMap();// tells what registers are available
    static HashMap<String,Integer> SpecialRegisters= new HashMap();//special registers like eax
    static ArrayList<String> prm = new ArrayList<>();//params for function scopes
    static HashMap<String,String> local_table= new HashMap();//storing local variables within scope of functions, at the end of functions just use clear to clear the hashmap
    static int rspOffset = 0; //for movl %reg, rspOffset(%rsp) operations
    static HashMap<String, Integer> stackOffsetInfo = new HashMap();//store ints as ints, booleans as 0 or 1, params and param operations as -2147483648, and f-op as -2147483647, input as 9001
    static int IFlabel =0 ;static int WHILElabel = 0;
    static int ifnested = -1;//may not use some
    static int tempcounter = 0;static int tempcounterZed = 0;
    static Stack<Integer> ifStack = new Stack();
    static Stack<Integer> whileStack = new Stack();
    static int elseExists = 0;
    static String currclassID = "";
    /*
    try{
        //make a .s file to write to
        static FileWriter mySFile=new FileWriter("code.s");
        //using filewriter
        //mySFile.write(".text\n");
        //mySFile.write(".globl mython\n");
        //mySFile.write(".type mython, @function\n");
        //mySFile.write("mython:\n");
	    }
    catch(IOException e){
        System.out.println("Output file creation error!");
        e.printStackTrace();
    }
    */
    /*
    registers.put("%r10d",0);//set up registers with starting values of 0 which just represents a boolean meaning not in use
    registers.put("%r11d",0);
    registers.put("%ebx",0);
    registers.put("%ebp",0);
    registers.put("%r12d",0);
    registers.put("%r13d",0);
    registers.put("%r14d",0);
    registers.put("%r15d",0);
    */
    public static String fileToString(String filePath) throws Exception{
        String input = null;
        StringBuffer sb = new StringBuffer();
        Scanner sc = new Scanner(new File(filePath));
        while(sc.hasNextLine()){
            input = sc.nextLine();
            sb.append(input);
        }
        return sb.toString();
    }
    public static boolean isNumeric(String str) { //helper method for parsing integers
        //System.out.println("hi");
        try {
            Integer.parseInt(str);
            return true;
        }
        catch(NumberFormatException e){
            return false;
        }
        /*catch(NullPointerException n){
            return false;
        }*/
    }
	/* interface to the lexer */
	private int yylex() {
		int retVal = -1;
		try {
			retVal = lexer.yylex();
		} catch (IOException e) {
			System.err.println("IO Error:" + e);
		}
		return retVal;
	}

	/* error reporting */
	public void yyerror (String error) {
	    //System.out.println(lexer.yytext()+" "+lexer.yytext().equals("")+" "+lexer.yytext().length());//remember to use .equals to compare strings!

	    if(lexer.yytext().length()==0){
            error_check=0;//for a reason the eof gets syntax and stack underflow error, add this to avoid that issue
	    }
	    else{
            System.err.println("Error : " + error + " at line " + (lexer.getLine()+1) );
            System.err.println("Line rejected");
            error_check = 1;
	    }
		///System.err.println("Error : " + error + " at line " + lexer.getLine()+" | Linecount:"+lexer.linecount);
		///System.err.println("Line rejected");
		///error_check = 1;
	}

	/* constructor taking in File Input */
	public Parser (Reader r) {
		lexer = new scannerJY (r, this);
		//FileWriter mySFile=new FileWriter("code.s");
	}
	/*
	private static int LC(){
        return lexer.getLineCount();
	}*/
	//public void assign(K id, V value){
	//HELPERS
    public void assign(String id, int value){//stores
        ///symbol_table.put(id,new Integer(value));
        ///function_table.put(id,value);
	}
	public void assignA(String id, String p){//assigning functions to parameters
        function_table.put(id,p);
	}
	public void assignB(String id, String value){ //store id in symbol table with associated value
        symbol_table.put(id,value);
	}
	public String lookup(String id){//lookups the value of the given identifier in the table
        //return (symbol_table.get(id)).intValue();
        //return String.valueOf(symbol_table.get(id));//could get int, so checkNumeric and parseInt later
        return symbol_table.get(id);
	}
	public static void setUpRegs(){
        registers.put("%r10d",-2147483648);//set up registers with starting values of some arbitrary large negative number representing not in use
        registers.put("%r11d",-2147483648);
        registers.put("%ebx",-2147483648);
        registers.put("%ebp",-2147483648);
        registers.put("%r12d",-2147483648);
        registers.put("%r13d",-2147483648);
        registers.put("%r14d",-2147483648);
        registers.put("%r15d",-2147483648);

        //special registers
        SpecialRegisters.put("%eax",-2147483648);//return values
        SpecialRegisters.put("%ecx",-2147483648);//fourth argument register
        SpecialRegisters.put("%edx",-2147483648);//third argument register
        SpecialRegisters.put("%esi",-2147483648);//second argument register
        SpecialRegisters.put("%edi",-2147483648);//first argument register
        SpecialRegisters.put("%r9d",-2147483648);//sixth argument register
        SpecialRegisters.put("%r8d",-2147483648);//fifth argument register
        //there is also esp but that is stack pointer just stick to 15 registers for the assignment
	}
	//register methods below
	public String nextAvailReg(int newregval){//Get the next available register and assign the placeholder value of -99 with actual value stored in register
        //retrieve next available register, basically iterate through the data structure and return the name of the first available register
        for(String key : registers.keySet()){
            if(registers.get(key)==-2147483648){
                //registers.replace(key,1);
                registers.replace(key,newregval);//replace the corresponding key with a new val because this register is about to go into use
                return key;//find the first key (register) that is not in use and return it
            }
        }
        return "";//empty string if not found
	}
	public void freeReg(String regname){
        //free a register (make it available)
        //use hashmap replace
        if(registers.containsKey(regname)){
            registers.replace(regname,-2147483648);//free the register by setting corresponding value to max negative int
            System.out.println("freed: "+regname);
        }
        else if(SpecialRegisters.containsKey(regname)){
            //SpecialRegisters.replace(regname,0);
            SpecialRegisters.replace(regname,-2147483648);
        }
	}
	public /*static*/ void printMap (Map mp){
        Iterator it = mp.entrySet().iterator();
        while(it.hasNext()){
            Map.Entry pair = (Map.Entry)it.next();
            System.out.println(pair.getKey()+" = "+pair.getValue());
            it.remove();//concurrentmodification exception evasion
        }
	}
	public void startWhile(){
        //these next couple methods were made to avoid a code too large error
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("WHILE"+String.valueOf(WHILElabel++)+":\n");
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH WHILE");
        }
	}
	public void beforeWhileStmts(String exp){
        String tempreg="";
        if(whileStack.size()==1){
            tempcounterZed++;
            WHILElabel++;
        }
        whileStack.push(1);

        if(exp.equals("p-op")){//exp is $3 from the yacc spec
            for(String k:registers.keySet()){
                if(registers.get(k)==2147483647){
                //find register matching max int value
                tempreg = k;
                break;
                }
            }
        try{
        FileWriter mySFile = new FileWriter(outputname,true);
        mySFile.write("\tcmpl $0,"+tempreg+"\n");
        mySFile.write("\tje WHILE"+String.valueOf(WHILElabel )+"\n");//so for the first if statement it will have label IF0 and use ++ to setup the write for jmp IF1
        freeReg(tempreg);//added 4/7

        mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH WHILE");
        }
        }
        else if(exp.equals("true")){//global variable case with numeric value



            for(String k:registers.keySet()){
                if(registers.get(k)==1){
                //find register matching max int value
                tempreg = k;
                break;
                }
            }
        try{
        FileWriter mySFile = new FileWriter(outputname,true);
        mySFile.write("\tcmpl $0,"+tempreg+"\n");
        mySFile.write("\tje WHILE"+String.valueOf(WHILElabel )+"\n");//so for the first if statement it will have label IF0 and use ++ to setup the write for jmp IF1
        freeReg(tempreg);//added 4/8

        mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR WITH WHILE");
        }

	}
	}
	public void afterWhileStmts(){
        //after statements generate code to jmp to beginning of loop and then a label for exit the current loop
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\tjmp WHILE"+String.valueOf(WHILElabel-1)+"\n");
            if(whileStack.size()==1 && tempcounterZed!=0){
                mySFile.write("WHILE"+String.valueOf(WHILElabel-tempcounterZed-1)+"\n");
            }
            else if(whileStack.size()>1){
                mySFile.write("WHILE"+String.valueOf(WHILElabel++)+":\n");
            }
            else{
                mySFile.write("WHILE"+String.valueOf(WHILElabel++)+":\n");
            }
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR WHIlE loop post stmts");
        }
	}
	public void endWhile(){
        if(whileStack.size()==1){
            tempcounterZed= 0;
        }
        whileStack.pop();
	}
	/*public void replaceWritten() throws FileNotFoundException{ //attempt to fix some if labels
	    if(elseExists==1){
        String filePath = outputname;
        String result = fileToString(filePath);
        result = result.replaceAll("IF"+String.valueOf(IFlabel-1)+":\n","IF"+String.valueOf(IFlabel+1)+":\n" );//stack.size?
        PrintWriter writer = new PrintWriter (new File(filePath));
        writer.append(result);
        writer.flush();
	    }
	}*/
	public void returnLocalVar(String exp){//for return exp
        //exp is $2
        String regist = "";
        if(prm.contains(local_table.get(exp))){
            //if the local variable is just a parameter then figure out which index parameter and then move that to the return value
            int x = prm.indexOf(local_table.get(exp));
            if(x==0){
                regist = "%edi";
            }
            else if(x==1){
                regist = "%esi";
            }
            else if(x==2){
                regist="%edx";
            }
            else if(x==3){
                regist="%ecx";
            }
            else if(x==4){
                regist = "%r8d";
            }
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl "+regist+",%eax\n");
                mySFile.write("\tjmp ."+lexer.functions.get(lexer.functions.size()-1)+"_return\n");
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR WITH LOCAL VAR RETURN");
            }
        }
        else if(isNumeric(local_table.get(exp))){
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl $"+local_table.get(exp)+",%eax\n");//get int value
                mySFile.write("\tjmp ."+lexer.functions.get(lexer.functions.size()-1)+"_return\n");
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR WITH LOCAL VAR RETURN");
            }
        }
        //check stack offset
        else if(local_table.containsKey(exp) && !isNumeric(local_table.get(exp)) && stackOffsetInfo.containsKey(exp)){
            //FIX?
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl "+calcLocalStackOffset(exp)+")%(rsp),%eax\n");//get int value
                mySFile.write("\tjmp ."+lexer.functions.get(lexer.functions.size()-1)+"_return\n");
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR WITH LOCAL VAR RETURN");
            }
        }
	}
	public boolean paramAsParam(String param_list){//to be used in function calls
        //when current function parameters are passed as parameters to a function call within a function
        boolean ans = false;
        String src="";String des = "";
        for(int i = 0;i<param_list.split(",").length;i++){
            if(prm.contains(param_list.split(",")[i]) ){
                ans = true;
                /*if(prm.indexOf(param_list.split(",")[i])==0){
                    src="%edi";
                }
                else if(prm.indexOf(param_list.split(",")[i])==1){
                    src="%esi";
                }
                else if(prm.indexOf(param_list.split(",")[i])==2){
                    src="%edx";
                }
                else if(prm.indexOf(param_list.split(",")[i])==3){
                    src="%ecx";
                }
                else if(prm.indexOf(param_list.split(",")[i])==4){
                    src="%r8d";
                }
                if(i==0){
                    des="%edi";
                }
                else if(i==1){
                    des="%esi";
                }
                else if(i==2){
                    des="%edx";
                }
                else if(i==3){
                    des="%ecx";
                }
                else if(i==4){
                    des="%r8d";
                }
                try{
                    FileWriter mySFile = new FileWriter(outputname,true);
                    mySFile.write("\tmovl "+src+","+des+"\n");
                    mySFile.close();
                }
                catch(IOException e){
                    System.out.println("WRITE ERROR FOR PARAMETER PASSED AS A PARAMETER AGAIN");
                }*/
            }
        }
        //just load params
        return ans;
	}
	public boolean paramIsLocalVar(String param_list){
        boolean ans = false;
        for(int i=0;i<param_list.split(",").length;i++){
            if(stackOffsetInfo.containsKey(param_list.split(",")[i])){
                ans = true;
                //System.out.println("hi"+stackOffsetInfo.get(param_list.split(",")[i]));
            }
        }
        return ans;
	}
	public void paramLoadLocalVar(String param){//param is moreso the param_list
        int xx = 0;String src="";String des="";
        /*for(String k : stackOffsetInfo.keySet()){
            if(!stackOffsetInfo.get(k).equals(param)){
               xx++;
            }
        }*/ //System.out.println(paramIsLocalVar(param)); printMap(stackOffsetInfo);
        //System.out.println(param);
        //if( paramIsLocalVar(param) /*&& local_table.containsKey(param) && stackOffsetInfo.containsKey(param)*/){

            for(int i = 0;i<param.split(",").length;i++){
                if(local_table.containsKey(param.split(",")[i]) && stackOffsetInfo.containsKey(param.split(",")[i])){
                    //local variable exists
                    System.out.println("hieloo");
                    for(String k : stackOffsetInfo.keySet()){
                    if(!stackOffsetInfo.get(k).equals(param)){
                    xx++;
                    }
                }

                if(i==0){
                    des="%edi";
                }
                else if(i==1){
                    des="%esi";
                }
                else if(i==2){
                    des="%edx";
                }
                else if(i==3){
                    des="%ecx";
                }
                else if(i==4){
                    des="%r8d";
                }
            try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl "+String.valueOf(xx*4)+"(%rsp),"+des+"\n");
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR PARAMETER LOAD LOCAL VAR");
            }
            }
            else if(param.split(",")[i].equals("f-op")){//added 4/8 End of day
                if(i==0){
                    des="%edi";
                }
                else if(i==1){
                    des="%esi";
                }
                else if(i==2){
                    des="%edx";
                }
                else if(i==3){
                    des="%ecx";
                }
                else if(i==4){
                    des="%r8d";
                }
                try{
                FileWriter mySFile = new FileWriter(outputname, true);
                mySFile.write("\tmovl %eax,"+des+"\n");
                mySFile.close();
            }
            catch(IOException e){
                System.out.println("WRITE ERROR FOR PARAMETER LOAD LOCAL VAR");
            }
            }
        }
	//}
	}
	public void paramLoadParam(String param_list){//actually does the writing if a parameter of current function needs to be used as a parameter of subsequent function call
        String src="";String des = "";
        if(paramAsParam(param_list)==true){
        for(int i = 0;i<param_list.split(",").length;i++){
            if(prm.contains(param_list.split(",")[i]) ){
                //ans = true;
                if(prm.indexOf(param_list.split(",")[i])==0){
                    src="%edi";
                }
                else if(prm.indexOf(param_list.split(",")[i])==1){
                    src="%esi";
                }
                else if(prm.indexOf(param_list.split(",")[i])==2){
                    src="%edx";
                }
                else if(prm.indexOf(param_list.split(",")[i])==3){
                    src="%ecx";
                }
                else if(prm.indexOf(param_list.split(",")[i])==4){
                    src="%r8d";
                }
                if(i==0){
                    des="%edi";
                }
                else if(i==1){
                    des="%esi";
                }
                else if(i==2){
                    des="%edx";
                }
                else if(i==3){
                    des="%ecx";
                }
                else if(i==4){
                    des="%r8d";
                }
                try{
                    FileWriter mySFile = new FileWriter(outputname,true);
                    mySFile.write("\tmovl "+src+","+des+"\n");
                    mySFile.close();
                }
                catch(IOException e){
                    System.out.println("WRITE ERROR FOR PARAMETER PASSED AS A PARAMETER AGAIN");
                }
            }
        }}
        /*else if(paramAsParam(param_list)==false && paramIsLocalVar(param_list)){
            //a parameter is a local variable so must use the stack offset to load the proper value into an argument register
        }*/
	}
	public void objClassInitiator(String _$2){ //this is setting up for object class called in the procedure with CLASS_ID
        try{
    FileWriter mySFile = new FileWriter(outputname,true);
    mySFile.write("\t.text\n");
    mySFile.write("globl "+_$2+"_construct\n");
    mySFile.write("\t.type   "+_$2+"_construct, @function\n");
    mySFile.write(_$2+"_construct:\n");//constructor label
    mySFile.write("\tpushq %rbx\n");//procedure call/return control flow at the start
    mySFile.write("\tpushq %rbp\n");
    mySFile.write("\tpushq %r12\n");
    mySFile.write("\tpushq %r13\n");
    mySFile.write("\tpushq %r14\n");
    mySFile.write("\tpushq %r15\n");
    mySFile.write("\tsubq $128, %rsp\n");

    mySFile.write("\tmovl $9, %r10d\n");
    mySFile.write("\tmovl %r10d, 0(%rdi)\n"); // max = 9
    mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case printf)
    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
    mySFile.write("\tmovq %r8, 96(%rsp)\n");
    mySFile.write("\tmovq %r9, 104(%rsp)\n");
    mySFile.write("\tmovq %r10, 112(%rsp)\n");
    mySFile.write("\tmovq %r11, 120(%rsp)\n");
    mySFile.write("\tmovl $400, %edi\n");
    mySFile.write("\tcall malloc\n");
    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
    mySFile.write("\tmovq 72(%rsp), %rsi\n");
    mySFile.write("\tmovq 80(%rsp), %rdx\n");
    mySFile.write("\tmovq 88(%rsp), %rcx\n");
    mySFile.write("\tmovq 96(%rsp), %r8\n");
    mySFile.write("\tmovq 104(%rsp), %r9\n");
    mySFile.write("\tmovq 112(%rsp), %r10\n");
    mySFile.write("\tmovq 120(%rsp), %r11\n");
    mySFile.write("\tmovq %rax, 4(%rdi)\n"); //space for stack
    mySFile.write("\tmovl $0,(%rax)\n");//initialize 9 locations to zero
    mySFile.write("\tmovl $0,4(%rax)\n");
    mySFile.write("\tmovl $0,8(%rax)\n");
    mySFile.write("\tmovl $0,12(%rax)\n");
    mySFile.write("\tmovl $0,16(%rax)\n");
    mySFile.write("\tmovl $0,20(%rax)\n");
    mySFile.write("\tmovl $0,24(%rax)\n");
    mySFile.write("\tmovl $0,28(%rax)\n");
    mySFile.write("\tmovl $0,32(%rax)\n");
    mySFile.write("\tmovl $0, %r10d\n");
    mySFile.write("\tmovl %r10d, 12(%rdi)\n"); //stack top = 0

    mySFile.write("."+_$2+"_construct_return:\n");
    mySFile.write("\taddq $128, %rsp\n");
    mySFile.write("\tpopq %r15\n");
    mySFile.write("\tpopq %r14\n");
    mySFile.write("\tpopq %r13\n");
    mySFile.write("\tpopq %r12\n");
    mySFile.write("\tpopq %rbp\n");
    mySFile.write("\tpopq %rbx\n");
    mySFile.write("\tret\n");
    mySFile.write("\t.size   "+_$2+"_construct, .-"+_$2+"_construct\n");

    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR FOR CLASS ID");
 }
	}
	public void startMython(){
        try{ FileWriter mySFile = new FileWriter(outputname,true);
            if(not_in_main==0){//not in main is false meaning it is true that in main
                mySFile.write("\t.text\n");
                mySFile.write(".globl mython\n");
                mySFile.write("\t.type mython, @function\n");
                mySFile.write("mython:\n");
                mySFile.write("\tpushq %rbx\n");//procedure call/return control flow at the start
                mySFile.write("\tpushq %rbp\n");
                mySFile.write("\tpushq %r12\n");
                mySFile.write("\tpushq %r13\n");
                mySFile.write("\tpushq %r14\n");
                mySFile.write("\tpushq %r15\n");
                mySFile.write("\tsubq $128, %rsp\n");
                mySFile.close();//ALWAYS remember to close after write
            }}
            catch(IOException e){System.out.println("WRITE ERROR FOR MAIN MYTHON!");}
	}
	public void noParamFuncCall(String _$1){ //for production exp: ID()
        try{
    FileWriter mySFile = new FileWriter(outputname,true);
    //mySFile.write("");
    mySFile.write("\tmovq %rdi, 64(%rsp)\n");
    mySFile.write("\tmovq %rsi, 72(%rsp)\n");
    mySFile.write("\tmovq %rdx, 80(%rsp)\n");
    mySFile.write("\tmovq %rcx, 88(%rsp)\n");
    mySFile.write("\tmovq %r8, 96(%rsp)\n");
    mySFile.write("\tmovq %r9, 104(%rsp)\n");
    mySFile.write("\tmovq %r10, 112(%rsp)\n");
    mySFile.write("\tmovq %r11, 120(%rsp)\n");
    mySFile.write("\tcall "+_$1+"\n");
    mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
    mySFile.write("\tmovq 72(%rsp), %rsi\n");
    mySFile.write("\tmovq 80(%rsp), %rdx\n");
    mySFile.write("\tmovq 88(%rsp), %rcx\n");
    mySFile.write("\tmovq 96(%rsp), %r8\n");
    mySFile.write("\tmovq 104(%rsp), %r9\n");
    mySFile.write("\tmovq 112(%rsp), %r10\n");
    mySFile.write("\tmovq 120(%rsp), %r11\n");
    mySFile.close();
 }
 catch(IOException e){
    System.out.println("WRITE ERROR for exp:ID()");
 }
	}
	public void NonNumLocalVar(String _$3,String _$1){
	    String src="";
	    if(prm.contains(_$3)){
            //non numeric local var is assigned to an identifier that is a parameter
            if(prm.indexOf(_$3)==0){
                src= "%edi";
            }
            else if(prm.indexOf(_$3)==1){
                src = "%esi";
            }
            else if(prm.indexOf(_$3)==2){
                src = "%edx";
            }
            else if(prm.indexOf(_$3)==3){
                src = "%ecx";
            }
            else if(prm.indexOf(_$3)==4){
                src = "%r8d";
            }
        try{
        FileWriter mySFile = new FileWriter(outputname ,true);
        mySFile.write("\tmovl "+src+", "+String.valueOf(rspOffset)+"(%rsp)\n");//take edi and put it in the stack offset
        mySFile.close();
        rspOffset+=4;//increment offset of the stack pointer by 4, this needs to be reset at the end of the function
        stackOffsetInfo.put(_$1,/*Integer.parseInt(_$3)*/9001);//to get the offset of the stored value for the variable you perform stackOffsetInfo.indexOf($1)*4
        //9001 will represent a local variable assigned to a parameter
        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR LOCAL VAR ASSIGNED TO numeric value");
        }
	    }
	}
    public int calcLocalStackOffset(String key){ //use this helper method to calculate indexOf a key in the stackOffset and take the index multiplied by 4 to get the actual offset(%rsp)
        int ans = 0;
        for(String k:stackOffsetInfo.keySet()){
            if(!k.equals(key)){
                ans++;
            }
            else{
                //once keys match break
                break;
            }
        }
        return ans;
    }
    public void returnFunctionResult(){
        //return function result
        try{
        FileWriter mySFile = new FileWriter(outputname, true);
        mySFile.write("\tmovl %eax, %eax\n");
        mySFile.write("\tjmp ."+ lexer.functions.get(lexer.functions.size()-1)+"_return\n");
        mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR RETURN NON NUMERIC CASE");
        }
    }
    public void localVarInput(String _$1){//for local variables that are assigned to input
        try{//must check if local variable has already been declared, if so then find the offset and modify the offset. otherwise set new offset
            FileWriter mySFile = new FileWriter(outputname, true);
            if(stackOffsetInfo.containsKey(_$1)){
                //if already been defined
                int off = calcLocalStackOffset(_$1);
                mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case scanf)
                mySFile.write("\tmovq %rsi, 72(%rsp)\n");
                mySFile.write("\tmovq %rdx, 80(%rsp)\n");
                mySFile.write("\tmovq %rcx, 88(%rsp)\n");
                mySFile.write("\tmovq %r8, 96(%rsp)\n");
                mySFile.write("\tmovq %r9, 104(%rsp)\n");
                mySFile.write("\tmovq %r10, 112(%rsp)\n");
                mySFile.write("\tmovq %r11, 120(%rsp)\n");

                mySFile.write("\tmovl $mython_input, %esi\n"); //parameter 2 in %rsi/esi
                mySFile.write("\tmovq S0(%rip), %rdi\n"); //parameter 1 in %rdi/edi
                mySFile.write("\tmovl $0, %eax\n");
                mySFile.write("\tcall __isoc99_scanf\n");

                mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
                mySFile.write("\tmovq 72(%rsp), %rsi\n");
                mySFile.write("\tmovq 80(%rsp), %rdx\n");
                mySFile.write("\tmovq 88(%rsp), %rcx\n");
                mySFile.write("\tmovq 96(%rsp), %r8\n");
                mySFile.write("\tmovq 104(%rsp), %r9\n");
                mySFile.write("\tmovq 112(%rsp), %r10\n");
                mySFile.write("\tmovq 120(%rsp), %r11\n");

                mySFile.write("\tmovl mython_input(%rip),%eax\n");
                mySFile.write("\tmovl %eax, "+String.valueOf(off)+"(%rsp)\n");
            }
            else if(!local_table.containsKey(_$1) && !stackOffsetInfo.containsKey(_$1)){
                //local variable is not contained in the table meaning it is a new local var
                stackOffsetInfo.put(_$1,9001);
                local_table.put(_$1,"0000");
                mySFile.write("\tmovq %rdi, 64(%rsp)\n");//at call point, before load parameters for a function call (in this case scanf)
                mySFile.write("\tmovq %rsi, 72(%rsp)\n");
                mySFile.write("\tmovq %rdx, 80(%rsp)\n");
                mySFile.write("\tmovq %rcx, 88(%rsp)\n");
                mySFile.write("\tmovq %r8, 96(%rsp)\n");
                mySFile.write("\tmovq %r9, 104(%rsp)\n");
                mySFile.write("\tmovq %r10, 112(%rsp)\n");
                mySFile.write("\tmovq %r11, 120(%rsp)\n");

                mySFile.write("\tmovl $mython_input, %esi\n"); //parameter 2 in %rsi/esi
                mySFile.write("\tmovq S0(%rip), %rdi\n"); //parameter 1 in %rdi/edi
                mySFile.write("\tmovl $0, %eax\n");
                mySFile.write("\tcall __isoc99_scanf\n");

                mySFile.write("\tmovq 64(%rsp), %rdi\n"); //after the function call move from the stack to registers
                mySFile.write("\tmovq 72(%rsp), %rsi\n");
                mySFile.write("\tmovq 80(%rsp), %rdx\n");
                mySFile.write("\tmovq 88(%rsp), %rcx\n");
                mySFile.write("\tmovq 96(%rsp), %r8\n");
                mySFile.write("\tmovq 104(%rsp), %r9\n");
                mySFile.write("\tmovq 112(%rsp), %r10\n");
                mySFile.write("\tmovq 120(%rsp), %r11\n");

                mySFile.write("\tmovl mython_input(%rip),%eax\n");
                mySFile.write("\tmovl %eax, "+String.valueOf(rspOffset)+"(%rsp)\n");
                rspOffset+=4;
            }
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR LOCAL VARIABLE ASSIGNED TO INPUT");
        }
    }
    public void objectFunctionParams(String _$2,String objname){
        //functions of an object that includes parameter loading, _$2 is the name of the function so use format objname_$2
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\t.text\n");
            mySFile.write(".globl "+objname+"_"+_$2+"\n");//updated 4/11
            mySFile.write("\t.type   "+objname+"_"+_$2+", @function\n");
            mySFile.write(objname+"_"+_$2+":\n");
            mySFile.write("\tpushq %rbx\n");
            mySFile.write("\tpushq %rbp\n");
            mySFile.write("\tpushq %r12\n");
            mySFile.write("\tpushq %r13\n");
            mySFile.write("\tpushq %r14\n");
            mySFile.write("\tpushq %r15\n");
            mySFile.write("\tsubq $128, %rsp\n");
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/ PARAMS OF OBJECT");
        }
    }
    public void objectFunctionNoParams(String _$2,String objname){
        //function of an object with no parameters
        try{
            FileWriter mySFile = new FileWriter(outputname, true);
            mySFile.write("\t.text\n");
            mySFile.write(".globl "+objname+"_"+_$2+"\n");
            mySFile.write("\t.type   "+objname+"_"+_$2+", @function\n");
            mySFile.write(objname+"_"+_$2+":\n");
            mySFile.write("\tpushq %rbx\n");
            mySFile.write("\tpushq %rbp\n");
            mySFile.write("\tpushq %r12\n");
            mySFile.write("\tpushq %r13\n");
            mySFile.write("\tpushq %r14\n");
            mySFile.write("\tpushq %r15\n");
            mySFile.write("\tsubq $128, %rsp\n");
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION w/o PARAMS OF OBJECT");
        }
    }
    public void objectFunctionReturn(String _$2,String objname){
        //function return for an object function
        try{
            FileWriter mySFile = new FileWriter(outputname,true);
            mySFile.write("."+objname+"_"+_$2+"_return:\n");//function return
            mySFile.write("\taddq $128, %rsp\n");
            mySFile.write("\tpopq %r15\n");
            mySFile.write("\tpopq %r14\n");
            mySFile.write("\tpopq %r13\n");
            mySFile.write("\tpopq %r12\n");
            mySFile.write("\tpopq %rbp\n");
            mySFile.write("\tpopq %rbx\n");
            mySFile.write("\tret\n");
            mySFile.write("\t.size   "+objname+"_"+_$2+", .-"+objname+"_"+_$2+"\n");
            mySFile.close();
        }
        catch(IOException e){
            System.out.println("WRITE ERROR FOR FUNCTION RETURN w/ PARAMS");
        }
    }
	//main
	public static void main (String [] args) throws IOException {
	    setUpRegs();//set up the registers for usage
	    //System.out.println(args[0].split("."));
	    //String[] splitresult = args[0].split(".");
	    //System.out.println(splitresult[0]);
	    //String ofilename = args[0].split(".")[0]+".s";
	    //System.out.println(ofilename);

	    String ofilename = args[0].substring(0,args[0].lastIndexOf('.'));
	    //System.out.println(ofilename);
        System.out.println("Registers:");//printing registers (total 15)
        System.out.println(registers.keySet());
        System.out.println(SpecialRegisters.keySet());
        //printMap(registers);
        //printMap(SpecialRegisters);
        outputname = ofilename+".s";//this exists so that can append to the output file in the yacc spec
	    try{//initial creation of the output file with .s extension
            FileWriter mySFile = new FileWriter(ofilename+".s");//make a .s file to write to
            ///FileWriter mySFile=new FileWriter("code.s",false);
            //using filewriter
            //mySFile.write(".text\n");
            //mySFile.write(".globl mython\n");
            //mySFile.write(".type mython, @function\n");
            //mySFile.write("mython:\n");
            /*if(not_in_main==0){//not in main is false meaning it is true that in main
                mySFile.write("\t.text\n");
                mySFile.write(".globl mython\n");
                mySFile.write("\t.type mython, @function\n");
                mySFile.write("mython:\n");
            }*/
            mySFile.write("#JY\n");//just add comment for now
            mySFile.close();
	    }
	    catch(IOException e){
            System.out.println("Error IN FILE CREATION!");
            e.printStackTrace();
	    }

		Parser yyparser = new Parser(new FileReader(args[0]));
		yyparser.yyparse(); //lex the tokens
		/*
		if(not_in_main==0){//not in main is false meaning it is true that in main
            mySFile.write(".text\n");
            mySFile.write(".globl mython\n");
            mySFile.write(".type mython, @function\n");
            mySFile.write("mython:\n");
	    }
	    */
		//System.out.println("Line count of inputfile: "+lexer.linecount); //linecount static var
		System.out.println("\nCollected information:\nClasses: "+lexer.classes);
		//System.out.println("Functions: "+lexer.functions);
		//System.out.println("Arguments for functions: "+lexer.params);
		List<String> filestream = Files.readAllLines(Paths.get(args[0])); //using filestream to get another count of lines
		int noOfLines = filestream.size();

		//Part 2 and 3 print outs
		//System.out.println("Identifiers for Variables: "+lexer.ids);
        //System.out.println("Corresponding Values for Variables: "+lexer.vals);
        //System.out.println("Corresponding Types for Variables: "+lexer.types);

        //System.out.println("Array elements to be accessed: "+lexer.arrayElements);
        /*
        int ind = 0;
        for(int i = 0;i<lexer.ids.size();i++){
            for(int j = 0;j<lexer.arrayElements.size();j++){
                    if(lexer.ids.get(i).equals(lexer.arrayElements.get(j).substring(0,1))){
                        ind = i;//find index corresponding to the array
                        int inum = Integer.parseInt(lexer.arrayElements.get(j).substring(2,3));//get the index number
                        arrayElementValues.add(lexer.vals.get(ind).substring(inum*2+1,inum*2+1+1) );//get value from ORIGINAL array
                }
            }

        }
        System.out.println("Corresponding Array element values: "+arrayElementValues);*/
        /// System.out.println("Size of scopes: "+lexer.scopes.size());
        /// System.out.println("Scopes: "+lexer.scopes);//prints out scopes of functions or main class in a mini-paragraph block format
        ///String[] scopearray = lexer.scopes.get(2).split("\n");
        //System.out.println(scopearray.length);
        //System.out.println(scopearray[0]);
        //System.out.println(lexer.scopes.get(0) );
		if(lexer.linecount<noOfLines){//line count is incorrect on error files, so just to maintain a correct count of total lines. This is due to when there are syntactic errors, the parsing stops
            error_check = 1;
            System.out.println("Line count: "+noOfLines);
		}
		else{
            System.out.println("Line count of inputfile: "+lexer.linecount);
		}
		for(String i : symbol_table.keySet()){
            //String s = i.toString();
            System.out.println("Key: "+i+" ,Value: "+symbol_table.get(i));//printing the symbol table
		}

		if(error_check == 0){
            System.out.println("File Accepted");
		}
		else{
            //System.err.println("Error : syntax error at line " + (lexer.linecount-1));
            System.out.println("File Rejected");
            System.exit(1);
		}

		//After accepting the file:
        //mySFile.close();//close written file
        try{//initial creation of the output file with .s extension
            FileWriter mySFile = new FileWriter(ofilename+".s",true);//append
            ///FileWriter mySFile=new FileWriter("code.s",false);
            //using filewriter
            //mySFile.write(".text\n");
            //mySFile.write(".globl mython\n");
            //mySFile.write(".type mython, @function\n");
            //mySFile.write("mython:\n");
            if(not_in_main==0){//not in main is false meaning it is true that in main
                mySFile.write(".mython_return:\n");
                mySFile.write("\taddq $128, %rsp\n");//procedure call/return control flow
                mySFile.write("\tpopq %r15\n");
                mySFile.write("\tpopq %r14\n");
                mySFile.write("\tpopq %r13\n");
                mySFile.write("\tpopq %r12\n");
                mySFile.write("\tpopq %rbp\n");
                mySFile.write("\tpopq %rbx\n");
                mySFile.write("\tret\n");
                mySFile.write("\t.size   mython, .-mython\n");

                mySFile.write("\t.section        .note.GNU-stack,\"\",@progbits\n");
            }
            mySFile.close();
	    }
	    catch(IOException e){
            System.out.println("Error!");
            e.printStackTrace();
	    }
	}
