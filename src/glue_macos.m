/*
 * See Licensing and Copyright notice in naev.h
 */

/**
 * @file glue_macos
 *
 * @brief Support code for macOS
 *
 * The functions here deal with the macOS parts that call into Objective-C land.
 */


#include "glue_macos.h"
#include <AppKit/AppKit.h>


/**
 * @brief Write an NSString to a C buffer
 */
static int macos_writeString ( NSString *str, char *res, size_t n )
{
   BOOL ok = [str getCString:res
                   maxLength:n
                    encoding:NSUTF8StringEncoding];
   return ok ? 0 : -1;
}


/**
 * @brief Determine if we're running from inside an app bundle
 */
int macos_isBundle ()
{
   NSString *path = [[NSBundle mainBundle] bundlePath];
   return [path hasSuffix:@".app"] ? 1 : 0;
}

/**
 * @brief Get the path to the bundle resources directory
 */
int macos_resourcesPath ( char *res, size_t n )
{
   NSString *path = [[NSBundle mainBundle] resourcePath];
   return macos_writeString( path, res, n );
}


/**
 * @brief Get the path to the specified user directory
 */
static int macos_userLibraryDir ( NSString *kind, char *res, size_t n )
{
   NSString *path = [@[
      NSHomeDirectory(),
      @"/Library/",
      kind,
      @"/org.naev.Naev/"
   ] componentsJoinedByString:@""];
   return macos_writeString( path, res, n );
}


/**
 * @brief Get the config directory path
 */
int macos_configPath ( char *res, size_t n )
{
   return macos_userLibraryDir( @"Preferences", res, n );
}


/**
 * @brief Get the data directory path
 */
int macos_dataPath ( char *res, size_t n )
{
   return macos_userLibraryDir( @"Application Support", res, n );
}


/**
 * @brief Get the cache directory path
 */
int macos_cachePath ( char *res, size_t n )
{
   return macos_userLibraryDir( @"Caches", res, n );
}


/**
 * @brief Get path element of a font descriptor URL
 */
static char * macos_fontPath ( NSFontDescriptor *desc )
{
   CTFontDescriptorRef fontDesc = (__bridge CTFontDescriptorRef) desc;
   NSURL *url = CFBridgingRelease( CTFontDescriptorCopyAttribute( fontDesc, kCTFontURLAttribute ) );

   if (![[url scheme] isEqualToString:@"file"])
      return NULL;

   const char *path = [[url path] cStringUsingEncoding:NSUTF8StringEncoding];
   return strdup( path );
}


/**
 * Find a font by name, and get its path
 */
char * macos_fontFind ( const char *cName, unsigned int h )
{
   NSString *name = [NSString stringWithUTF8String:cName];
   return macos_fontPath([NSFontDescriptor fontDescriptorWithName:name size:h]);
}


/**
 * @brief Get the path to the default system font
 */
char * macos_fontDefault ( unsigned int h )
{
   return macos_fontPath([[NSFont userFontOfSize:h] fontDescriptor]);
}


/**
 * @brief Get the path to the default monospace font
 */
char * macos_fontMonospace ( unsigned int h )
{
   return macos_fontPath([[NSFont userFixedPitchFontOfSize:h] fontDescriptor]);
}
