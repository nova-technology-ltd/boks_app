import 'package:boks/features/home/bills/data_bundle/service/data_bundle_service.dart';
import 'package:boks/utility/shared_components/custom_button.dart';
import 'package:boks/utility/shared_components/custom_text_field.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final bundleController = TextEditingController();
  final durationController = TextEditingController();
  final valueController = TextEditingController();
  final serviceController = TextEditingController();
  final providerController = TextEditingController();
  final benefitController = TextEditingController();
  final periodController = TextEditingController();
  final priceController = TextEditingController();
  final DataBundleService _dataBundleService = DataBundleService();
  bool isLoading = false;

  Future<void> _saveBundle({
    required BuildContext context,
    required String bundle,
    required String duration,
    required String value,
    required String service,
    required String provider,
    required String benefit,
    required String period,
    required String price,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      await _dataBundleService.saveDataBundle(
        context: context,
        bundle: bundle,
        duration: duration,
        value: value,
        service: service,
        provider: provider,
        benefit: benefit,
        period: period,
        price: price,
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              CustomTextField(
                hintText: "bundle",
                prefixIcon: null,
                isObscure: false,
                controller: bundleController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: "duration",
                prefixIcon: null,
                isObscure: false,
                controller: durationController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: "value",
                prefixIcon: null,
                isObscure: false,
                controller: valueController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: "service",
                prefixIcon: null,
                isObscure: false,
                controller: serviceController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: "benefit",
                prefixIcon: null,
                isObscure: false,
                controller: benefitController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: "period",
                prefixIcon: null,
                isObscure: false,
                controller: periodController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: "price",
                prefixIcon: null,
                isObscure: false,
                controller: priceController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: "provider (MTN, GLO, AIRTEL, 9MOBILE)",
                prefixIcon: null,
                isObscure: false,
                controller: providerController,
              ),
              const SizedBox(height: 25),
              CustomButton(
                title: "Save",
                onClick: () {
                  _saveBundle(
                    context: context,
                    bundle: bundleController.text.trim(),
                    duration: durationController.text.trim(),
                    value: valueController.text.trim(),
                    service: serviceController.text.trim(),
                    provider: providerController.text.trim(),
                    benefit: benefitController.text.trim(),
                    period: periodController.text.trim(),
                    price: priceController.text.trim(),
                  );
                },
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
