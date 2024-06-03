import 'package:flutter/cupertino.dart';

import '../models/notebook_page.dart';

class NotebookState extends ChangeNotifier {
  late List<NotebookPage> _pages;
  int _currentPageIndex = 0;

  NotebookState() {
    initNotebook();
  }

  int get currentPageIndex => _currentPageIndex;

  NotebookPage get currentPage => _pages[_currentPageIndex];

  List<NotebookPage> get pages => List.unmodifiable(_pages);

  void nextPage() {
    if (_currentPageIndex < _pages.length - 1) {
      _currentPageIndex+=1;
    }
    notifyListeners();
  }

  void previousPage() {
    if (_currentPageIndex > 0) {
      _currentPageIndex-=1;
    }
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
    _pages = List<NotebookPage>.filled(1, NotebookPage(text: "Texto", pageNumber: 1), growable: true, );
    _pages.add(NotebookPage(text: "Texto 2", pageNumber: 2));
    _pages.add(NotebookPage(text: "Texto 3", pageNumber: 3));
  }
}