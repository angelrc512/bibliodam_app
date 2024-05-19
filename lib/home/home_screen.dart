import 'package:bibliodam_app/book_details/book_details_screen.dart';
import 'package:bibliodam_app/model/book.dart';
import 'package:bibliodam_app/services/books_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List <Book> _books = [];
  @override
  void initState() {
    super.initState();
    _getLastBooks();
  }
  void _getLastBooks() async { 
    var lastBooks = await BooksService().getLastBooks();
    setState(() {
      _books = lastBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    var showProgress = _books.isEmpty;
    var listLength = showProgress ? 3 :  _books.length + 2;
    return Container(
      margin: EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: listLength,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const HeaderWidget();
          }
          if (index == 1) {
            return const ListItemHeader();
          }
          if (showProgress){
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: LinearProgressIndicator(),),
            );
          }
          return ListItemBook(_books[index - 2]);
        },
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('assets/images/header.jpg'));
  }
}

class ListItemHeader extends StatelessWidget {
  const ListItemHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 10, left: 5),
          child: const Text(
            "Últimos Libros añadidos",
            
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}

class ListItemBook extends StatelessWidget {
  final Book _book;
  const ListItemBook(this._book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 170,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          
          onTap: () {
            _openBookDetails(context, _book);
          },
          child: Container(
            color: Color.fromARGB(255, 244, 221, 152),
            
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Image.asset(_book.coverUrl, width: 120,),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_book.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(fontSize: 20),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                            ),
                            
            
                        SizedBox(height: 5),
                        Text(_book.author,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontSize: 10)),
                        SizedBox(height: 15),
                        Text(_book.description,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openBookDetails(BuildContext context, Book book) {
    Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => BookDetailScreen(book)));
  }
}