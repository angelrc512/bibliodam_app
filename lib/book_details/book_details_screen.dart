import 'package:bibliodam_app/model/book.dart';
import 'package:bibliodam_app/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailScreen extends StatelessWidget {
  final Book _book;
  const BookDetailScreen(this._book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle Libro"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BookCoverWidget(_book.coverUrl),
              BookInfoWidget(_book.title, _book.author, _book.description),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: BookActionsWidget(_book.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookActionsWidget extends StatelessWidget {
  final String bookId;

  const BookActionsWidget(this.bookId, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookshelfBloc, BookshelfState>(
      builder: (context, BookshelfState) {
        var action = () => _addToBookshelf(context, bookId);
        var label = "Agregar a la estantería";
        var color = Colors.green;

        if (BookshelfState.bookIds.contains(bookId)) {
          action = () => _removeFromBookShelf(context, bookId);
          label = "Quitar de mi estante";
          color = Colors.amber;
        }
        return ElevatedButton(
          onPressed: action,
          child: Text(label),
          style: ElevatedButton.styleFrom(backgroundColor: color),
        );
      },
    );
  }

  void _addToBookshelf(BuildContext context, String bookId) {
    var bookshelfBloc = context.read<BookshelfBloc>();
    bookshelfBloc.add(AddBookToBookshelf(bookId));
  }

  void _removeFromBookShelf(BuildContext context, String bookId) {
    var bookshelfBloc = context.read<BookshelfBloc>();
    bookshelfBloc.add(RemoveBookFromBookshelf(bookId));
  }
}

class BookInfoWidget extends StatelessWidget {
  final String _title;
  final String _author;
  final String _description;

  const BookInfoWidget(this._title, this._author, this._description,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Text(
            _title,
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 5),
          Text(
            _author,
            style: Theme.of(context).textTheme.headlineMedium!,
          ),
          SizedBox(height: 20),
          Text(
            _description,
            style:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class BookCoverWidget extends StatelessWidget {
  final String _coverUrl;
  const BookCoverWidget(this._coverUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      width: 230,
      child: Image.asset(_coverUrl),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 20,
          blurRadius: 10,
        )
      ]),
    );
  }
}
