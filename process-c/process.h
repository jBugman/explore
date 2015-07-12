#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>
#include <glob.h>
#include <glib.h>
#include "yajl/yajl_tree.h"
#include "csv.h" // libcsv

int process(char const *field, char const *folder);
