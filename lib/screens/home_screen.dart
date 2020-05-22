import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:net_new/blocs/interacoes_bloc.dart';
import 'package:net_new/screens/relatorios_screen.dart';
import 'package:net_new/screens/settings_screen.dart';
import 'new_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController _pageController;
  int _page = 0;
  InteracoesBloc _interacoesBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _interacoesBloc = InteracoesBloc();
  }

  @override
  void dispose() {
    _pageController = PageController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.blue,
            primaryColor: Colors.white,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.white54)
            )
        ),
        child: BottomNavigationBar(
            currentIndex: _page,
            onTap: (p) {
              _pageController.animateToPage(
                  p,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease
              );
            },
            items:[
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text("Relatório"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add),
                title: Text("Cadastrar"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                title: Text("Configurações"),
              )
            ]
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (p) {
          setState(() {
            _page = p;
          });
        },
        children: <Widget>[
          RelatorioScreen(),
          NewScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }

}
