import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class JazzcashPaymentVM extends BaseViewModel {
  bool isLoading = false;
  TextEditingController mobileController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  payment() async {
    isLoading = true;
    notifyListeners();

    String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    String dexpiredate = DateFormat("yyyyMMddHHmmss")
        .format(DateTime.now().add(const Duration(days: 1)));
    String tre = "T$dateandtime";
    String ppAmount = amountController.text; // price set
    String ppBillreference = "BillNo";
    String ppDescription = "Description for transaction";
    String ppLanguage = "EN";
    String ppMerchantid = "";
    String ppPassword = "";

    String ppReturnurl =
        "https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction";
    String ppVer = "1.1";
    String ppTxncurrency = "PKR";
    String ppTxndatetime = dateandtime.toString();
    String ppTxnexpirydatetime = dexpiredate.toString();
    String ppTxnrefno = tre.toString();
    String ppTxntype = "MWALLET";
    String ppmpf_1 = mobileController.text;
    String integeritySalt = "";
    String and = '&';
    String superdata = integeritySalt +
        and +
        ppAmount +
        and +
        ppBillreference +
        and +
        ppDescription +
        and +
        ppLanguage +
        and +
        ppMerchantid +
        and +
        ppPassword +
        and +
        ppReturnurl +
        and +
        ppTxncurrency +
        and +
        ppTxndatetime +
        and +
        ppTxnexpirydatetime +
        and +
        ppTxnrefno +
        and +
        ppTxntype +
        and +
        ppVer +
        and +
        ppmpf_1;

    var key = utf8.encode(integeritySalt);
    var bytes = utf8.encode(superdata);
    var hmacSha256 = Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    String url =
        'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

    var response = await http.post(Uri.parse(url), body: {
      "pp_Version": ppVer,
      "pp_TxnType": ppTxntype,
      "pp_Language": ppLanguage,
      "pp_MerchantID": ppMerchantid,
      "pp_Password": ppPassword,
      "pp_TxnRefNo": tre,
      "pp_Amount": ppAmount,
      "pp_TxnCurrency": ppTxncurrency,
      "pp_TxnDateTime": dateandtime,
      "pp_BillReference": ppBillreference,
      "pp_Description": ppDescription,
      "pp_TxnExpiryDateTime": dexpiredate,
      "pp_ReturnURL": ppReturnurl,
      "pp_SecureHash": sha256Result.toString(),
      "ppmpf_1": ppmpf_1
    });

    debugPrint("response=>");
    debugPrint(response.body);
    var res = response.body;
    var body = jsonDecode(res);
    final responcePrice = body['pp_Amount'];
    debugPrint("payment successfully $responcePrice");
    isLoading = false;
    notifyListeners();
  }
}
