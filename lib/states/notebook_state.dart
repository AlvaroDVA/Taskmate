import 'package:flutter/cupertino.dart';
import 'package:taskmate_app/models/user.dart';

import '../controllers/notebook_controller.dart';
import '../models/notebook_page.dart';
import '../services/service_locator.dart';
import 'auth_state.dart';

class NotebookState extends ChangeNotifier {
  List<NotebookPage> _pages = List<NotebookPage>.empty(growable: true);
  int _currentPageIndex = 0;

  NotebookController notebookController = ServiceLocator.notebookController;
  AuthState authState = ServiceLocator.authState;

  NotebookState() {
    initNotebook();
  }

  int get currentPageIndex => _currentPageIndex;

  NotebookPage get currentPage => _pages[_currentPageIndex];

  List<NotebookPage> get pages => _pages;

  void nextPage() async {
    if (_currentPageIndex == _pages.length - 1) {
      _pages.add(NotebookPage(pageNumber: _pages.length + 1, text: ""));
    }
    _currentPageIndex += 1;

    await saveNotebook();
    notifyListeners();

  }

  void previousPage() async{
    if (_currentPageIndex > 0) {
      _currentPageIndex-=1;
    }
    await saveNotebook();
    notifyListeners();
  }

  void goToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < _pages.length) {
      _currentPageIndex = pageIndex;
      notifyListeners();
    }
  }

  void updateText(String newText) {
    currentPage.text = newText;
    notifyListeners();
  }

  Future<void> initNotebook() async {
    _pages = await notebookController.getAllPages(authState.currentUser);
    if (_pages.isEmpty) {
      _pages.add(NotebookPage(pageNumber: 1, text: ""));
    }
    notifyListeners();
  }

  Future<void> saveNotebook() async {
    await notebookController.savePages(_pages, authState.currentUser);
  }
}

