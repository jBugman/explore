#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
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

static void free_hash_table_entry(gpointer key, gpointer value, gpointer user_data) {
  g_free(key);
}

typedef struct {
  gchar* key;
  guint count;
} Frequency;

int frequency_comparator(const void *v1, const void *v2) {
  const Frequency *a = (Frequency *)v1;
  const Frequency *b = (Frequency *)v2;
  if (a->count > b->count)
    return -1;
  else if (a->count < b->count)
    return +1;
  else
    return strcmp(a->key, b->key);
}

#define FREE_HASHTABLE(x) { \
  g_hash_table_foreach(x, free_hash_table_entry, NULL); \
  g_hash_table_destroy(x); \
}

#define CLEANUP_END_EXIT() { \
  globfree(&glob_result); \
  yajl_tree_free(node); \
  FREE_HASHTABLE(frequencies); \
  exit(EXIT_FAILURE); \
}

void process(char const *field, char const *folder) {
  glob_t glob_result;
  gchar* search_path = g_build_path(G_DIR_SEPARATOR_S, folder, "*.json", NULL);
  glob(search_path, GLOB_TILDE, NULL, &glob_result);
  g_free(search_path);
  GHashTable *frequencies = g_hash_table_new(g_str_hash, g_str_equal);
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
    yajl_val field_value = yajl_tree_get(node, json_path, yajl_t_any);
    if (field_value) {
      if (!YAJL_GET_STRING(field_value)) {
        fprintf(stderr, "Field is not a string\n");
        CLEANUP_END_EXIT()
      }
      char const* key_string = YAJL_GET_STRING(field_value);
      if (key_string[0] != '\0') {
        gpointer ok, ov = NULL;
        gint value = 1;
        gpointer key = g_strdup(key_string);
        if (g_hash_table_lookup_extended(frequencies, key, &ok, &ov)) {
            value = GPOINTER_TO_INT(ov) + 1;
            g_hash_table_insert(frequencies, ok, GINT_TO_POINTER(value));
            g_free(key);
        } else {
          g_hash_table_insert(frequencies, key, GINT_TO_POINTER(value));
        }
      }
    } else {
      fprintf(stderr, "Field is missing\n");
      CLEANUP_END_EXIT()
    }
    yajl_tree_free(node);
  }
  globfree(&glob_result);

  guint size = g_hash_table_size(frequencies);
  Frequency sorted[size];
  GHashTableIter iter;
  gpointer key, value;
  g_hash_table_iter_init(&iter, frequencies);
  for(guint i = 0; g_hash_table_iter_next(&iter, &key, &value); i++) {
    sorted[i] = (Frequency){ (char*)key, GPOINTER_TO_INT(value) };
  }
  qsort(sorted, size, sizeof(Frequency), frequency_comparator);
  for(guint i = 0; i < size; i++) {
    printf("%s %d\n", sorted[i].key, sorted[i].count);
  }
  FREE_HASHTABLE(frequencies)
}

int main (int argc, char const *argv[]) {
  if (argc < 3) {
    puts("Args are: <field name> <folder>");
    return 1;
  }
  process(argv[1], argv[2]);
  return EXIT_SUCCESS;
}
