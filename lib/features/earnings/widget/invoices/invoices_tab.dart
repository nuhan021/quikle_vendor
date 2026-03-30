import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../controller/invoice_controller.dart';
import 'invoice_card.dart';

class InvoicesTab extends StatelessWidget {
  const InvoicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<InvoiceController>()
        ? Get.find<InvoiceController>()
        : Get.put(InvoiceController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Row(
            children: [
              Expanded(
                child: _InvoiceFilterDropdown(
                  label: 'Status',
                  value: controller.selectedStatus.value,
                  items: controller.statusOptions,
                  labelBuilder: controller.labelForValue,
                  onChanged: controller.changeStatus,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InvoiceFilterDropdown(
                  label: 'Type',
                  value: controller.selectedType.value,
                  items: controller.typeOptions,
                  labelBuilder: controller.labelForValue,
                  onChanged: controller.changeType,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return _InvoiceStateView(
                message: controller.errorMessage.value,
                actionLabel: 'Retry',
                onAction: controller.fetchInvoices,
              );
            }

            if (controller.invoices.isEmpty) {
              return _InvoiceStateView(
                message: 'No invoices found.',
                actionLabel: 'Refresh',
                onAction: controller.fetchInvoices,
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchInvoices(showLoader: false),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: controller.invoices.length,
                itemBuilder: (context, index) {
                  final invoice = controller.invoices[index];
                  return InvoiceCard(
                    invoiceId: controller.invoiceIdFor(invoice),
                    orderId: controller.orderIdFor(invoice),
                    amount: controller.amountFor(invoice),
                    customer: controller.customerFor(invoice),
                    date: controller.dateFor(invoice),
                    time: controller.timeFor(invoice),
                    status: controller.statusFor(invoice),
                    tags: controller.tagsFor(invoice),
                    onDownload: () => controller.downloadInvoice(invoice),
                    onView: () => controller.viewInvoice(invoice),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _InvoiceFilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final String Function(String value) labelBuilder;
  final ValueChanged<String> onChanged;

  const _InvoiceFilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            color: Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, size: 16),
              style: getTextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        labelBuilder(item),
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (selected) {
                if (selected != null) {
                  onChanged(selected);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _InvoiceStateView extends StatelessWidget {
  final String message;
  final String actionLabel;
  final Future<void> Function() onAction;

  const _InvoiceStateView({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(onPressed: onAction, child: Text(actionLabel)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
