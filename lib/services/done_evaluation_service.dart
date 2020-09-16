import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../model/exceptions/internet_exception.dart';
import '../model/evaluation_student/evaluation_student_model.dart';
import '../utils/verify_internet_connection.dart';
import '../model/exceptions/done_evaluation_exception.dart';
import '../services/user_service.dart';

abstract class DoneEvaluationService {
  Future<List<EvaluationStudentModel>> getStudentEvaluation({
    DateTime initialDate,
    DateTime finalDate,
  });

  Future<List<EvaluationStudentModel>> getTopStudentEvaluation(
      {String code, String userId});
}

class DoneEvaluationImpl implements DoneEvaluationService {
  final _storeInstance = FirebaseFirestore.instance;
  final userService = UserServiceImpl();
  @override
  Future<List<EvaluationStudentModel>> getStudentEvaluation({
    DateTime initialDate,
    DateTime finalDate,
  }) async {
    List<EvaluationStudentModel> _evaluationStudentModelList =
        List<EvaluationStudentModel>();
    try {
      final isInternetOn = await VerifyInternetConnection.getStatus();
      if (!isInternetOn) {
        throw InternetException(
            'Não há conexão ativa com a internet. Por favor, verifique a sua conexão.');
      }
      final userId = await userService.getCurrentUser();
      Query _query = _storeInstance
          .collection('student_evaluation')
          .where(
            'initial_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(initialDate),
          )
          .where(
            'initial_date',
            isLessThanOrEqualTo:
                Timestamp.fromDate(finalDate.add(Duration(days: 1))),
          )
          .where(
            'user_id',
            isEqualTo: userId,
          )
          .orderBy(
            'initial_date',
            descending: true,
          );

      QuerySnapshot _documentsDate = await _query.get();

      if (_documentsDate != null && _documentsDate.docs.length > 0) {
        _documentsDate.docs.forEach((doc) {
          _evaluationStudentModelList
              .add(EvaluationStudentModel.fromMap(doc.data()));
        });
      }
    } on InternetException catch (error) {
      throw error;
    } on PlatformException catch (error) {
      throw DoneEvaluationException(
          'Houve um erro ao tentar consultar as avaliações realizadas.\n${error.toString()}');
    } on Exception catch (error) {
      Exception('Houve um erro ao realizar a consulta.\n${error.toString()}');
    }

    return _evaluationStudentModelList;
  }

  @override
  Future<List<EvaluationStudentModel>> getTopStudentEvaluation(
      {String code, String userId}) async {
    List<EvaluationStudentModel> _evaluationStudentList =
        List<EvaluationStudentModel>();
    final _query = _storeInstance
        .collection('student_evaluation')
        .where('evaluation_code', isEqualTo: code)
        .orderBy('grade', descending: true)
        .orderBy('user_name');

    final _queryResult = await _query.get();

    if (_queryResult.size > 0) {
      _queryResult.docs.forEach((doc) {
        _evaluationStudentList.add(EvaluationStudentModel.fromMap(doc.data()));
      });

      double grade = _evaluationStudentList.first.grade;
      int position = 1;
      int percentStudentGrade = 1;
      int totalOfStudents = _evaluationStudentList.length;
      _evaluationStudentList.first.position = position;
      _evaluationStudentList.first.percentStudentGrade = percentStudentGrade;
      for (var i = 1; i < _evaluationStudentList.length; i++) {
        if (grade == _evaluationStudentList[i].grade) {
          _evaluationStudentList[i].position = position;
          _evaluationStudentList[i].percentStudentGrade = percentStudentGrade;
        } else {
          position++;
          grade = _evaluationStudentList[i].grade;
          percentStudentGrade =
              ((position / totalOfStudents) * 100).ceilToDouble().truncate();

          _evaluationStudentList[i].position = position;
          _evaluationStudentList[i].percentStudentGrade = percentStudentGrade;
        }
      }
    }
    return _evaluationStudentList;
  }
}

extension Precision on double {
  double toPrecision(int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble());
    return ((this * mod).round().toDouble() / mod);
  }
}
