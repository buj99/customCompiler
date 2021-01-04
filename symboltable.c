#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

typedef struct declaration{
    char * identifier; 
    char * type;
    bool is_var;
    bool is_const;
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

// declaration functions ; 
declaration * create_declaration(char* identifier, char* type , bool is_var, bool is_const){
    declaration * temp= malloc(sizeof(declaration));
    temp->identifier=realloc(temp->identifier,sizeof(identifier));
    temp->type=realloc(temp->type,sizeof(type));
    strcpy(temp->identifier,identifier);
    strcpy(temp->type,type);
    temp->is_var= is_var;
    temp->is_const= is_const;
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
declaration_list* declaration_finder(declaration* dec , declaration_list* dec_list){
    declaration_list* temp=dec_list;
    while(temp !=NULL){
        if(strcmp(temp->dec->identifier,dec->identifier)==0)return temp;
        temp=temp->next;
    }
    return NULL;
}

bool add_to_dec_list(declaration_list**start, declaration* dec){
    declaration_list * declaration_list_to_add_in = declaration_finder(dec, *start);
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
bool declaration_finder_in_symbol_table(symbol_table* start, declaration* dec){
}
int main(int argc, char** argv){

    symbol_table * st= NULL;
    declaration* dec1= create_declaration("id1", "int", true , true);
    declaration* dec2= create_declaration("id2", "int", true , true);
    declaration* dec3= create_declaration("id3", "char", true , true);
    declaration* dec4= create_declaration("id4", "char", true , true);
    declaration* dec5= create_declaration("id5", "bool", true , true);
    declaration* dec6= create_declaration("id6", "float", true , true);
    add_to_symbol_table(&st,"global",dec4);
    add_to_symbol_table(&st,"clasa",dec1);
    add_to_symbol_table(&st,"functie",dec3);
    add_to_symbol_table(&st,"structura",dec2);
    add_to_symbol_table(&st,"scope2",dec5);
    add_to_symbol_table(&st,"scope1",dec6);
    add_to_symbol_table(&st,"scope1",dec3);
    add_to_symbol_table(&st,"scope1",dec3);
    print_symbol_table(st);
    
    return 0;
}

