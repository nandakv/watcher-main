import 'package:privo/app/modules/know_more_and_get_started/model/voice_of_trust_model.dart';
import '../../faq/faq_model.dart';

mixin KnowMoreHelperMixin {
  late final FAQModel sblKnowMoreFAQs = FAQModel(
    faqs: [
      FAQ(
          question: "How can I apply for a loan?",
          answer:
              "You can apply for the loan via the Credit Saison India app by following a few simple steps or apply offline as well "),
      FAQ(
          question:
              "Will I get assistance from support team if I am facing difficulties while applying?",
          answer:
              "Yes, you can reach out to us or our team will reach out to you if you face any challenges"),
      FAQ(
          question: "Do I need to pledge any assets to apply for this loan?",
          answer:
              "This is a collateral-free loan and does not require you to pledge any assets."),
      FAQ(
          question:
              "What to do if your EMI/ECS is not deducted on the due date?",
          answer:
              "Please wait for 48 hours for the EMI to be debited before making a payment from the app's home page."),
      FAQ(
          question: "When will my EMI be deducted?",
          answer:
              "To find out your EMI deduction date, click on 'All Withdrawals' from the home page and select the loan for which you want to know the EMI date."),
    ],
    attribute: "Know_More_SBL",
  );

  late final FAQModel clpKnowMoreFAQs = FAQModel(
    faqs: [
      FAQ(
          question: "What is Privo Instant Loan?",
          answer:
              "Privo Instant Loan is more than just a financial app; it's your reliable partner in times of financial need. We are the leading platform for instant online loans, offering individuals a seamless and hassle-free borrowing experience."),
      FAQ(
          question: "How can I apply for Privo Instant Loan?",
          answer:
              "Applying for a Privo Instant Loan is as easy as 1-2-3! You can get started by downloading our user-friendly loan app. Once you're in, complete a quick and straightforward loan application form with some basic information."),
      FAQ(
          question: "What is the speciality of Privo Instant Loan?",
          answer:
              "Privo Instant loan app is designed with you in mind. We understand that convenience is key, so we've created an app that allows you to apply for an instant loan online with just a few taps."),
      FAQ(
          question: "How fast can I get Privo Instant Loan?",
          answer:
              "Privo Instant Loan is lightning-fast loan approval process. In most cases, you'll receive an instant loan approval decision within minutes of applying."),
      FAQ(
          question:
              "Are my personal details safe with Credit Saison India App?",
          answer:
              "Absolutely! Your privacy and security are paramount to us. We employ state-of-the-art encryption technology to safeguard your personal information. Be assured that your data is kept confidential and protected from unauthorized access, ensuring a safe and worry-free borrowing experience."),
    ],
    attribute: "Know_More_CLP",
  );

  late final FAQModel finSightsFaq = FAQModel(
    faqs: [
      FAQ(
          question: "How does FinSights work?",
          answer:
          """The FinSights feature uses a secure framework by RBI known as an "Account Aggregator" to gather data from your bank accounts—only with your consent. This allows us to pull in financial information from various sources to give you a consolidated overview of your spending, savings, and cash flow. By simplifying your financial data in one place, it helps you make informed, timely decisions to reach your financial goals."""),
      FAQ(
          question: "What is an Account Aggregator(AA)?",
          answer:
          """Account Aggregators (AAs) are entities regulated by the Reserve Bank of India (RBI) that enable secure sharing of your financial information. These entities operate on a consent-based framework, ensuring that your data is never shared without your explicit approval. AAs are also "data-blind," meaning they cannot read or store your information, further enhancing the security and privacy of your financial data"""),
      FAQ(
          question: "Is my data secure with FinSights?",
          answer:
          "Yes, we prioritize your security. The FinSights feature operates under strict regulatory guidelines and uses end-to-end encryption to ensure your data is safe. We only access and use your information to generate insights after you give your consent."),
      FAQ(
          question: "Does using FinSights impact my credit score or financial standing?",
          answer:
          "No, using the FinSights feature does not affect your credit score or financial standing. It does not involve any credit checks, nor does it impact your creditworthiness."),
      FAQ(
          question:
          "Can I link multiple bank accounts at the same time?",
          answer:
          "Currently, this feature isn’t available, but we’re working on it. Soon, you’ll be able to link multiple bank accounts at the same time."),
    ],
    attribute: "Know_More_CLP",
  );

  late final List<VoiceOfTrustModel> voiceOfTrustList = [
    VoiceOfTrustModel(
      name: "Srinivas",
      rating: 5,
      review:
          "This application is superb! I received a loan without need for physical documents. The information provided about financial arrangements is excellent, making it very useful. I highly recommend it to others.",
    ),
    VoiceOfTrustModel(
      name: "Shrikanth Naidu",
      rating: 5,
      review: "This application is fantastic! I received a loan instantly",
    ),
    VoiceOfTrustModel(
      name: "Shivam",
      rating: 5,
      review:
          "This application is superb! I received a loan instantly, and the entire process was seamless. Thanks for such an efficient service!",
    ),
  ];
}
