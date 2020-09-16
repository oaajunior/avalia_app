import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../utils/verify_internet_connection.dart';
import '../services/user_service.dart';
import '../model/evaluation_student/evaluation_student_model.dart';
import '../model/evaluation/evaluation_model.dart';
import '../model/question/question_model.dart';
import '../model/exceptions/perform_evaluation_exception.dart';
import '../model/exceptions/internet_exception.dart';

abstract class PerformEvaluationService {
  Future<dynamic> getEvaluation(String code);
  Future<List<QuestionModel>> getQuestions(List<dynamic> questionsReference);
  Future<void> saveStudentEvaluation(EvaluationStudentModel evaluationStudent);
}

class EvaluationServiceImpl implements PerformEvaluationService {
  final _storeInstance = FirebaseFirestore.instance;
  int _totalQuestions = 0;
  int _totalTimeQuestions = 0;
  final userService = UserServiceImpl();

  @override
  Future<void> getEvaluation(String code) async {
    try {
      final isInternetOn = await VerifyInternetConnection.getStatus();
      if (!isInternetOn) {
        throw InternetException(
            'Não há conexão ativa com a internet. Por favor, verifique a sua conexão.');
      }

      EvaluationModel evaluation;
      List<QuestionModel> questions;
      DocumentSnapshot docEvaluation;
      final userId = await userService.getCurrentUser();

      if (await studentDidEvaluation(code, userId) == false) {
        final docReference = _storeInstance
            .collection('evaluation')
            .where('code', isEqualTo: code);

        if (docReference == null) {
          return evaluation;
        }

        QuerySnapshot docsData = await docReference.get();
        if (docsData == null || docsData.docs.length == 0) {
          return evaluation;
        }
        docsData.docs.forEach((doc) {
          docEvaluation = doc;
          if (docEvaluation.get('status') == 'I') {
            throw PerformEvaluationException(
                'A avaliação informada está Inativa. Por favor, entre em contato com o seu professor!');
          } else if (docEvaluation.get('status') == 'F') {
            throw PerformEvaluationException(
                'A avaliação informada está Finalizada. Por favor, entre em contato com o seu professor!');
          }
        });

        questions = await getQuestions(docEvaluation.get('question'));

        final totalTime = Duration(seconds: _totalTimeQuestions);
        final arrayTime = totalTime.toString().split(':');
        final formattedTime =
            '${arrayTime[0]}h${arrayTime[1]}min${double.parse(arrayTime[2]).truncate()}s';

        evaluation = EvaluationModel.fromMap(
          docEvaluation.id,
          _totalQuestions,
          formattedTime,
          questions,
          docEvaluation.data(),
        );
      } else {
        throw PerformEvaluationException(
            'Já existe uma avaliação feita por você para o código informado. Por favor, procure o seu professor!');
      }
      return evaluation;
    } on PlatformException catch (error) {
      final errorMessage = error.message.toString();
      if (errorMessage.contains('PERMISSION_DENIED')) {
        throw PerformEvaluationException(
            'Você não tem privilégios para consultar o banco de dados');
      }
    } on PerformEvaluationException catch (error) {
      throw error;
    } on InternetException catch (error) {
      throw error;
    } on Exception catch (error) {
      throw Exception('Houve erro ao tentar acessar a avaliação solicitada' +
          error.toString());
    }
  }

  Future<List<QuestionModel>> getQuestions(
      List<dynamic> questionsReference) async {
    List<QuestionModel> questions = List<QuestionModel>();
    _totalQuestions = 0;
    _totalTimeQuestions = 0;

    await Future.forEach(questionsReference, (questionRef) async {
      final question = await questionRef.get();
      if (question != null && question.data() != null) {
        if (question.get('active') == true) {
          _totalQuestions++;
          _totalTimeQuestions += question.get('response_time');
          questions.add(
            QuestionModel.fromMap(
              question.id,
              question.data(),
            ),
          );
        }
      }
    });
    return questions;
  }

  Future<void> saveStudentEvaluation(
      EvaluationStudentModel evaluationStudent) async {
    try {
      final isInternetOn = await VerifyInternetConnection.getStatus();
      if (!isInternetOn) {
        throw InternetException(
            'Não há conexão ativa com a internet. Por favor, verifique a sua conexão.');
      }
      await _storeInstance.collection('student_evaluation').add(
            evaluationStudent.toMap(),
          );
    } on InternetException catch (error) {
      throw error;
    } on Exception catch (error) {
      throw Exception(
          'Houve um erro ao tentar salvar a avaliação - ' + error.toString());
    }
  }

  Future<bool> studentDidEvaluation(String code, String user) async {
    Query query = _storeInstance
        .collection('student_evaluation')
        .where('evaluation_code', isEqualTo: code)
        .where('user_id', isEqualTo: user);

    final documents = await query.get();
    if (documents != null && documents.docs.length == 0) {
      return false;
    } else {
      return true;
    }
  }
}
