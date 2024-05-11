import 'dart:io';

sealed class TaskException implements Exception {

  final String message;

  TaskException(this.message);

}

class TaskJsonException extends TaskException {

  TaskJsonException(super.message);

  @override
  String toString() {
    return "TaskJsonException : $message";
  }

}