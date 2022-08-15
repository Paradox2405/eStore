import 'package:estore/screens/home.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estore/constants.dart';
import 'package:uuid/uuid.dart';

class PaymentPage extends StatefulWidget {
  final double total;


  const PaymentPage({Key key, this.total}) : super(key: key);

  @override
  _ExistingCardsPageState createState() => _ExistingCardsPageState();
}

class _ExistingCardsPageState extends State<PaymentPage> {

  final formKey = GlobalKey<FormState>();
  bool isTestMode = true;
  bool responsePositive = false;


  //ON PRESSED ON CARDS
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        cardPayment(context);
        break;
      case 1:
      //TODO: Implement
        print("to be implemented!");
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    // StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Payment",
            style: Constants.boldHeadingAppBar,
          ),
          leading: Icon(Icons.monetization_on_rounded),
          toolbarTextStyle: GoogleFonts
              .poppinsTextTheme()
              .bodyText2,
          titleTextStyle: GoogleFonts
              .poppinsTextTheme()
              .headline6,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView.separated(
              itemBuilder: (context, index) {
                Icon icon;
                Text text;

                switch (index) {
                  case 0:
                    icon = Icon(Icons.credit_card_rounded,
                        color: Theme
                            .of(context)
                            .primaryColor);
                    text = Text("Pay via card");
                    break;

                  case 1:
                    icon = Icon(Icons.attach_money_rounded,
                        color: Theme
                            .of(context)
                            .primaryColor);
                    text = Text("Pay cash via cashier");
                    break;
                }
                return InkWell(
                  child: ListTile(
                    onTap: () {
                      onItemPress(context, index);
                    },
                    title: text,
                    leading: icon,
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  Divider(
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
              itemCount: 2),
        ),
      ),
    );
  }

  cardPayment(BuildContext context) async {
    final style = FlutterwaveStyle(
      appBarText: "Confirm Transaction",
      appBarTitleTextStyle: TextStyle(color: Colors.white, fontSize: 20,),
      appBarColor: Colors.blueAccent,
      buttonColor: Colors.red,
      buttonTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      dialogCancelTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      dialogContinueTextStyle: TextStyle(
        color: Colors.redAccent,
        fontSize: 18,
      ),
      mainTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 19,
          letterSpacing: 2
      ),
      dialogBackgroundColor: Colors.white,
      buttonText: "Pay USD ${widget.total}",
    );

    final Customer customer = Customer(
        name: "John Doe",
        phoneNumber: "12345678",
        email: "john.doe@gmail.com");

    // final subAccounts = [
    //   SubAccount(id: "RS_1A3278129B808CB588B53A14608169AD", transactionChargeType: "flat", transactionPercentage: 25),
    //   SubAccount(id: "RS_C7C265B8E4B16C2D472475D7F9F4426A", transactionChargeType: "flat", transactionPercentage: 50)
    // ];

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        style: style,
        publicKey: "xxxxx",
        currency: "USD",
        redirectUrl: "https://google.com",
        txRef: Uuid().v1(),
        amount: widget.total.toString().trim(),
        customer: customer,
        // subAccounts: subAccounts,
        paymentOptions: "card, payattitude, barter",
        customization: Customization(title: "eStore Payment"),
        isTestMode: false);
    final ChargeResponse response = await flutterwave.charge();
    if (response != null) {
      responsePositive=true;
      this.showLoading(
          "Transaction: ${response.status}\nTransaction ID: ${response
              .transactionId}\nTransaction Ref: ${response.txRef}");
      print("${response.toJson()}");
    } else {
      this.showLoading("No Response!");
    }
  }


  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
              width: double.infinity,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Text(message),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () => {
              responsePositive!=false? Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => HomePage())):Navigator.of(context).pop(
                  false)}, child: Text("Ok"))
          ],
        ),)
        ,
        );
      },
    );
  }
}

