import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../layout/layout_page.dart';
import '../../../res/colors.dart';
import 'perform_evaluation_questions_view.dart';
import '../../../model/evaluation/evaluation_model.dart';

class PerformEvaluationPrepareView extends StatefulWidget {
  static const routeName = '/perform_evaluation_prepare';
  final EvaluationModel evaluation;
  PerformEvaluationPrepareView(this.evaluation);
  @override
  _PerformEvaluationPrepareViewState createState() =>
      _PerformEvaluationPrepareViewState();
}

class _PerformEvaluationPrepareViewState
    extends State<PerformEvaluationPrepareView> {
  double counterSeconds = 1.0;
  int timeToShow = 10;
  int timeToCounter = 10;
  bool isSelected = false;
  double percent = 1.0;
  Timer counterTime;
  @override
  void initState() {
    timer();
    super.initState();
  }

  void timer() {
    counterTime = Timer.periodic(Duration(seconds: 1), (timer) {
      if (counterSeconds >= 0) {
        setState(() {
          timeToShow = timeToCounter;
          isSelected = !isSelected;
          percent = counterSeconds;
        });
        timeToCounter--;
        counterSeconds -= 0.1;
      } else {
        if (counterTime != null) {
          counterTime.cancel();
          counterTime = null;
        }
        Navigator.pop(context);
        Navigator.of(context).pushNamed(
          PerformEvaluationQuestionsView.routeName,
          arguments: widget.evaluation,
        );
      }
    });
  }

  Widget _showMessageToBeReady() {
    final deviceSize = MediaQuery.of(context).size;

    Widget title = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: DefaultTextStyle(
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: yellowDeepColor, fontWeight: FontWeight.bold),
          child: Text(
            'A sua avaliação\njá vai começar!',
          ),
        ),
      ),
    );

    Widget message = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: DefaultTextStyle(
        style: Theme.of(context)
            .textTheme
            .headline5
            .copyWith(color: yellowDeepColor, fontWeight: FontWeight.bold),
        child: Text(
          'Prepare-se!',
        ),
      ),
    );

    Widget showMessage = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: CircularPercentIndicator(
        radius: 166,
        lineWidth: 4.0,
        //percent: percent,
        percent: 1.0,
        animation: true,
        animationDuration: 11000,
        backgroundColor: whiteColor,
        progressColor: greenBrightColor,
        center: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline3.copyWith(
                color: greenBrightColor,
                fontWeight: FontWeight.bold,
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              timeToShow.toString(),
            ),
          ),
        ),
      ),
    );

    // Widget animatedText = Container(
    //   alignment: Alignment.center,
    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //   child: AnimatedDefaultTextStyle(
    //     child: message,
    //     style: isSelected
    // ? TextStyle(
    //     fontSize: 26,
    //     color: yellowDeepColor,
    //     fontWeight: FontWeight.bold,
    //   )
    //         : TextStyle(
    //             fontSize: 29,
    //             color: yellowDeepColor,
    //             fontWeight: FontWeight.bold,
    //           ),
    //     duration: const Duration(microseconds: 2500),
    //   ),
    // );

    return Container(
      height: deviceSize.height * 0.9,
      child: Center(
        child: Container(
          height: deviceSize.height * 0.7,
          width: deviceSize.width * 0.82,
          child: Center(
            child: Card(
              shape: DialogTheme.of(context).shape,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  title,
                  SizedBox(
                    height: 10,
                  ),
                  showMessage,
                  SizedBox(
                    height: 10,
                  ),
                  message,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPage.render(
      context: context,
      color: yellowDeepColor,
      content: _showMessageToBeReady(),
    );
  }
}
