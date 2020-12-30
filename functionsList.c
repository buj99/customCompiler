
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

struct FunctionParam {
        char* name;
        char* type;
        bool isVector;
        struct FunctionParam* nextParam;
} *currentFunctionParameterListHead;

struct FunctionNode {
        char* name;
        struct FunctionParam* paramsListHead;
        char* returnType;
        struct FunctionNode* nextNode;
} *functionsListHead;

addFunctionToFunctionsListHead(char* name, struct FunctionParam* paramsListHead, char* returnType ) {
    struct FunctionNode* functionNode = malloc(sizeof(struct FunctionNode));
        functionNode->name = name;
        functionNode->paramsListHead = paramsListHead;
        paramsListHead = NULL;
        functionNode->returnType = returnType;
        if(functionsListHead == NULL) {
                functionsListHead = functionNode;
        } else {
               
                struct FunctionNode* aux = functionsListHead;
                while(aux->nextNode != NULL) {
                        aux = aux->nextNode;
                }
                aux->nextNode = functionNode; 
        }

        //DEBUG
        if(functionNode->paramsListHead == NULL)
        {
                printf("Am adaugat functia %s fara parametri iar tipul returnat este %s\n", 
                functionNode->name, functionNode->returnType);
        } else {
                printf("Am adaugat functia %s cu parametrii ", functionNode->name);
                struct FunctionNode* aux = functionNode->paramsListHead;
                while(aux != NULL) {
                        printf("%s, ", aux->name);
                        aux = aux->nextNode;
                }
                printf("iar tipul returnat este %s\n", functionNode->returnType);
        }
}


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