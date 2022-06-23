import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/exercise.dart';
import 'gym_card.dart';

class GymApp extends StatefulWidget {
  const GymApp({Key? key}) : super(key: key);

  @override
  State<GymApp> createState() => _GymAppState();
}

class _GymAppState extends State<GymApp> {
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();
  int? selectedId;

  bool isStarted = false;

  bool startedCountDown = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gym Time',
          textAlign: TextAlign.left,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await customBottomSheet(context, false);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Exercise>>(
            future: DatabaseHelper.instance.getExecises(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Exercise>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No execises are available'),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GymCard(
                    name: snapshot.data![index].name,
                    seconds: snapshot.data![index].seconds,
                    onTap: () {
                      setState(() {
                        _exerciseController.text = snapshot.data![index].name;
                        _secondsController.text =
                            snapshot.data![index].seconds.toString();
                        selectedId = snapshot.data![index].id;
                      });

                      customBottomSheet(context, true);
                    },
                    onLongPress: () {
                      setState(() {
                        DatabaseHelper.instance
                            .remove(snapshot.data![index].id!);
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10.0),
              );
            }),
      ),
    );
  }

  customBottomSheet(BuildContext context, bool isedit) async {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text(
                  isedit ? 'Edit Time' : 'Add New Exercise',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  readOnly: isedit ? true : false,
                  controller: _exerciseController,
                  decoration: InputDecoration(
                    labelText: 'Exercise',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _secondsController,
                  decoration: InputDecoration(
                    labelText: 'Seconds',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  onPressed: () async {
                    selectedId != null
                        ? await DatabaseHelper.instance.update(
                            Exercise(
                                id: selectedId,
                                name: _exerciseController.text,
                                seconds: int.parse(_secondsController.text)),
                          )
                        : await DatabaseHelper.instance.add(
                            Exercise(
                                name: _exerciseController.text,
                                seconds: int.parse(_secondsController.text)),
                          );
                    setState(() {
                      _exerciseController.clear();
                      _secondsController.clear();
                      selectedId = null;
                      Navigator.pop(context);
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
