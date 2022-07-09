import 'package:fl_test/constant/route.dart';
import 'package:fl_test/screens/home_page.dart';
import 'package:fl_test/screens/login_page.dart';
import 'package:fl_test/screens/signup_page.dart';
import 'package:fl_test/screens/verification_page.dart';
import 'package:fl_test/screens/views/create_or_update_note_view.dart';
import 'package:fl_test/screens/views/note_view.dart';
import 'package:fl_test/services/auth/auth_provider.dart';
import 'package:fl_test/services/auth/bloc/auth_bloc.dart';
import 'package:fl_test/services/auth/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _MyApp());
}

class _MyApp extends StatefulWidget {
  const _MyApp({Key? key}) : super(key: key);

  @override
  __MyAppState createState() => __MyAppState();
}

class __MyAppState extends State<_MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FireBaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: <String, WidgetBuilder>{
        homeRoute: (BuildContext context) => const HomePage(),
        noteViewRoute: (BuildContext context) => const NoteView(),
        createOrUpdateNoteViewRoute: (BuildContext context) =>
            const CreateOrUpdateNoteView(),
      },
      // home: Scaffold(
      //     resizeToAvoidBottomInset: false,
      //     backgroundColor: Colors.green[50],
      //     body: const LoginPage()),
    );
  }
}

class BlocTestingHomePage extends StatefulWidget {
  const BlocTestingHomePage({Key? key}) : super(key: key);

  @override
  State<BlocTestingHomePage> createState() => _BlocTestingHomePageState();
}

class _BlocTestingHomePageState extends State<BlocTestingHomePage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Bloc test')),
        // BlocConsumer conbination of bloc lidtener and bloc builder when nees lesten and rebuild
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.inValidValue : "";
            return Column(
              children: [
                Text('Current value is : ${state.value}'),
                Visibility(
                  child: Text('Invalid input: $invalidValue'),
                  visible: state is CounterStateInvalidNumber,
                ),
                TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: "Enter number here :"),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        final bloc = context.read<CounterBloc>();
                        bloc.add(DecrementEvent(_controller.text));
                      },
                      child: const Text('-'),
                    ),
                    TextButton(
                      onPressed: () {
                        final bloc = context.read<CounterBloc>();
                        bloc.add(IncrementEvent(_controller.text));
                      },
                      child: const Text('+'),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
class CounterState {
  final int value;
  const CounterState(this.value);
}

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String inValidValue;

  const CounterStateInvalidNumber(
      {required this.inValidValue, required int previousValue})
      : super(previousValue);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    //? event give you value and event
    //? emit allos you to pass state out
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
              inValidValue: event.value, previousValue: state.value),
        );
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });

    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
              inValidValue: event.value, previousValue: state.value),
        );
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
