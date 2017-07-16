/*
 * See Licensing and Copyright notice in naev.h
 */


#ifndef GLUE_MACOS_H
#  define GLUE_MACOS_H


#include <stddef.h>


int macos_isBundle ();
int macos_resourcesPath ( char *res, size_t n );

int macos_configPath ( char *res, size_t n );
int macos_dataPath ( char *res, size_t n );
int macos_cachePath ( char *res, size_t n );

char * macos_fontFind ( const char *cName, unsigned int h );
char * macos_fontDefault ( unsigned int h );
char * macos_fontMonospace ( unsigned int h );

#endif /* GLUE_MACOS_H */
