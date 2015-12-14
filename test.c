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

extern char const * string_one(const One * const o) {
  char buffer[200];
  snprintf(buffer,200,"One int: %d\n",o->the_int);
  return strdup(buffer);
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

extern char const * string_two(const Two * const o) {
  char buffer[200];
  snprintf(buffer,200,"Two int: %d\nTwo str: %s\n",
           o->parent.the_int,o->string);
  return strdup(buffer);
}

extern void free_two(Two * const o) {
  free(o);
}
