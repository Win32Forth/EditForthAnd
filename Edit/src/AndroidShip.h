#ifndef EDITFORTHAND_ANDROIDSHIP_H
#define EDITFORTHAND_ANDROIDSHIP_H

#include <QString>

// Copy packaged Forth Resources (assets:/EditForthAnd) into app storage.
// Returns the writable root (…/EditForthAnd) that holds Library, AutoLoad, Docs.
QString ensureAndroidShippedResources();

#endif
