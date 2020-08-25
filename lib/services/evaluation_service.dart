import 'package:avalia_app/model/exceptions/evaluation_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/verify_internet_connection.dart';
import '../model/evaluation/evaluation_model.dart';
import '../model/question/question_model.dart';
import '../model/exceptions/internet_exception.dart';

abstract class EvaluationService {
  Future<dynamic> getEvaluation(String code);
}

class EvaluationServiceImpl implements EvaluationService {
  final _storeInstance = Firestore.instance;
  int totalQuestions = 0;
  int totalTimeQuestions = 0;

  @override
  Future<EvaluationModel> getEvaluation(String code) async {
    try {
      final isInternetOn = await VerifyInternetConnection.getStatus();
      if (!isInternetOn) {
        throw InternetException(
            'Não há conexão ativa com a internet. Por favor, verifique a sua conexão.');
      }

      EvaluationModel evaluation;
      String discipline;
      List<QuestionModel> questions;

      final docReference = _storeInstance
          .collection('evaluation')
          .where('code', isEqualTo: code);

      if (docReference == null) {
        return evaluation;
      }

      QuerySnapshot docsData = await docReference.getDocuments();
      final document =
          docsData.documents.firstWhere((doc) => doc.data['status'] == 'A');

      if (document != null) {
        discipline =
            await getDisciplineDescription(document.data['discipline']);

        questions = await getQuestions(document.data['question']);

        final totalTime = Duration(seconds: totalTimeQuestions);
        final arrayTime = totalTime.toString().split(':');
        final formattedTime =
            '${arrayTime[0]}h${arrayTime[1]}min${double.parse(arrayTime[2]).truncate()}s';

        evaluation = EvaluationModel(
          status: document.data['status'],
          code: document.data['code'],
          team: document.data['team'],
          createdAt: document.data['create_at'],
          title: document.data['title'],
          discipline: discipline ?? '',
          initialDate: document.data['initial_date'],
          finalDate: document.data['final_date'],
          question: questions,
          totalQuestions: totalQuestions,
          totalTime: formattedTime,
          stageEducation: document.data['stage_education'],
          schoolYear: document.data['school_year'],
          user: document.data['user'],
        );
        return evaluation;
      }
    } on PlatformException catch (error) {
      final errorMessage = error.message.toString();
      if (errorMessage.contains('PERMISSION_DENIED')) {
        throw EvaluationException(
            'Você não tem privilégios para consultar o banco de dados');
      }
    } on InternetException catch (error) {
      throw error;
    } on Exception catch (error) {
      throw Exception('Houve erro ao tentar acessar a avaliação solicitada' +
          error.toString());
    }
  }

  Future<String> getDisciplineDescription(
      DocumentReference disciplineRef) async {
    final disciplineData = await disciplineRef.get();

    if (disciplineData != null && disciplineData.data['active'] == true) {
      return disciplineData.data['name'];
    } else {
      return null;
    }
  }

  Future<List<QuestionModel>> getQuestions(
      List<dynamic> questionsReference) async {
    List<QuestionModel> questions = List<QuestionModel>();
    totalQuestions = 0;
    totalTimeQuestions = 0;

    await Future.forEach(questionsReference, (questionRef) async {
      final questionData = await questionRef.get();
      if (questionData != null && questionData.data != null) {
        final question = questionData.data;
        if (question['active'] == true) {
          totalQuestions++;
          totalTimeQuestions += question['response_time'];
          questions.add(QuestionModel(
            active: question['active'],
            rightAnswer: question['answer'],
            bncc: question['bncc'],
            createdAt: question['created_at'],
            description: question['description'],
            answers: (question['answers'] as List).cast<String>().toList(),
            difficulty: question['question_type'],
            responseTime: question['response_time'],
            tip: question['tip'],
          ));
        }
      }
    });

    return questions;
  }
}
