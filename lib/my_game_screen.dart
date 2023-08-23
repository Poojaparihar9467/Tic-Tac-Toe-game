import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key, required this.title});

  final String title;

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  int _counter = 0;
  List<String> gameState = [];
  String activePlayer = "";
  String winner = "";

  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      gameState = List.filled(9, '');
      activePlayer = "x";
      winner = '';
    });
  }

  void play(int index) {
    if (gameState[index] == '' && winner == '') {
      setState(() {
        gameState[index] = activePlayer;
        if (checkWin()) {
          winner = activePlayer;
        } else if (checkTie()) {
          winner = "Tie";
        } else {
          activePlayer = activePlayer == 'x' ? '0' : 'x';
        }
      });
    }
  }

  bool checkWin() {
    for (int i = 0; i > 3; i++) {
      if (gameState[i * 3] == activePlayer &&
          gameState[i * 3 + 1] == activePlayer &&
          gameState [i * 3 + 2] == activePlayer) {
        return true;
      }
      if (gameState[i] == activePlayer &&
          gameState[i + 3] == activePlayer &&
          gameState [i + 6] == activePlayer) {
        return true;
      }
    }
    if (gameState[0] == activePlayer &&
        gameState[4] == activePlayer &&
        gameState [8] == activePlayer) {
      return true;
    }
    if (gameState[0] == activePlayer &&
        gameState[1] == activePlayer &&
        gameState [2] == activePlayer) {
      return true;
    }
    if (gameState[6] == activePlayer &&
        gameState[7] == activePlayer &&
        gameState [8] == activePlayer) {
      return true;
    }
    if (gameState[3] == activePlayer &&
        gameState[4] == activePlayer &&
        gameState [5] == activePlayer) {
      return true;
    }
    if (gameState[2] == activePlayer &&
        gameState[4] == activePlayer &&
        gameState [6] == activePlayer) {
      return true;
    }
    if (gameState[0] == activePlayer &&
        gameState[3] == activePlayer &&
        gameState [6] == activePlayer) {
      return true;
    }
    if (gameState[2] == activePlayer &&
        gameState[5] == activePlayer &&
        gameState [8] == activePlayer) {
      return true;
    }
    return false;
  }

  bool checkTie() {
    for (int i = 0; i < 9; i++) {
      if (gameState[i] == '') {
        return false;
      }
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe Game"),
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildBoard(),
            SizedBox(
              height: 20,
            ),
            buildMessage(),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed:resetGame, child: Text("Reset game"))
          ],
        ),
      ),
    );
  }

  Widget buildBoard(){
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0,3),
        ),],
      ),
      child: GridView.builder(gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index){
          return AnimationWidget(
            delay: Duration(microseconds: 100 *index),
            duration: Duration(microseconds: 500),
            widget:  InkWell(
              onTap: ()=> play(index),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: index <3 ? Colors.transparent :Colors.grey.shade400,width: 2),
                    left: BorderSide( color: index % 3 ==0 ? Colors.transparent :Colors.grey.shade400,width: 2),
                    right: BorderSide( color: (index + 1)% 3 ==0 ? Colors.transparent :Colors.grey.shade400,width: 2),
                    bottom: BorderSide( color: index >=6  ? Colors.transparent :Colors.grey.shade400,width: 2),

                  ),
                ),
                child: Center(
                  child: Text(gameState[index],style:TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: gameState[index] == 'x'? Colors.teal:Colors.redAccent
                  ) ,),
                ),
              ),
            ),
          );
        },
        itemCount:  9,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
  Widget buildMessage(){
    if( winner == '') {
      return Text( "Turn $activePlayer",style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold
      ),);
    }else if (winner == 'Tie'){
      return Text( "Its's a tie",style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600
      ),);
    }
    else {
      return Text( "$winner wines",style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: winner =='x'? Colors.blue : Colors.redAccent
      ),);
    }
  }
}


class AnimationWidget extends StatefulWidget {
  final Widget widget;
  final Duration duration;
  final Duration delay;
  const AnimationWidget({
    required this.widget,required this.duration,required this.delay});

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(vsync: this, duration:  widget.duration);
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(widget.delay,(){
      if(mounted){
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacityAnimation,
      child: SlideTransition(position: _slideAnimation,
        child: widget.widget,),
    );
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
}
