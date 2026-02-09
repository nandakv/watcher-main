import 'package:privo/app/models/user_interaction_model.dart';
import 'package:privo/res.dart';

late List<UserInteractionModel> videosList = [
  UserInteractionModel(
      url: "https://www.youtube.com/watch?v=9Oz60QxvXAg",
      isYoutubeLink: true,
      title: "How to improve your Credit Score",
      interactionTimeInfo: "5 minutes watch"),
  UserInteractionModel(
      url: "https://www.youtube.com/watch?v=1SpHnaOHYVI",
      isYoutubeLink: true,
      title:
          "What is the DTI Ratio? Why is DTI important to assess? How does it impact our creditworthiness?",
      interactionTimeInfo: "5 minutes watch"),
  UserInteractionModel(
      url: "https://www.youtube.com/watch?v=D-j1DmdqqX4",
      isYoutubeLink: true,
      title:
          "Financial Planning for New Age Couples | Managing Finances as newly married couples",
      interactionTimeInfo: "5 minutes watch"),
  UserInteractionModel(
      url: "https://www.youtube.com/watch?v=12OWJJVQwbc",
      isYoutubeLink: true,

      title: "Top things to consider before taking a Car Loan",
      interactionTimeInfo: "5 minutes watch"),
];

late List<UserInteractionModel> blogList = [
  UserInteractionModel(
      url: "https://privo.in/blog/how-to-increase-credit-score",
      img: Res.credit_score,
      title: "Boost Your Credit Score: Proven Tips and Strategies",
      interactionTimeInfo: "5 minutes read"),
  UserInteractionModel(
      url: "https://privo.in/blog/most-common-loan-rejection-reasons",
      img: Res.loanRejectionVideo,
      title: "What are the loan rejection reasons?",
      interactionTimeInfo: "5 minutes read"),
  UserInteractionModel(
      url:
          "https://privo.in/blog/multiple-existing-debts-turn-into-loan-rejection-reasons",
      img: Res.dti,
      title: "How do excessive debts result in loan rejection?",
      interactionTimeInfo: "5 minutes read"),
  UserInteractionModel(
      url: "https://privo.in/blog/fire-retire-early-guide",
      img: Res.fire,
      title: "Achieving Financial Independence &amp; Early Retirement",
      interactionTimeInfo: "5 minutes read"),
];
