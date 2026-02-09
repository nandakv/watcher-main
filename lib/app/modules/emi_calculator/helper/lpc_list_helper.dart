import 'package:privo/app/modules/emi_calculator/model/lpc_calculator_model.dart';
import 'package:privo/res.dart';

class LpcGridHelper {
  static List<LpcCalculatorModel> lpcList = [
    LpcCalculatorModel(
        title: 'Personal Loan',
        icon: Res.personalLoanIcon,
        description: "At Credit Saison, we understand that dreams come in all shapes and sizes. Our tailored Personal Loans are perfect for vacations, education, home improvements, and more – turning dreams into reality.",
        minAndMaxAmount: [10000, 1500000],
        minAndMaxInterest: [8, 36],
        minAndMaxTenure: [12, 60]),
    LpcCalculatorModel(
        title: 'Credit Line',
        icon: Res.creditLineIcon,
        description: "Your Lifeline for Instant Credit. Access funds instantly with zero paperwork. Withdraw anytime, anywhere and pay interest only on what you use.",
        minAndMaxAmount: [10000, 1500000],
        minAndMaxInterest: [8, 36],
        minAndMaxTenure: [12, 60]),
    LpcCalculatorModel(
        title: 'Vacation Loan',
        description: "A vacation loan is a type of personal loan specifically designed to help you finance travel expenses. It's essentially borrowing a lump sum of money from a lender to cover costs like flights, hotels, activities, and other vacation needs.",
        icon: Res.vacationLoan,
        minAndMaxAmount: [10000, 1500000],
        minAndMaxInterest: [8, 36],
        minAndMaxTenure: [12, 60]),
    LpcCalculatorModel(
        title: 'Business Loan',
        icon: Res.bussinesLoanIcon,
        description: "Fuel your business growth with collateral-free loans designed for expanding operations, managing inventory, or covering daily expenses",
        minAndMaxAmount: [100000, 5000000],
        minAndMaxInterest: [10, 36],
        minAndMaxTenure: [12, 36]),
    LpcCalculatorModel(
        title: 'Small Business Loan',
        icon: Res.sblIcon,
        description: "Introducing Credit Saison Small Business Loans. Our tailored financing solutions are designed to meet the unique needs of startups and small enterprises.",
        minAndMaxAmount: [100000, 1000000],
        minAndMaxInterest: [10, 36],
        minAndMaxTenure: [12, 36]),
    LpcCalculatorModel(
        title: 'Working Capital Loan',
        icon: Res.workingCapIcon,
        minAndMaxAmount: [100000, 1000000],
        description: "A working capital loan can bridge the gap between your business expenses and incoming sales. Cover everyday costs, manage inventory, or seize opportunities with a flexible working capital loan.",
        minAndMaxInterest: [10, 36],
        minAndMaxTenure: [12, 36]),
    LpcCalculatorModel(
        title: 'Loan Against Property',
        icon: Res.lapIcon,
        description: "Whether for personal aspirations or business goals, our LAP offers financial support backed by your property. Making big dreams happen, one loan at a time",
        minAndMaxAmount: [750000, 10000000],
        minAndMaxInterest: [8, 36],
        minAndMaxTenure: [12, 180]),
    LpcCalculatorModel(
        title: 'Equipment Financing Loan',
        icon: Res.equipmentFinLoan,
        description: "Get the equipment you need today with an affordable equipment financing loan.Finance essential machinery or technology with flexible Loan.",
        minAndMaxAmount: [100000, 1000000],
        minAndMaxInterest: [10, 36],
        minAndMaxTenure: [12, 36]),
  ];
}