import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:darq/darq.dart';

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
      Query _queryInitialDate = _storeInstance
          .collection('student_evaluation')
          .where(
            'initial_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(initialDate),
          )
          .where(
            'user',
            isEqualTo: userId,
          );

      Query _queryFinalDate = _storeInstance
          .collection('student_evaluation')
          .where(
            'final_date',
            isLessThanOrEqualTo: Timestamp.fromDate(finalDate),
          )
          .where(
            'user',
            isEqualTo: userId,
          );

      QuerySnapshot _documentsInitialDate = await _queryInitialDate.get();
      QuerySnapshot _documentsFinalDate = await _queryFinalDate.get();

      if (_documentsInitialDate != null &&
          _documentsInitialDate.docs.length > 0) {
        extractEvaluationStudent(_documentsInitialDate, initialDate, finalDate,
            _evaluationStudentModelList);
      }
      if (_documentsFinalDate != null && _documentsFinalDate.docs.length > 0) {
        extractEvaluationStudent(_documentsFinalDate, initialDate, finalDate,
            _evaluationStudentModelList);
      }
    } on InternetException catch (error) {
      throw error;
    } on PlatformException catch (error) {
      throw DoneEvaluationException(
          'Houve um erro ao tentar consultar as avaliações realizadas.\n${error.toString()}');
    } on Exception catch (error) {
      Exception('Houve um erro ao realizar a consulta.\n${error.toString()}');
    }
    if (_evaluationStudentModelList.length > 0) {
      _evaluationStudentModelList = _evaluationStudentModelList
          .distinct((result) => result.evaluationCode)
          .toList();
    }
    return _evaluationStudentModelList;
  }

  void extractEvaluationStudent(
      QuerySnapshot snapshot,
      DateTime initialDate,
      DateTime finalDate,
      List<EvaluationStudentModel> evaluationStudentModelList) {
    snapshot.docs.forEach((doc) {
      var dateTimeIni = (doc.get('initial_date') as Timestamp).toDate();
      var dateTimeFinal = (doc.get('final_date') as Timestamp).toDate();

      if (dateTimeIni.isAfter(initialDate) &&
          dateTimeFinal.isBefore(finalDate.add(Duration(days: 1))))
        evaluationStudentModelList
            .add(EvaluationStudentModel.fromMap(doc.data()));
    });
  }
}
