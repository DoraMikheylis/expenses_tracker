import 'package:expenses_tracker/data/data_providers/api/get_list_icons.dart';
import 'package:expenses_tracker/presentation/home/utilities/darken_color.dart';
import 'package:expenses_tracker/presentation/home/widgets/stats/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  final List<TransactionItem>? transactions;
  final List<SlidableAction> Function(String itemId)? slidableActions;
  final Function(String itemId)? onItemSelected;

  const TransactionList({
    Key? key,
    this.transactions,
    this.onItemSelected,
    this.slidableActions,
  }) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    var listContent = widget.transactions!;
    return Expanded(
      child: FutureBuilder(
        future: getListIcons(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: listContent.length,
              itemBuilder: (context, int i) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.onItemSelected != null) {
                        widget.onItemSelected!(listContent[i].itemId!);
                      } else {}
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: widget.slidableActions != null
                            ? Slidable(
                                endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: widget.slidableActions!(
                                        listContent[i].itemId!)),
                                child: _buildTransactionElement(
                                  context,
                                  listContent[i],
                                  needDate: true,
                                  icons: snapshot.data!,
                                ),
                              )
                            : listContent[i].amount > 0
                                ? _buildTransactionElement(
                                    context,
                                    listContent[i],
                                    needDate: false,
                                    icons: snapshot.data!,
                                  )
                                : const SizedBox()),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

_buildTransactionElement(BuildContext context, TransactionItem transaction,
    {required bool needDate, required Map<String, String> icons}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).colorScheme.surfaceBright),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(transaction.color),
                          darkenColor(transaction.color, 0.25)
                        ],
                      ),
                      shape: BoxShape.circle,
                      color: Color(transaction.color),
                    ),
                  ),
                  SvgPicture.asset(
                    width: 25.0,
                    height: 25.0,
                    icons[transaction.icon]!,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                transaction.name,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 12),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w400),
              ),
              needDate
                  ? Text(
                      DateFormat('dd.MM.yyyy').format(transaction.date!),
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.w500),
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    ),
  );
}
