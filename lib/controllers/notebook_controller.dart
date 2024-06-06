import 'package:taskmate_app/states/auth_state.dart';

import '../models/notebook_page.dart';
import '../models/user.dart';
import '../services/notebook_service.dart';
import '../services/service_locator.dart';

class NotebookController {
  NotebookService notebookService = ServiceLocator.notebookService;

  Future<List<NotebookPage>> getAllPages(User? currentUser) async {
    return await notebookService.getAllPages(currentUser);
  }

  Future<void> savePages(List<NotebookPage> pages, User? currentUser) async {
    return await notebookService.savePages(pages, currentUser);
  }

}

