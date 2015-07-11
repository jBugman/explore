#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <glob.h>
#include <glib.h>
#include "yajl/yajl_tree.h"

char* read_file(char const *filename) {
  FILE *f = fopen(filename, "rb");
  char *buffer = NULL;
  if (f) {
    fseek(f, 0, SEEK_END);
    long length = ftell(f);
    fseek(f, 0, SEEK_SET);
    buffer = malloc(length + 1);
    if (buffer) {
      fread(buffer, 1, length, f);
    }
    fclose(f);
    buffer[length] = '\0';  // Forced end of string
  }
  return buffer;
}

#define CLEANUP_END_EXIT() { \
  globfree(&glob_result); \
  yajl_tree_free(node); \
  exit(EXIT_FAILURE); \
}

void process(char const *field, char const *folder) {
  glob_t glob_result;
  gchar* search_path = g_build_path(G_DIR_SEPARATOR_S, folder, "*.json", NULL);
  glob(search_path, GLOB_TILDE, NULL, &glob_result);
  g_free(search_path);
  for(unsigned int i=0; i < glob_result.gl_pathc; ++i) {
    char* path = glob_result.gl_pathv[i];
    char* json_string = read_file(path);
    yajl_val node = yajl_tree_parse((const char *) json_string, NULL, 0);
    free(json_string);
    if (node == NULL) {
      fprintf (stderr, "%s: %s\n", "Malformed JSON", path);
      CLEANUP_END_EXIT()
    }
    const char *json_path[] = {field, NULL};
    yajl_val value = yajl_tree_get(node, json_path, yajl_t_any);
    if (value) {
      if (!YAJL_GET_STRING(value)) {
        fprintf(stderr, "Field is not a string\n");
        CLEANUP_END_EXIT()
      }
      char const* string_value = YAJL_GET_STRING(value);
      if (string_value[0] != '\0') {
        puts(string_value);
      }
      // printf("%s\n", (string_value[0] == '\0') ? "false" : "true");
      // puts(string_value);
    } else {
      fprintf(stderr, "Field is missing\n");
      CLEANUP_END_EXIT()
    }
    yajl_tree_free(node);
  }
  globfree(&glob_result);
}

int main (int argc, char const *argv[]) {
  if (argc < 3) {
    puts("Args are: <field name> <folder>");
    return 1;
  }
  process(argv[1], argv[2]);
  return EXIT_SUCCESS;
}
