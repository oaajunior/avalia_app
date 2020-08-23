import 'package:flutter/material.dart';

class DoneEvaluationsView extends StatelessWidget {
  static const routeName = 'avaliacoes_realizadas';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliações Realizadas'),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        width: deviceSize.width,
        height: deviceSize.height,
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
