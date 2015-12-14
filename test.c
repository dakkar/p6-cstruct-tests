#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

typedef struct One {
  int32_t the_int;
} One;

typedef struct Two {
  One parent;
  const char *string;
} Two;

extern One* new_one(int x) {
  One* ret;
  ret=(One*)malloc(sizeof(One));
  ret->the_int=x;
  return ret;
}

extern void print_one(const One * const o) {
  printf("One int: %d\n",o->the_int);
}

extern void free_one(One * const o) {
  free(o);
}

extern Two* new_two(int x,const char * const s) {
  Two* ret;
  ret=(Two*)malloc(sizeof(Two));
  ret->parent.the_int=x;
  ret->string=strdup(s);
  return ret;
}

extern void print_two(const Two * const o) {
  printf("Two int: %d\n",o->parent.the_int);
  printf("Two str: %s\n",o->string);
}

extern void free_two(Two * const o) {
  free(o);
}
