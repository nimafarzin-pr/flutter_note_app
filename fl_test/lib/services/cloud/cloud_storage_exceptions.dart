class CloudStorageException implements Exception {
  CloudStorageException();
}

// c in crud
class CloudNotCreateNoteException extends CloudStorageException {}

//r in crud
class CloudNotGetAllNotesException extends CloudStorageException {}

//u in crud
class CloudNotUpdateNoteException extends CloudStorageException {}

//d in crud
class CloudNotDeleteNoteException extends CloudStorageException {}
