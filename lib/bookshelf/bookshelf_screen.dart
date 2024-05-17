import 'package:bibliodam_app/add_book/add_book_screen.dart';
import 'package:bibliodam_app/book_details/book_details_screen.dart';
import 'package:bibliodam_app/model/book.dart';
import 'package:bibliodam_app/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bibliodam_app/services/books_service.dart';

class bookshelfScreen extends StatelessWidget {
  const bookshelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookshelfBloc, BookshelfState>(
        builder: (context, bookshelfState) {
      var emptyListWidget = Center(
          child: Text(
        "No hay libros en la estantería",
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ));

      var mainwidget = bookshelfState.bookIds.isEmpty
          ? emptyListWidget
          : MyBooksGrid(bookshelfState.bookIds);

      return Column(
        children: [
          Expanded(child: mainwidget),
          ElevatedButton(
              onPressed: () {
                _navigateToAddNewBookScreen(context);
              },
              child: const Text("Agregar nuevo libro")),
        ],
      );
    });
  }

  void _navigateToAddNewBookScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddBookScreen(),
        ));
  }
}

class MyBooksGrid extends StatelessWidget {
  final List<String> bookIds;

  const MyBooksGrid(this.bookIds, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: bookIds.length,
        itemBuilder: (context, index) {
          return BookCoverItem(bookIds[index]);
        },
      ),
    );
  }
}

class BookCoverItem extends StatefulWidget {
  final String _bookId;

  const BookCoverItem(this._bookId, {super.key});

  @override
  State<BookCoverItem> createState() => _BookCoverItemState();
}

class _BookCoverItemState extends State<BookCoverItem> {
  Book? _book;

  void initState() {
    super.initState();
    _getBook(widget._bookId);
  }

  void _getBook(String bookId) async {
    var book = await BooksService().getBook(bookId);
    setState(() {
      _book = book;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_book == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return InkWell(
      onTap: () {
        _openBookDetails(_book!, context);
      },
      child: Ink.image(fit: BoxFit.cover, image: AssetImage(_book!.coverUrl)),
    );
  }

  _openBookDetails(Book book, BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BookDetailScreen(book)));
  }
}
