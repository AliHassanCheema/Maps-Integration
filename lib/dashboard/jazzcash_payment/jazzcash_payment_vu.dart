import 'package:flutter/material.dart';
import 'package:maps_integration/dashboard/jazzcash_payment/jazzcash_payment_vm.dart';
import 'package:stacked/stacked.dart';

class JazzcashPaymentVU extends StackedView<JazzcashPaymentVM> {
  const JazzcashPaymentVU({super.key});

  @override
  Widget builder(
      BuildContext context, JazzcashPaymentVM viewModel, Widget? child) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Jazzcash Payment'),
        ),
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: viewModel.amountController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'Enter Amount',
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          hintText: 'Enter Amount'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: viewModel.mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: 'Enter Mobile Number',
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          hintText: 'Enter Mobile Number'),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.payment();
                      },
                      child: const Text("Pay Amount"),
                    ),
                  ],
                ),
              ));
  }

  @override
  JazzcashPaymentVM viewModelBuilder(BuildContext context) {
    return JazzcashPaymentVM();
  }
}
