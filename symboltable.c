#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>


enum declarationElementType { constant, variable, function, class };

struct FunctionParam {
        char* name;
        char* type;
        bool isVector;
        struct FunctionParam* nextParam;
} *currentFunctionParameterListHead;


typedef struct declaration{
    char * identifier; 
    char * type;
    enum declarationElementType elementType;
    struct FunctionParam* paramsListHead;
}declaration;

typedef struct declaration_list{
    declaration* dec;
    struct declaration_list * next;
}declaration_list;

typedef struct symbol_table{
    char* scope;
    declaration_list *dec_list;
    struct symbol_table * next; 
}symbol_table;

symbol_table * st= NULL;

addFunctionParameterToCurrentFunctionParameterListHead( char* name, char* type, bool isVector){
        struct FunctionParam* newParam = malloc(sizeof(struct FunctionParam));
        newParam->name = name;
        newParam->type = type;
        newParam->isVector = isVector;
        if(currentFunctionParameterListHead == NULL){
                currentFunctionParameterListHead = newParam;
        } else {
                while(currentFunctionParameterListHead->nextParam != NULL) {
                        currentFunctionParameterListHead = currentFunctionParameterListHead->nextParam;
                }
                currentFunctionParameterListHead->nextParam = newParam;
        }
        //DEBUG
        // printf("Am adaugat parametrul %s de tipul %s\n", newParam->name, newParam->type);
}

// declaration functions ; 
declaration * create_declaration(char* identifier, char* type , enum declarationElementType elementType){
    declaration * temp= malloc(sizeof(struct declaration));
    temp->identifier = identifier;
    temp->type = type;
    temp->elementType = elementType;
    if(elementType == function) {
        temp->paramsListHead = currentFunctionParameterListHead;
    }
    return temp;
}
void print_dec_info(declaration* dec){
    printf("id : %s , type : %s\n",dec->identifier,dec->type);
}

//declaration list functions ; 
void dec_list_print(declaration_list * start){
    declaration_list * temp =start;
    while(temp!=NULL){
        print_dec_info(temp->dec);
        temp=temp->next;
    }
}
declaration_list* declaration_finder(char* identifier , declaration_list* dec_list){
    declaration_list* temp=dec_list;
    while(temp !=NULL){
        if(strcmp(temp->dec->identifier,identifier)==0)return temp;
        temp=temp->next;
    }
    return NULL;
}

bool add_to_dec_list(declaration_list**start, declaration* dec){
    declaration_list * declaration_list_to_add_in = declaration_finder(dec->identifier, *start);
    if(declaration_list_to_add_in==NULL){
        declaration_list_to_add_in=malloc(sizeof(declaration_list));
        declaration_list_to_add_in->next=*start;
        declaration_list_to_add_in->dec=dec;
        *start=declaration_list_to_add_in;
        return true; 
    }
    return false; 
}
//symboltable functions ;
symbol_table* scope_finder( char* scope , symbol_table* start ){
    symbol_table* temp =start; 
    while(temp != NULL){
        if(strcmp(temp->scope,scope)==0){
            return temp;
        }
        temp=temp->next;
    }
    return NULL;
}
bool add_to_symbol_table(symbol_table** start , char*scope, declaration* new_declaration){
    symbol_table * scope_to_add_in=scope_finder(scope,*start);
    if(scope_to_add_in==NULL){
        scope_to_add_in=malloc(sizeof(symbol_table));
        scope_to_add_in->next=*start;
        scope_to_add_in->scope=realloc(scope_to_add_in->scope,strlen(scope));
        strcpy(scope_to_add_in->scope,scope);
        *start=scope_to_add_in;
    }
    return add_to_dec_list(&scope_to_add_in->dec_list,new_declaration);
}

void print_symbol_table(symbol_table *start){
    symbol_table* temp = start; 
    while(temp!=NULL){
        printf("Scope : %s\n\n",temp->scope);
        dec_list_print(temp->dec_list);
        temp=temp->next;
        printf("------------------------------\n");
    }
}

declaration* declaration_finder_in_symbol_table(symbol_table* start, char* identifier){
    symbol_table * temp = start;
    declaration_list* res;
    while(temp!=NULL){
        if((res=declaration_finder(identifier,temp->dec_list))!=NULL) return res->dec;
        temp=temp->next;
    }
    return NULL;
}

    

