import 'package:privo/app/modules/faq/faq_model.dart';

class FAQUtility {
  late final partnerFAQs = FAQModel(
    faqs: [
      FAQ(
        question: "What is a Credit Line?",
        answer:
            "A credit line, also known as a line of credit, is a flexible borrowing arrangement that allows individuals to access funds up to a predetermined limit. It provides the flexibility to borrow and repay multiple times within the set limit, with interest charged only on the amount borrowed.",
      ),
      FAQ(
        question: "How to Apply for Privo Instant Loan?",
        answer:
            """You can apply for an instant credit line online through a paperless approval process. Credit Saison India offers a user-friendly app that helps you activate your credit line in just a few taps. You can download the app from the Play Store. Complete the five steps:
1. Setup your profile
2. Complete your KYC
3. Setup Autopay
4. Choose amount to withdraw
5. Credit Line Active
""",
      ),
      FAQ(
        question:
            "What is the difference between Credit Line vs Personal Loan?",
        answer:
            'Credit line is a revolving credit facility that offers flexible access to funds within a predetermined limit. It allows borrowers to withdraw and repay funds as needed, similar to a credit card. Interest is charged only on the borrowed amount. On the other hand, a personal loan is a fixed amount borrowed upfront and repaid in installments over a set period. Interest is applicable on the entire loan amount. In summary, a credit line offers flexibility and ongoing access to funds within a limit. You can repay and reuse.',
      ),
      FAQ(
        question:
            "What is the eligibility criteria to apply for a Credit Line with Privo?",
        answer: """To become eligible for a credit line from Privo, you must:
1. Be earning a minimum of Rs. 18,000 ₹ monthly income.
2. Have a minimum credit score of 650.
3. Be aged between 21 to 60 years.
4. Be an Android user.""",
      ),
      FAQ(
        question: "How Does The Privo Instant Loan work?",
        answer:
            "Privo Instant Loan offers revolving credit with a predetermined limit to the users which can be accessed anytime. Depending on the borrower’s profile and credit evaluation, the final Credit Line is offered with a maximum credit limit, tenure and rate of interest. Once active, users can repay and reuse the approved credit limit within the available tenure and pay interest only on the amount borrowed and not on the Credit Limit.",
      )
    ],
    attribute: "",
  );

  late final lowAndGrowFAQs = FAQModel(
    faqs: [
      FAQ(
          question:
              "Will upgrading my Privo's credit line affect my credit score?",
          answer:
              "No, upgrading your Privo's credit line does not affect your credit score."),
      FAQ(
          question:
              "Are there any additional charges associated with the upgraded credit line?",
          answer:
              "No, there are no additional charges associated with the upgraded line. This offer provides a better credit limit, a low-interest rate, a higher tenure, or a combination of two or three."),
      FAQ(
          question:
              "How long does it take for the upgraded credit line to take effect?",
          answer:
              "The new credit line becomes effective once you accept the new line agreement. All upcoming withdrawals will have the upgraded terms accordingly."),
      FAQ(
          question: "Will my interest rate change if I upgrade my credit line?",
          answer:
              "Your interest may or may not change depending on the type of offer provided to you. The upgraded interest rate, if any, will be clearly provided in the offer itself."),
      FAQ(
          question:
              "Can I switch back to my previous credit line if I change my mind?",
          answer:
              "No, once you accept the offer, we will not be able to reverse it. However, if you are facing any issues, please reach out to our customer support number, and we will be happy to assist you."),
      FAQ(
          question:
              "Will upgrading my credit line affect my existing loan or ongoing repayments?",
          answer:
              "No, the upgrade will not affect your existing loans and their respective EMIs. This offer will only upgrade your credit line, and any new withdrawals after the upgrade will have the new terms accordingly.")
    ],
    attribute: "",
  );

  // late final clpFAQs = FAQModel(
  //   faqs: [
  //     FAQ(
  //         question: "Why was my Privo application rejected?",
  //         answer:
  //             "No, upgrading your Privo's credit line does not affect your credit score."),
  //     FAQ(
  //         question: "What is the eligibility criteria?",
  //         answer:
  //             "No, there are no additional charges associated with the upgraded line. This offer provides a better credit limit, a low-interest rate, a higher tenure, or a combination of two or three."),
  //   ],
  //   attribute: "",
  // );

  late final emiFastTrackFAQs = FAQModel(
    faqs: [
      FAQ(
        question: "What is Advance Payment?",
        answer:
        "This feature allows you to pay the upcoming EMI in advance. Please note, that only a single EMI can be paid in advance which will be applied to your upcoming EMI. It won't be considered as a part-prepayment or a foreclosure of your loan, and therefore, no interest benefit will be provided.",
      ),
      FAQ(
        question: "What payment options are available to pay EMIs before due date?",
        answer: "All available Payment Options.",
      ),
      FAQ(
        question: "Can I pay more than one EMI before the due date?",
        answer: "No, you can only pay the upcoming EMI for the month before the due date.",
      ),
      FAQ(
        question: "Can I pay any amount while using the this feature?",
        answer: "No, the payment amount is limited to a single EMI for the upcoming month.",
      ),
      FAQ(
        question: "When will the payment reflect in my statement if I pay before the due date?",
        answer: "The payment will show up in your Account Statement and can be downloaded for verification.",
      ),
      FAQ(
        question: "How long does the payment process take?",
        answer: "The payment process typically takes just 2-3 minutes.",
      ),
      FAQ(
        question: "What are the benefits of paying the EMI before the due date?",
        answer:
        "Opportunity for Credit Line Upgrade: Boost your chances of a Credit Line upgrade by making pre-payments before the EMI due date.\nMultiple Payment Choices: Choose from a variety of options to pre-pay EMIs without the hassle of maintaining the entire EMI amount in your bank.\nFinancial Safety Net: Pre-paying before the due date eases your EMI concerns during financial challenges or emergencies, offering a valuable financial safety net.",
      ),
    ],
    attribute: "upcoming_dues",
  );

  late final foreClosureFAQs = FAQModel(
    faqs: [
      FAQ(
        question: "What is the eligibility criteria for foreclosure?",
        answer:
            "The loan must not be overdue, cannot prepay during initial month of the loan and cannot prepay loan during 2 days of regular EMI debit period",
      ),
      FAQ(
        question:
            "What are prepay charges? Does it depend on the amount withdrawn or credit line amount?",
        answer:
            "Prepayment charge is 0% of the principal amount. It does not depend on credit line amount, only depends on the loan which a person wants to prepay.",
      ),
      FAQ(
        question: "What is my benefit if I prepay the loan?",
        answer: "Users can save on interest if he/she prepays the loan",
      ),
      FAQ(
        question: "Can I close multiple withdrawals at the same time?",
        answer:
            "No, you can only prepay withdrawals one after the other, you cannot close multiple withdrawals at the same time. ",
      ),
      FAQ(
        question:
            "How long does it take for my withdrawal to be closed after the payment is done?",
        answer:
            "Withdrawal gets closed within 5 minutes maximum in normal circumstances",
      ),
      FAQ(
        question: "Where can I get the NOC for the withdrawal?",
        answer:
            "Users can go to the withdrawal details page on the Credit Saison India app to download NOC (No Objection Certificate)",
      ),
      FAQ(
        question: "Can I negotiate charges while I prepay a withdrawal?",
        answer: "No, you cannot negotiate prepayment charges",
      ),
    ],
    attribute: "prepay",
  );

  late final creditReportFAQs = FAQModel(
    faqs: [
      FAQ(
        question: "What is a credit score and why is it important?",
        answer:
            "Your credit score is a number that reflects your creditworthiness, or how likely you are to repay borrowed money. It's based on your credit history, which includes information like your payment history, credit utilization ratio, and length of credit history. A good credit score can help you qualify for loans, secure better interest rates, and even save money on insurance.",
      ),
      FAQ(
          question: "What factors affect my credit score?",
          answer:
              """Several factors impact your credit score, but the most important ones are:
 • Payment history: This is the biggest factor, accounting for about 35% of your score. It refers to your history of making timely payments on credit cards, loans, and other debts.
 • Credit utilization ratio: This is the amount of credit you're using compared to your total credit limit. It's best to keep this ratio below 30%.
 • Length of credit history: The longer you've had credit accounts open and used responsibly, the better for your score.
 • Credit mix: Having a mix of credit accounts, such as credit cards and installment loans, can help your score.
 • Hard inquiries: Each time you apply for a new loan or credit card, a hard inquiry is placed on your credit report. Too many hard inquiries in a short period can lower your score."""),
      FAQ(
        question: "How can I check my credit score?",
        answer:
            """You can check your credit score for free from several sources, including annual credit reports, credit card issuers, and some banks. You can also get your score from credit bureaus for a fee.
What is a good credit score? (Source: [Source Name])
 • Excellent: 800 or above
 • Very good: 740-799
 • Good: 670-739
 • Fair: 580-669
 • Poor: Below 580
 • A higher score is generally better and can qualify you for the most favorable loan terms.""",
      ),
      FAQ(
          question: "How can I improve my credit score?",
          answer:
              """Here are some steps you can take to improve your credit score:
 • Make all your credit card and loan payments on time.
 • Keep your credit card balances low.
 • Don't apply for too much new credit at once.
 • Dispute any errors on your credit report.
 • Maintain a healthy mix of credit accounts."""),
      FAQ(
        question: "How long does it take to improve my credit score?",
        answer:
            "The time it takes to improve your credit score depends on the effort you put in. Making positive changes to your credit habits can start to improve your score within a few months, but it may take a year or two to see significant improvement.",
      ),
    ],
    attribute: "credit_report",
  );

  late final loanCancellationFAQs = FAQModel(
    faqs: [
      FAQ(
        question:
            "What happens to my processing fee and BPI (broken period interest) charged during withdrawal?",
        answer:
            "Since these amounts were deducted from your loan amount, you will not have to pay these amounts for cancelling the loan",
      ),
      FAQ(
        question: "What happens to my insurance when I cancel the Loan?",
        answer:
            "If you had opted for insurance policy for your loan, your insurance will automatically be cancelled. Since this was deducted from your loan, you will not have to pay back the premium for cancelling the loan.",
      ),
      FAQ(
        question: "Will my Credit score be affected if I cancel loan?",
        answer:
            "Cancelling your loan has no impact on your future credit, as long as you do not do it frequently.",
      ),
      FAQ(
          question:
              "What is the process of cancelling the disbursed withdrawal?",
          answer:
              "You can cancel your loan on your Credit Saison India App if the loan is eligible for cancellation period."),
      FAQ(
        question: "Can I cancel more than one withdrawal?",
        answer:
            "You can cancel any withdrawal individually till the time it falls in cool off period, but you cannot cancel multiple loans at once.",
      ),
      FAQ(
        question: "How long do I get to cancel the withdrawal?",
        answer:
            "Loan cancellation period depend is loan specific, if the option is available on the app, means you can cancel. Your cool off period can be obtained in Line Agreement Letter which is downloadble from the App",
      ),
      FAQ(
        question: "Will I receive a NOC after payment?",
        answer:
            "NOC is not received on cancellation, it is for closed loans, NOC does not apply for cancellation",
      ),
      FAQ(
        question: "How long does the process of loan cancellation takes?",
        answer:
            "Process of Loan Cancellation may take upto a few hours and in exceptional circumstances upto 72 hrs",
      ),
      FAQ(
        question: "Are there hidden charges when I cancel the loan?",
        answer:
            "There are no hidden charges, you will be only charged interest incurred till the time you cancel your loan",
      ),
    ],
    attribute: "cancellation",
  );

  late final partPayFAQs = FAQModel(
    faqs: [
      FAQ(
        question: "What is part-payment, and how does it benefit me?",
        answer:
            "Part payment refers to making a partial payment on the loan before the scheduled due date.This allows borrowers to reduce their outstanding balance, potentially saving on interest cost.",
      ),
      FAQ(
        question: "Is there a minimum amount required for part-payment?",
        answer: "Yes, the minimum amount to part-pay is 10000",
      ),
      FAQ(
        question: "Are there any charges associated with making part-payments?",
        answer:
            "There are no extra charges associated with making part payments.",
      ),
      FAQ(
        question: "How does part-payment affect my loan tenure?",
        answer:
            "Your loan tenure will remain the same and will not be affected by the part payments made under credit line facility",
      ),
      FAQ(
        question: "Can I make part-payments through the mobile app?",
        answer:
            "Yes, part payments can easily be done via Credit Saison India app.",
      ),
      FAQ(
        question:
            "Do I need to keep a minimum balance in account while making part-payments?",
        answer:
            "You need to keep a minimum of ₹1,000 to keep the account active.",
      ),
      FAQ(
        question: "Can I make part-payments at any time?",
        answer:
            "After initiating a withdrawal, a waiting period of 24 hours is required before a partial payment can be made.",
      ),
    ],
    attribute: "part_pay",
  );

  late final FAQModel creditScoreFaqs = FAQModel(
    faqs: [
      FAQ(
        question: "How does Credit Saison’s Credit Score feature work?",
        answer:
            "Our feature partners with Experian to provide you with an updated view of your credit score. By consenting, you can securely check your score and gain insights into factors that affect it, such as payment history and credit utilization.",
      ),
      FAQ(
        question: "Is there a cost to check my credit score?",
        answer:
            "No, checking your credit score with Credit Saison is completely free. We aim to make financial insights accessible to help you manage and improve your credit health without any hidden costs.",
      ),
      FAQ(
        question: "How often can I check my credit score?",
        answer:
            "You can check your credit score monthly through our app. Experian updates your score monthly, allowing you to track changes over time without impacting your score.",
      ),
      FAQ(
        question: "Does checking credit score impact my credit score?",
        answer:
            'No, checking your own credit score through our app is considered a "soft inquiry" and does not affect your credit score. It’s a secure and non-impactful way to stay informed about your financial health.',
      ),
      FAQ(
        question:
            "What information do I need to provide to check my credit score?",
        answer:
            "If you are already our customer, you don't need anything except for a consent. ",
      ),
      FAQ(
        question:
            "What should I do if there’s an error in my credit score or report?",
        answer:
            "If you notice an error, you can contact Experian directly through their support channels. Errors may sometimes occur, and Experian can guide you on the steps to correct any inaccurate information.",
      ),
      FAQ(
        question: "Can I improve my credit score using this feature?",
        answer:
            "Yes, our app offers insights and tips on ways to improve your credit score. By understanding factors that affect your score, such as timely payments and managing credit balances, you can make informed decisions to improve your financial health.",
      ),
      FAQ(
        question: "What if my credit score is lower than I expected?",
        answer:
            "If your score is lower than expected, our app can provide insights into the factors influencing it. Common reasons for a lower score include missed payments, high credit utilization, or recent hard inquiries. Reviewing these insights can help you work toward improvement.",
      ),
    ],
    attribute: "credit_score",
  );
  
  late final referralFaqs = FAQModel(faqs: [
    FAQ(question: "Who can I refer?", answer: "You can refer anyone who is not already registered on our platform-friends, family, or colleagues."),
    FAQ(question: "How many people can I refer?", answer: "There is no limit to how many people you can refer. The more you refer, the better!"),
    FAQ(question: "Can I track the status of my referrals?", answer: "Yes, you can see how many people have joined using your referral link"),
    FAQ(question: "What happens if my friend forgets to use my referral code?", answer: "Unfortunately, we can only track and reward referrals that use your code or link during sign-up. Please ensure they use it at the time of registration."),
    FAQ(question: "Can existing users be added as my referrals again?", answer: "No, the referral must be used at the time of sign-up. Existing users can’t be linked to your referral code later."),
  ], attribute: "referral_flow");
}
