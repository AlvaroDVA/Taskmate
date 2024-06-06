import 'package:taskmate_app/models/notebook_page.dart';
import 'package:taskmate_app/models/user.dart';
import 'package:taskmate_app/services/service_locator.dart';
import 'package:taskmate_app/states/auth_state.dart';

import '../rest/notebook_api_rest.dart';

class NotebookService {

  NotebookApiRest notebookApiRest = ServiceLocator.notebookApiRest;

  Future<List<NotebookPage>> getAllPages(User? currentUser) async {
    if (currentUser != null) {
      Map<String, dynamic> json = await notebookApiRest.getAllPages(currentUser);
      List<NotebookPage> pages = [];
      if (json['pages'] != null) {
        json['pages'].forEach((elementJson) {
          pages.add(NotebookPage.fromJson(elementJson));
        });
      }
      return pages;
    }
    return [];
  }

  Future<void> savePages(List<NotebookPage> pages, User? currentUser) async {
    if (currentUser != null) {
      await notebookApiRest.saveAllPages(pages, currentUser);
    }
  }

}

