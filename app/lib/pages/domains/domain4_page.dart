import 'package:flutter/material.dart';
import 'dart:math';



class Dom4Page extends StatefulWidget {
  const Dom4Page({super.key});

  @override
  State<Dom4Page> createState() => Page4();
};

class Page4 extends State<Dom4Page>{
    bool showStartButton = true;
    List<List<int> > matrix = List.generate(
    4,
    (_) => List.filled(5, 0), 
    );

    int buttonAct = 0;

    final Random random = Random();

    @override

    void clearMatrix (){
        for(int i = 0; i<4; i++){
            for(int j = 0; j<5; j++){
                matrix[i] [j] = 0;
            }
        }
    }
    

    void positionNumbers (){
        for(int i = 1; i<11; i++){
            int r = random.nextInt(20);
            if(matrix[r/4] [r%5] == 0){
                matrix[r/4] [r%5] = i;
            }
            else{
                i--;
            }
        }
    }

    @override

    class ButtonNum {

        final int value;
        bool active = true;

        @override

        bjuttonNum(this.value);

        void check (){

            if(this.value == buttonAct - 1){
                
                this.active = false;
            }

        }

        @override
        Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
            child: active
                ? ElevatedButton(
                    onPressed: () {
                        setState(() {
                        active = false; // desapareix el botó
                        });
                    },
                    child: const Text('$value'),
                )
            ),
        );
        }
    };


    @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Dom4')),
        body: Center(
        child: showStartButton
            ? ElevatedButton(
                onPressed: () {
                    setState(() {
                    showStartButton = false; // desapareix el botó
                    clearMatrix();
                    positionNumbers(); // inicialitza la matriu
                    });
                },
                child: const Text('Començar Prova'),
                )
        ),
    );
    }


};
